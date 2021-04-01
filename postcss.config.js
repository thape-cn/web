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
        './app/javascript/stylesheets/nav-bar.scss',
        './app/javascript/stylesheets/works.scss',
        './app/javascript/stylesheets/publications.scss',
        './app/javascript/**/*.js',
      ],
      // This is the function used to extract class names from your templates
      defaultExtractor: content => {
        // Capture as liberally as possible, including things like `h-(screen-1.5)`
        const broadMatches = content.match(/[^<>"'`\s]*[^<>"'`\s:]/g) || []

        // Capture classes within other delimiters like .block(class="w-1/2") in Pug
        const innerMatches = content.match(/[^<>"'`\s.()]*[^<>"'`\s.():]/g) || []

        return broadMatches.concat(innerMatches)
      }
    })
  )
}

module.exports = environment
