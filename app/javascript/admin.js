import './base'

document.addEventListener('DOMContentLoaded', () => {
  const themeController = document.querySelector('.theme-controller');
  if (!themeController) return;

  const isDarkKey = 'admin-isdark';

  const savedIsDark = JSON.parse(localStorage.getItem(isDarkKey) || 'false');

  themeController.checked = savedIsDark;
  document.documentElement.setAttribute('data-theme', savedIsDark ? 'dark' : 'light');

  themeController.addEventListener('change', () => {
    const isDark = themeController.checked;
    localStorage.setItem(isDarkKey, JSON.stringify(isDark));
    document.documentElement.setAttribute('data-theme', isDark ? 'dark' : 'light');
  });
});
