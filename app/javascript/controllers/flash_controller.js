import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flash"
export default class extends Controller {
  connect() {
    const header = document.querySelector('header');
    if (header) {
      header.style.position = 'sticky';
      header.style.top = `${this.element.offsetHeight - 0.5}px`;
    }  
  }

  remove() {
    this.element.remove();
    const header = document.querySelector('header');
    if (header) header.style.top = 0;
  }
}
