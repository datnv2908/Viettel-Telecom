const { createServerAsync } = require('@expo/next-adapter');
const { createProxyMiddleware } = require('http-proxy-middleware');
const { parse } = require('url');

const dev = process.env.NODE_ENV !== 'production';
console.log(process.env.BACKEND_HOST);
const proxy =
  dev &&
  // createProxyMiddleware({
  //   target: process.env.BACKEND_HOST || 'http://local-a.tivi360.vn:6400',
  // });

  createProxyMiddleware({
    target: process.env.BACKEND_HOST || 'http://beta.imuzik.vn',
  });

  // createProxyMiddleware({
  //   target: process.env.BACKEND_HOST || 'http://192.168.1.105:8400',
  // });

// eslint-disable-next-line no-undef
createServerAsync(__dirname, {
  handleRequest(req, res) {
    const parsedUrl = parse(req.url, true);
    const { pathname } = parsedUrl;

    // handle GET request to /cool-file.png
    if (dev && pathname.startsWith('/api-v2')) {
      proxy(req, res);
      return true;
    }
  },
}).then(({ server, app }) => {
  const port = 8400;
  server.listen(port, () => {
    console.log(`> Ready on http://localhost:${port}`);
  });
});
