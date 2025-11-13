/*
 * OpenMU Admin Panel - Theme Switcher
 * Handles theme switching and persistence for Tailwind CSS v4
 */

(function() {
    'use strict';

    // IMMEDIATELY apply theme (before any rendering)
    const savedTheme = localStorage.getItem('theme') || 'dark';
    const html = document.documentElement;
    if (savedTheme === 'dark') {
        html.classList.add('dark');
    } else {
        html.classList.remove('dark');
    }
    html.setAttribute('data-theme', savedTheme);

    // Initialize theme from localStorage or default to dark
    function initTheme() {
        const theme = localStorage.getItem('theme') || 'dark';
        setTheme(theme);
    }

    // Set theme on document root (uses class for Tailwind CSS v4)
    window.setTheme = function(theme) {
        const html = document.documentElement;
        
        // Tailwind v4 uses the 'dark' class on <html>
        if (theme === 'dark') {
            html.classList.add('dark');
        } else {
            html.classList.remove('dark');
        }
        
        // Keep data-theme for backwards compatibility
        html.setAttribute('data-theme', theme);
        localStorage.setItem('theme', theme);
        
        // Update meta theme-color for mobile browsers
        const metaThemeColor = document.querySelector('meta[name="theme-color"]');
        if (metaThemeColor) {
            metaThemeColor.setAttribute('content', theme === 'dark' ? '#0f172a' : '#ffffff');
        }
    };

    // Get current theme
    window.getTheme = function() {
        const html = document.documentElement;
        return html.classList.contains('dark') ? 'dark' : 'light';
    };

    // Toggle theme
    window.toggleTheme = function() {
        const currentTheme = window.getTheme();
        const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
        window.setTheme(newTheme);
        return newTheme;
    };

    // Initialize on load
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initTheme);
    } else {
        initTheme();
    }
})();
