import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="cover-photo"
export default class extends Controller {
  static targets = [ "menu", "editButton" ];

  connect() {
  }

  toggle(e) {
    e.stopPropagation();
    this.menuTarget.classList.toggle("visible");
    if (this.menuTarget.classList.contains("visible")) {
      document.body.addEventListener('click', () => {
        this.menuTarget.classList.remove('visible');
      })
    }
  }

}
