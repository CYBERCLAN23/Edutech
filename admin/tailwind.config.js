/** @type {import('tailwindcss').Config} */
export default {
  darkMode: 'class',
  content: ['./index.html', './src/**/*.{js,ts,jsx,tsx}'],
  theme: {
    extend: {
      colors: {
        primary: { DEFAULT: '#00677f', light: '#00d2ff' },
        secondary: { DEFAULT: '#055db6', light: '#65a1fe' },
        tertiary: { DEFAULT: '#406900', light: '#87d600' },
        surface: { 
          DEFAULT: '#f7f9fb', 
          container: '#eceef0', 
          'container-high': '#e6e8ea', 
          'container-low': '#f2f4f6', 
          'container-lowest': '#ffffff', 
          dim: '#d8dadc', 
          bright: '#f7f9fb' 
        },
        outline: { DEFAULT: '#6c797f', variant: '#bbc9cf' },
        error: { DEFAULT: '#ba1a1a', container: '#ffdad6' },
        'on-surface': { DEFAULT: '#191c1e', variant: '#3c494e' },
        'on-primary': '#ffffff',
        'on-primary-container': '#00566a',
        'inverse-surface': '#2d3133',
        'inverse-on-surface': '#eff1f3',
        // Dark mode colors
        dark: {
          bg: '#000000',
          surface: '#111111',
          container: '#1a1a1a',
          'container-high': '#222222',
          'container-low': '#181818',
          border: '#2a2a2a',
          'border-strong': '#333333',
          text: '#ffffff',
          'text-secondary': '#a1a1a1',
          'text-muted': '#6b6b6b',
          'on-primary': '#000000',
        },
      },
      fontFamily: { sans: ['Plus Jakarta Sans', 'system-ui', 'sans-serif'] },
      borderRadius: { DEFAULT: '1rem', lg: '2rem', xl: '3rem' },
    },
  },
  plugins: [],
};