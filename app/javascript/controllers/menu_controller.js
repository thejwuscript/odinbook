import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="menu"
export default class extends Controller {
  static targets = ["menu", "notificationMenu"];

  connect() {
  }

  preventDefault(event) {
    event.preventDefault()
  }

  notificationMenuTargetConnected(element) {
    const notificationButton = document.querySelector('.notification > form > button')
    notificationButton.addEventListener('click', this.preventDefault)
    document.addEventListener('click', (event) => {
      if (!element.contains(event.target)) {
        element.remove();
      };
    });
  };

  notificationMenuTargetDisconnected() {
    const notificationButton = document.querySelector('.notification > form > button');
    notificationButton.removeEventListener('click', this.preventDefault)
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
