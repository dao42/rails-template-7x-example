// base dependency library, it should be only shared by `admin.js` and `application.js`.
//
import RailsUjs from '@rails/ujs'
import "@hotwired/turbo-rails"
import * as ActiveStorage from '@rails/activestorage'
import 'alpinejs'

Turbo.session.drive = false

RailsUjs.start()
ActiveStorage.start()

import './channels'
import "./controllers"

// Optional: Custom JavaScript for Tailwind-based UI
document.addEventListener('turbo:load', () => {
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