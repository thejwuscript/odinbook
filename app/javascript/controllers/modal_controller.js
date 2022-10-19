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
    "labelButton",
    "imageFileRadioButton",
    "imageURLRadioButton",
    "modalFooter",
    "showModalLink",
    "cropperContainer"
  ];

  show(event) {
    let element = this.modalcontainerTarget;
    event.preventDefault();
    element.style.display = "block";
  }

  close(event) {
      event.preventDefault();
      let element = this.modalcontainerTarget;
      element.style.display = "none";
      this.inputTarget.value = '';
  }

  copy(event) {
    event.preventDefault();
    let url = this.inputTarget.value;
    let file = this.filefrompcTarget;
    let output = this.outputTarget;
    let hiddenURLField = this.hiddenURLFieldTarget;
    let hiddenDataURLField = this.hiddenDataURLFieldTarget;
    const footer = this.modalFooterTarget;
    const link = this.showModalLinkTarget;

    if (this.imageFileRadioButtonTarget.checked && file.files[0]) {
      const message = document.createElement('span');
      message.textContent = "Loading image..."
      footer.appendChild(message);
      let reader = new FileReader();
      reader.onload = (e) => {
        const image = new Image();
        image.src = reader.result;
        image.onload = () => {
          image.classList.add("post-image");
          image.id = "preview-image";
          image.setAttribute("data-image-preview-target", "newPostImage");
          output.appendChild(image);
          output.style.display = "block";
          this.modalcontainerTarget.style.display = "none";
          message.remove();
          link.removeAttribute("data-action");
          hiddenDataURLField.value = reader.result;
          this.inputTarget.value = '';
        };
        // image.onerror  = () => {}
      };
      reader.readAsDataURL(file.files[0]);
    } else if (this.imageURLRadioButtonTarget.checked && url) {
      const message = document.createElement('span');
      message.textContent = "Loading image..."
      footer.appendChild(message);
      const image = new Image();
      image.src = url;
      image.onload = () => {
        image.classList.add("post-image");
        output.appendChild(image);
        output.style.display = "flex";
        this.modalcontainerTarget.style.display = "none";
        message.remove();
        link.removeAttribute("data-action");
        hiddenURLField.value = url;
        this.inputTarget.value = '';
      };
      // image.onerror = () => {}
    }
  }

  undoImageAttachment() {
    document.querySelector('img.post-image').remove();
    this.outputTarget.style.display = "none"
    this.hiddenURLFieldTarget.value = ''
    this.hiddenDataURLFieldTarget.value = ''
    this.showModalLinkTarget.dataset.action = "click->modal#show"
  }

  stopPropagation(event) {
    event.stopPropagation();
  }


  disableFileImage() {
    this.labelButtonTarget.setAttribute("for", "post_ximage_file");
    this.filefrompcTarget.disabled = true;
    this.filefrompcTarget.value = "";
    this.inputTarget.disabled = false;
  }

  disableImageURL() {
    this.labelButtonTarget.setAttribute("for", "post_image_file");
    this.filefrompcTarget.disabled = false;
    this.inputTarget.value = "";
    this.inputTarget.disabled = true;
  }

  showCropper(e) {
    const file = this.filefrompcTarget;
    const container = this.cropperContainerTarget;

    let reader = new FileReader();
    reader.onload = () => {
      const img = new Image();
      img.src = reader.result;
      img.classList.add('post-image-preview');
      img.setAttribute('data-image-preview-target', 'newPostImage');
      container.textContent = '';
      container.appendChild(img);
    }
    reader.readAsDataURL(file.files[0]);
  }
}
