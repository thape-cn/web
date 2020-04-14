module.exports = {
  theme: {
    extend: {
      colors: {
        'black6c': '#101820',
        'black6c-t70': 'rgb(16,24,32,0.7)',
        'gray1c': '#d9d9d6',
        'thape-white-t80': 'rgb(255,255,255,0.8)',
        'thape-white-t95': 'rgb(255,255,255,0.95)',
        'thape-guest-gray': 'rgb(184,184,184,1)',
        'thape-copyright-gray': 'rgb(140,140,140,1)',
        'thape-icon-gray': 'rgb(149,149,149,1)'
      },
      fontFamily: {
        sans: ['Montserrat', 'Source Han Sans SC', 'system-ui', '-apple-system', 'BlinkMacSystemFont', 'Helvetica Neue', 'PingFang SC', 'Microsoft YaHei', 'Noto Sans CJK SC', 'WenQuanYi Micro Hei', 'sans-serif'],
      },
      screens: {
        'xxl': '1536px',
      },
      spacing: {
        '72': '18rem',
        '84': '21rem',
        '96': '24rem',
      }
    }
  },
  variants: {},
  plugins: [
    require('@tailwindcss/ui')
  ],
}
