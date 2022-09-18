import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="account"
export default class extends Controller {
  static targets = ["avatarIcon", "menu"];

  connect() {
  }

  toggleMenu(e) {
    e.stopPropagation();
    this.menuTarget.classList.toggle("visible");
    if (this.menuTarget.classList.contains("visible")) {
      document.body.addEventListener('click', () => {
        this.menuTarget.classList.remove('visible');
      })
    }
  }
}
