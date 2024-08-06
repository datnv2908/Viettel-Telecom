// @generated: @expo/next-adapter@2.1.64
// Learn more: https://github.com/expo/expo/blob/master/docs/pages/versions/unversioned/guides/using-nextjs.md#withexpo

const { withExpo } = require('@expo/next-adapter');
const withImages = require('next-images');

// const BACKEND_HOST = process.env.BACKEND_HOST || 'http://192.168.1.105:8400';
// const HOST = process.env.HOST || 'http://192.168.1.105:8400';

// const BACKEND_HOST = process.env.BACKEND_HOST || 'http://192.168.1.101:8400';
// const HOST = process.env.HOST || 'http://192.168.1.101:8400';

// const BACKEND_HOST = process.env.BACKEND_HOST || 'http://local-a.tivi360.vn:6400';
// const HOST = process.env.HOST || 'http://local-a.tivi360.vn:6400';

const BACKEND_HOST = process.env.BACKEND_HOST || 'http://beta.imuzik.vn';
const HOST = process.env.HOST || 'http://beta.imuzik.vn';

module.exports = withExpo(
  withImages({
    projectRoot: __dirname,
    publicRuntimeConfig: {
      HOST,
      BACKEND_HOST,
      BACKEND_HOST_SSR: process.env.BACKEND_HOST_SSR || BACKEND_HOST,
      AUTO_LOGIN_HOST: process.env.AUTO_LOGIN_HOST || HOST,
    },
  }),

);
