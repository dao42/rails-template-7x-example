import './base'

// TailAdmin specific functionality
document.addEventListener('turbo:load', () => {
  // Theme toggle functionality (if implementing dark mode)
  const themeToggler = document.querySelector('[data-theme-toggler]');
  if (themeToggler) {
    themeToggler.addEventListener('click', () => {
      document.documentElement.classList.toggle('dark');
      localStorage.setItem('theme', document.documentElement.classList.contains('dark') ? 'dark' : 'light');
    });
  }
  
  // Check if user has a theme preference
  if (localStorage.getItem('theme') === 'dark' || 
      (!localStorage.getItem('theme') && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
    document.documentElement.classList.add('dark');
  } else {
    document.documentElement.classList.remove('dark');
  }
});