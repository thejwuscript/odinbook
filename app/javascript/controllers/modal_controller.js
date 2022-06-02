import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = [ "modalcontainer", "input", "output", "modaldialog", "urlField" ]

  show(event) {
    let element = this.modalcontainerTarget;
    event.preventDefault();
    element.style.display = "block";
  };

  close(event) {
    if (event.target.id == 'add-image-modal' || event.target.className == 'mdi mdi-close modal') {
      event.preventDefault();
      let element = this.modalcontainerTarget;
      element.style.display = "none";
      this.modalcontainerTarget.setAttribute('data-action', 'mousedown->modal#addClickAction');
    };
  }

  copy(event) {
    event.preventDefault();
    let url = this.inputTarget.value;
    this.modalcontainerTarget.style.display = "none";
    this.outputTarget.innerHTML = `<img src=${url} class="preview-avatar">`;
    this.urlFieldTarget.value = url;

  };

  addClickAction() {
    const element = this.modalcontainerTarget;
    element.setAttribute('data-action', 'click->modal#close');
  }

  stopPropagation(event) {
    event.stopPropagation();
  }

  removeClickAction() {
    this.modalcontainerTarget.setAttribute('data-action', 'mousedown->modal#addClickAction');
  }
}
