import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="menu"
export default class extends Controller {
  static targets = ["menu", "notificationMenu", "notificationButton"];

  connect() {
  }

  preventDefault(event) {
    event.preventDefault()
  }

  menuTargetConnected() {
    window.addEventListener('resize', () => {
      if (window.innerWidth < 768) {
        this.menuTarget.classList.remove('visible');
      };
    });
  };

  notificationMenuTargetConnected(element) {
    this.notificationButtonTarget.addEventListener('click', this.preventDefault)
    document.addEventListener('click', (event) => {
      if (!element.contains(event.target)) element.remove();
    });
  };

  notificationMenuTargetDisconnected() {
    this.notificationButtonTarget.removeEventListener('click', this.preventDefault)
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
