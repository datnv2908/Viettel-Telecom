const { getDefaultConfig } = require("metro-config");
const { resolver: defaultResolver } = getDefaultConfig.getDefaultValues();
exports.resolver = {
  ...defaultResolver,
  sourceExts: [
    ...defaultResolver.sourceExts,
    "cjs",
  ],
};

// const { getDefaultConfig } = require('metro-config');
// const defaultConfig = getDefaultConfig(__dirname);

// defaultConfig.resolver.sourceExts = [
//   ...defaultConfig.resolver.sourceExts,
//   'cjs',
// ];
// module.exports = defaultConfig;