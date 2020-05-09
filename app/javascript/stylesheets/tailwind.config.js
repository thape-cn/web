module.exports = {
  theme: {
    extend: {
      colors: {
        'black6c': '#101820',
        'black6c-t70': 'rgba(16,24,32,0.7)',
        'gray1c': '#d9d9d6',
        'thape-dark-gray': '#ebebeb',
        'form-background': '#fcfdff',
        'thape-white-t80': 'rgba(255,255,255,0.8)',
        'thape-white-t95': 'rgba(255,255,255,0.95)',
        'thape-guest-gray': 'rgba(184,184,184,1)',
        'thape-copyright-gray': 'rgba(140,140,140,1)',
        'thape-footer-gray': 'rgba(235,235,235,1)',
        'thape-icon-gray': 'rgba(149,149,149,1)',
        'thape-darker-gray': 'rgba(158,158,158,1)',
      },
      fontFamily: {
        sans: ['Montserrat', 'Source Han Sans SC', 'system-ui', '-apple-system', 'BlinkMacSystemFont', 'Helvetica Neue', 'PingFang SC', 'Microsoft YaHei', 'Noto Sans CJK SC', 'WenQuanYi Micro Hei', 'sans-serif'],
      },
      screens: {
        'xxl': '1500px',
        'xxxl': '1800px',
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
