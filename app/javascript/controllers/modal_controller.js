import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = [ "modal", "input", "output", "modaldialog" ]

  show(event) {
    let element = this.modalTarget;
    event.preventDefault();
    element.style.display = "block";
  };

  close(event) {
    if (event.target.id == 'add-image-modal' || event.target.className == 'mdi mdi-close modal') {
      event.preventDefault();
      let element = this.modalTarget;
      element.style.display = "none";
      this.modalTarget.setAttribute('data-action', 'mousedown->modal#addClickAction');
    };
  }

  copy(event) {
    event.preventDefault();
    let url = this.inputTarget.value;
    this.modalTarget.style.display = "none";
    this.outputTarget.innerHTML = `<img src=${url} class="preview-avatar">`;
  };

  addClickAction() {
    const element = this.modalTarget
    element.setAttribute('data-action', 'click->modal#close');
  }

  stopPropagation(event) {
    event.stopPropagation();
  }

  removeClickAction() {
    this.modalTarget.setAttribute('data-action', 'mousedown->modal#addClickAction');
  }
}
