import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = [ "modal" ]

  show(event) {
    let element = this.modalTarget;
    event.preventDefault();
    element.style.display = "block";
  };

  close(event) {
    event.preventDefault();
    if (event.target.id == 'add-image-modal' || event.target.className == 'mdi mdi-close') {
      let element = this.modalTarget
      element.style.display = "none";
    };
  }
}
