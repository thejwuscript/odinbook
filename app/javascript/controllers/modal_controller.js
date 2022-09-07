import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = [
    "modalcontainer",
    "input",
    "output",
    "modaldialog",
    "hiddenURLField",
    "hiddenDataURLField",
    "filefrompc",
    "fileField",
    "filename",
    "labelButton",
    "imageFileRadioButton",
    "imageURLRadioButton",
  ];

  show(event) {
    let element = this.modalcontainerTarget;
    event.preventDefault();
    element.style.display = "block";
  }

  close(event) {
    if (
      event.target.id == "add-image-modal" ||
      event.target.className == "mdi mdi-close modal"
    ) {
      event.preventDefault();
      let element = this.modalcontainerTarget;
      element.style.display = "none";
      this.modalcontainerTarget.setAttribute(
        "data-action",
        "mousedown->modal#addClickAction"
      );
    }
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
    }
  }

  copy(event) {
    event.preventDefault();
    let url = this.inputTarget.value;
    let file = this.filefrompcTarget;
    let output = this.outputTarget;
    let hiddenURLField = this.hiddenURLFieldTarget;
    let hiddenDataURLField = this.hiddenDataURLFieldTarget;

    if (this.imageFileRadioButtonTarget.checked && file.files[0]) {
      let reader = new FileReader();
      reader.onload = (e) => {
        const image = new Image();
        image.src = reader.result;
        image.onload = () => {
          image.classList.add("post-image");
          output.appendChild(image);
          output.style.display = "flex";
          this.modalcontainerTarget.style.display = "none";
          hiddenDataURLField.value = reader.result;
        };
        // image.onerror  = () => {}
      };
      reader.readAsDataURL(file.files[0]);
    } else if (this.imageURLRadioButtonTarget.checked && url) {
      const image = new Image();
      image.src = url;
      image.onload = () => {
        image.classList.add("post-image");
        output.appendChild(image);
        output.style.display = "flex";
        this.modalcontainerTarget.style.display = "none";
        hiddenURLField.value = url;
      };
      // image.onerror = () => {}
    }
  }

  addClickAction() {
    const element = this.modalcontainerTarget;
    element.setAttribute("data-action", "click->modal#close");
  }

  stopPropagation(event) {
    event.stopPropagation();
  }

  removeClickAction() {
    this.modalcontainerTarget.setAttribute(
      "data-action",
      "mousedown->modal#addClickAction"
    );
  }

  disableFileImage() {
    this.labelButtonTarget.setAttribute("for", "post_ximage_file");
    this.filefrompcTarget.disabled = true;
    this.filefrompcTarget.value = "";
    this.inputTarget.disabled = false;
    this.filenameTarget.textContent = "";
  }

  disableImageURL() {
    this.labelButtonTarget.setAttribute("for", "post_image_file");
    this.filefrompcTarget.disabled = false;
    this.inputTarget.value = "";
    this.inputTarget.disabled = true;
  }
}
