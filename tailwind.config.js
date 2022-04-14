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
        'dark-blue-gray': '#7871aa',
        'jet': '#323234',
        'crimson-ua': '#941c2f',
        'dark-salmon': '#F89577',
      }
    },
  },
  plugins: [],
}
