/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.erb'
  ],
  darkMode: 'class',
  theme: {
  },
  plugins: [
    require('daisyui'),
  ],
  daisyui: {
    themes: ['cupcake', 'light', 'dark'],
    darkTheme: "dark",
    base: true,
    styled: true,
    utils: true,
    prefix: "",
    logs: false,
    themeRoot: ":root",
  },
}
