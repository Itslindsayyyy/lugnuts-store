// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "bootstrap"

document.addEventListener("DOMContentLoaded", function () {
  const toggleBtn = document.getElementById("menu-toggle");
  const mobileNav = document.getElementById("mobile-nav");

  if (toggleBtn && mobileNav) {
    toggleBtn.addEventListener("click", function () {
      mobileNav.classList.toggle("hidden");
    });
  } else {
    console.log("❌ toggleBtn or mobileNav not found");
  }
});

  