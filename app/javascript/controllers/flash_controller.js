import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flash"
export default class extends Controller {
  connect() {
    const header = document.querySelector('header');
    const nav = document.querySelector('.topnav');
    if (header) {
      header.style.position = 'sticky';
      header.style.top = `${this.element.offsetHeight - 0.5}px`;
    };
    if (nav) {
      nav.style.position = 'sticky';
      nav.style.top = `${this.element.offsetHeight - 0.5}px`;
    }
  }

  remove() {
    this.element.remove();
    const header = document.querySelector('header');
    const nav = document.querySelector('.topnav');
    if (header) header.style.top = 0;
    if (nav) nav.style.top = 0;
  }
}
