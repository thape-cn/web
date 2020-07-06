module.exports = {
  theme: {
    extend: {
      colors: {
        'black6c': 'rgba(16,24,32,1)',
        'black6c-t70': 'rgba(16,24,32,0.7)',
        'gray1c': 'rgba(217,217,214,1)',
        'form-background': 'rgba(252,253,255,1)',
        'thape-white-t80': 'rgba(255,255,255,0.8)',
        'thape-white-t95': 'rgba(255,255,255,0.95)',
        'thape-bg-gray': 'rgba(101,101,101,1)',
        'thape-copyright-gray': 'rgba(140,140,140,1)',
        'thape-icon-gray': 'rgba(149,149,149,1)',
        'thape-darker-gray': 'rgba(158,158,158,1)',
        'thape-city-gray': 'rgba(173,173,178,1)',
        'thape-guest-gray': 'rgba(184,184,184,1)',
        'thape-company-gray': 'rgba(203,203,207,1)',
        'thape-dark-gray': 'rgba(235,235,235,1)',
      },
      fontFamily: {
        sans: ['Montserrat', 'Source Han Sans', 'Source Han Sans SC', 'system-ui', '-apple-system', 'BlinkMacSystemFont', 'Helvetica Neue', 'PingFang SC', 'Microsoft YaHei', 'Noto Sans CJK SC', 'WenQuanYi Micro Hei', 'sans-serif'],
      },
      screens: {
        'xxl': '1500px',
        'xxxl': '1800px',
      },
      spacing: {
        '72': '18rem',
        '84': '21rem',
        '96': '24rem',
      },
      backgroundSize: {
        'w100': '100% auto',
      },
      width: {
        '44': '11rem',
      }
    }
  },
  variants: {},
  plugins: [
    require('@tailwindcss/ui')
  ],
}
