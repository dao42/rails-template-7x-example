// base dependency library, it should be only shared by `admin.js` and `application.js`.
//
import * as ActiveStorage from '@rails/activestorage'
import 'alpinejs'
import * as ActionCable from "@rails/actioncable"
import './channels'

ActiveStorage.start()
window.ActionCable = ActionCable

// Optional: Custom JavaScript for Tailwind-based UI
document.addEventListener('DOMContentLoaded', () => {
  // Initialize any custom components here

  // Mobile menu toggle
  const mobileMenuButton = document.querySelector('[data-mobile-menu]');
  const mobileMenu = document.querySelector('[data-mobile-menu-target]');

  if (mobileMenuButton && mobileMenu) {
    mobileMenuButton.addEventListener('click', () => {
      mobileMenu.classList.toggle('hidden');
    });
  }

  // Dropdown functionality (if not using Alpine.js)
  const dropdownButtons = document.querySelectorAll('[data-dropdown]');

  dropdownButtons.forEach(button => {
    button.addEventListener('click', (e) => {
      e.stopPropagation();
      const target = document.querySelector(`[data-dropdown-target="${button.dataset.dropdown}"]`);
      if (target) {
        target.classList.toggle('hidden');
      }
    });
  });
});
