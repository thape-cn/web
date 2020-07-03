const tailwindcss = require('tailwindcss');

const environment = {
  plugins: [
    require('postcss-import'),
    tailwindcss('./app/javascript/stylesheets/tailwind.config.js'),
    require('postcss-flexbugs-fixes'),
    require('postcss-preset-env')({
      autoprefixer: {
        flexbox: 'no-2009',
      },
      stage: 3
    }),
  ]
}

if (process.env.RAILS_ENV === "production" || process.env.RAILS_ENV === "staging") {
  environment.plugins.push(
    require('@fullhuman/postcss-purgecss')({
      content: [
        './app/**/*.html.erb',
        './app/helpers/**/*.rb',
        './app/javascript/**/*.js',
        './app/javascript/**/*.jsx',
      ],
      defaultExtractor: content => content.match(/[\w-/.:]+(?<!:)/g) || []
    })
  )
}

module.exports = environment
