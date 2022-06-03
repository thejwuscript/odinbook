import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = [ "modalcontainer", "input", "output", "modaldialog", "urlField", "filefrompc", "fileField",
    "filename", "labelButton" ]

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

  showFilename() {
    let file = this.filefrompcTarget;
    let display = this.filenameTarget;
    if (file.files[0]) {
      display.textContent = file.files[0].name;
      display.style.whiteSpace = "nowrap";
      display.style.overflow = "hidden";
      display.style.textOverflow = "ellipsis";
      display.style.display = "inline-block";
      display.style.width = "60%";
    };
  }

  copy(event) {
    event.preventDefault();
    let url = this.inputTarget.value;
    let file = this.filefrompcTarget;
    let output = this.outputTarget;

    if (file.files[0]) {
      let reader = new FileReader();
      reader.onload = (e) => {
        output.innerHTML = `<img src=${reader.result} class="preview-avatar">`;
      };
      reader.readAsDataURL(file.files[0]);
      this.modalcontainerTarget.style.display = "none";
    };
    if (url) {
      this.modalcontainerTarget.style.display = "none";
      this.outputTarget.innerHTML = `<img src=${url} class="preview-avatar">`;
      this.urlFieldTarget.value = url;
    };
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

  disableFileImage() {
    this.labelButtonTarget.setAttribute('for', "xpost_image_file");
    this.filefrompcTarget.disabled = true;
    this.inputTarget.disabled = false;
    this.filenameTarget.textContent = "";
  }

  disableImageURL() {
    this.labelButtonTarget.setAttribute('for', "post_image_file");
    this.filefrompcTarget.disabled = false;
    this.inputTarget.value = "";
    this.inputTarget.disabled = true;
  }
}
