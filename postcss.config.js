const path = require("path")
const tailwindcss = require("tailwindcss")

module.exports = ({ file } = {}) => {
  const isAdmin = file && path.resolve(file) === path.join(__dirname, "app/packs/stylesheets/admin/application.scss")

  const environment = {
    plugins: [
      require("postcss-import"),
      tailwindcss(
        isAdmin ? "./app/packs/stylesheets/admin/tailwind.config.js" : "./app/packs/stylesheets/tailwind.config.js",
      ),
      require("postcss-preset-env")({
        autoprefixer: {
          flexbox: "no-2009",
        },
        stage: 3,
      }),
    ],
  }

  if (process.env.RAILS_ENV === "production" || process.env.RAILS_ENV === "staging") {
    environment.plugins.push(
      require("@fullhuman/postcss-purgecss")({
        content: [
          "./app/**/*.html.erb",
          "./app/helpers/**/*.rb",
          "./app/packs/stylesheets/nav-bar.scss",
          "./app/packs/stylesheets/works.scss",
          "./app/packs/stylesheets/publications.scss",
          "./app/packs/**/*.js",
        ],
        // This is the function used to extract class names from your templates
        defaultExtractor: (content) => {
          // Capture as liberally as possible, including things like `h-(screen-1.5)`
          const broadMatches = content.match(/[^<>"'`\s]*[^<>"'`\s:]/g) || []

          // Capture classes within other delimiters like .block(class="w-1/2") in Pug
          const innerMatches = content.match(/[^<>"'`\s.()]*[^<>"'`\s.():]/g) || []

          return broadMatches.concat(innerMatches)
        },
      }),
    )
  }

  return environment
}
