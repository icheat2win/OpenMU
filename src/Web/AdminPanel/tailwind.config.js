/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./Pages/**/*.{razor,cshtml}",
    "./Shared/**/*.{razor,cshtml}",
    "./Components/**/*.{razor,cshtml}",
    "./wwwroot/**/*.html"
  ],
  darkMode: 'class', // Enable class-based dark mode
  theme: {
    extend: {
      colors: {
        primary: {
          50: '#eff6ff',
          100: '#dbeafe',
          200: '#bfdbfe',
          300: '#93c5fd',
          400: '#60a5fa',
          500: '#3b82f6',
          600: '#2563eb',
          700: '#1d4ed8',
          800: '#1e40af',
          900: '#1e3a8a',
          950: '#172554',
        },
        accent: {
          cyan: '#06b6d4',
          blue: '#3b82f6',
          purple: '#7c3aed',
        }
      },
      fontFamily: {
        sans: ['-apple-system', 'BlinkMacSystemFont', '"Segoe UI"', 'Roboto', '"Helvetica Neue"', 'Arial', 'sans-serif'],
      }
    },
  },
  plugins: [],
}
