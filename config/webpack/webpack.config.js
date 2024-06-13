const { generateWebpackConfig, merge } = require('shakapacker');

const webpackConfig = generateWebpackConfig();

if (!webpackConfig) {
  throw new Error('generateWebpackConfig did not return a valid configuration. Check your Shakapacker setup.');
};

// See the shakacode/shakapacker README and docs directory for advice on customizing your webpackConfig.
const customConfig = {
};

module.exports = merge(webpackConfig, customConfig);
