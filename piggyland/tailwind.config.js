module.exports = {
  theme: {
    extend: {
      colors: {
        primary: {
          lighter: '#FBECE6',
          default: '#F98B83',
          darker: '#FF3D6D'
        }
      },
      keyframes: {
        rslide: {
          '0%': { 
            opacity: 0.5,
            transform: 'translateX(-900px)' 
          },
          '100%': { 
            opacity: 1,
            transform: 'translateX(0))' 
          }
        },
        lslide: {
          '0%': { 
            opacity: 0.5,
            transform: 'translateX(900px)' 
          },
          '100%': { 
            opacity: 1,
            transform: 'translateX(0))' 
          }
        }
      },
      animation: {
        rslide: 'rslide 3s ease-in-out',
        lslide: 'lslide 3s ease-in-out'
      }
    }
  },
  variants: {},
  plugins: []
};
