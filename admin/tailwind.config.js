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
        surface: { DEFAULT: '#f7f9fb', container: '#eceef0', 'container-high': '#e6e8ea', 'container-low': '#f2f4f6', 'container-lowest': '#ffffff', dim: '#d8dadc', bright: '#f7f9fb' },
        outline: { DEFAULT: '#6c797f', variant: '#bbc9cf' },
        error: { DEFAULT: '#ba1a1a', container: '#ffdad6' },
        'on-surface': { DEFAULT: '#191c1e', variant: '#3c494e' },
        'on-primary': '#ffffff',
        'on-primary-container': '#00566a',
        'inverse-surface': '#2d3133',
        'inverse-on-surface': '#eff1f3',
      },
      fontFamily: { sans: ['Plus Jakarta Sans', 'system-ui', 'sans-serif'] },
      borderRadius: { DEFAULT: '1rem', lg: '2rem', xl: '3rem' },
    },
  },
  plugins: [],
};
