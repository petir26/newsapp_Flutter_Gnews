const UPSTREAM = 'https://gnews.io/api/v4';
const ALLOWED = {
  '/top-headlines': ['category'],
  '/search': ['q', 'sortby'],
};
const CATEGORIES = new Set([
  'general', 'nation', 'world', 'business', 'technology',
  'entertainment', 'sports', 'science', 'health',
]);
const CACHE_SECONDS = 600;
const CORS = { 'Access-Control-Allow-Origin': '*' };

export default {
  async fetch(request, env, ctx) {
    if (request.method !== 'GET') return json({ errors: ['Method tidak diizinkan'] }, 405);
    const url = new URL(request.url);
    const allowedParams = ALLOWED[url.pathname];
    if (!allowedParams) return json({ errors: ['Endpoint tidak ditemukan'] }, 404);

    const target = new URL(UPSTREAM + url.pathname);
    for (const name of allowedParams) {
      const value = url.searchParams.get(name);
      if (value) target.searchParams.set(name, value);
    }
    if (url.pathname === '/top-headlines') {
      const category = target.searchParams.get('category') ?? 'general';
      if (!CATEGORIES.has(category)) return json({ errors: ['Kategori tidak dikenal'] }, 400);
    }
    if (url.pathname === '/search') {
      const q = url.searchParams.get('q') ?? '';
      if (q.length === 0 || q.length > 100) {
        return json({ errors: { q: 'Kata kunci harus 1-100 karakter' } }, 400);
      }
    }
    target.searchParams.set('lang', 'id');
    target.searchParams.set('country', 'id');
    target.searchParams.set('max', '10');

    const cache = caches.default;
    const cacheKey = new Request(target.toString(), { method: 'GET' });
    const cached = await cache.match(cacheKey);
    if (cached) return cached;

    target.searchParams.set('apikey', env.GNEWS_API_KEY);
    let upstream;
    try {
      upstream = await fetch(target.toString());
    } catch (_) {
      return json({ errors: ['Server berita tidak dapat dihubungi'] }, 502);
    }
    const response = new Response(upstream.body, {
      status: upstream.status,
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        ...CORS,
        'Cache-Control': `public, max-age=${CACHE_SECONDS}`,
      },
    });
    if (upstream.ok) ctx.waitUntil(cache.put(cacheKey, response.clone()));
    return response;
  },
};

function json(body, status) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { 'Content-Type': 'application/json; charset=utf-8', ...CORS },
  });
}
