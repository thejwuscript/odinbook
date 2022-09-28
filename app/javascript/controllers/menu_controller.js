import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="menu"
export default class extends Controller {
  static targets = ["menu", "notificationMenu"];

  connect() {
  }

  notificationMenuTargetConnected(element) {
    document.body.addEventListener('click', (e) => {
      e.preventDefault();
      element.remove();
    }, {once: true})
  }

  toggleMenu(e) {
    this.menuTarget.classList.toggle("visible");
    if (this.menuTarget.classList.contains("visible")) {
      document.body.addEventListener('click', (event) => {
        if (event.target !== e.target) {
          this.menuTarget.classList.remove('visible');
        }
      })
    }
  }
}
