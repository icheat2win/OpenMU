/*
 * OpenMU Admin Panel - Theme Switcher
 * Handles theme switching and persistence
 */

(function() {
    'use strict';

    // Initialize theme from localStorage or default to dark
    function initTheme() {
        const savedTheme = localStorage.getItem('theme') || 'dark';
        setTheme(savedTheme);
    }

    // Set theme on document root
    window.setTheme = function(theme) {
        document.documentElement.setAttribute('data-theme', theme);
        localStorage.setItem('theme', theme);
        
        // Update meta theme-color for mobile browsers
        const metaThemeColor = document.querySelector('meta[name="theme-color"]');
        if (metaThemeColor) {
            metaThemeColor.setAttribute('content', theme === 'dark' ? '#0f172a' : '#ffffff');
        }
    };

    // Get current theme
    window.getTheme = function() {
        return document.documentElement.getAttribute('data-theme') || 'dark';
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
