/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{js,ts,jsx,tsx}'],
  theme: {
    extend: {
      colors: {
        primary: { DEFAULT: '#0D1B2A', light: '#1B2D45' },
        accent: { DEFAULT: '#4F46E5', light: '#818CF8' },
        highlight: '#F59E0B',
        surface: '#F8FAFC',
      },
    },
  },
  plugins: [],
};
