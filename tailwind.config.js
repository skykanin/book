module.exports = {
  content: [
    './templates/**/*.html',
    './*.html',
    './css/global.css',
  ],
  theme: {
    extend: {
      fontFamily: {
        'sans': ['Victor Mono','Open Sans'],
      },
      colors: {
        'heliotrope-gray': '#aa9fb1',
        'purple-navy': '#4e5283',
        'tuscany': '#cca7a2',
        'mauve' : '#d9bbf9',
        'rebecca-purple': '#9c93de',
        'jet': '#323234',
        'st-patricks-blue': '#222a68',
      }
    },
  },
  plugins: [],
}
