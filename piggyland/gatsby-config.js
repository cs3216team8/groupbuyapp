module.exports = {
  plugins: [
    {
      resolve: `gatsby-plugin-google-analytics`,
      options: {
        trackingId: 'UA-182168462-1',
        head: 'true'
      }
    },
    `gatsby-plugin-react-helmet`,
    {
      resolve: `gatsby-theme-codebushi`,
      options: {
        tailwindConfig: `tailwind.config.js`
      }
    },
    {
      resolve: 'gatsby-plugin-react-svg',
      options: {
        rule: {
          include: /\.inline\.svg$/
        }
      }
    },
    {
      resolve: 'gatsby-plugin-mailchimp',
      options: {
        endpoint:
          'https://app.us2.list-manage.com/subscribe/post?u=687be440f1a6d7a51b2293ec6&amp;id=6883babe09', // string; add your MC list endpoint here; see instructions below
        timeout: 3500 // number; the amount of time, in milliseconds, that you want to allow mailchimp to respond to your request before timing out. defaults to 3500
      }
    },
    {
      resolve: `gatsby-plugin-manifest`,
      options: {
        name: 'PiggyBuy',
        short_name: 'PiggyBuy',
        start_url: '/',
        background_color: '#6b37bf',
        theme_color: '#6b37bf',
        // Enables "Add to Homescreen" prompt and disables browser UI (including back button)
        // see https://developers.google.com/web/fundamentals/web-app-manifest/#display
        display: 'standalone',
        icon: 'src/images/pig.svg', // This path is relative to the root of the site.
        // An optional attribute which provides support for CORS check.
        // If you do not provide a crossOrigin option, it will skip CORS for manifest.
        // Any invalid keyword or empty string defaults to `anonymous`
        crossOrigin: `use-credentials`
      }
    },
    {
      resolve: `gatsby-plugin-scroll-reveal`,
      options: {
        threshold: 0.15 // Percentage of an element's area that needs to be visible to launch animation
      }
    }
  ]
};
