import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = [
    "modalcontainer",
    "imageUrl",
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
    "imagePreviewContainer",
    "submitBtn"
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
      this.imageUrlTarget.value = '';
  }

  copy(event) {
    event.preventDefault();
    let url = this.imageUrlTarget.value;
    let file = this.filefrompcTarget;
    let output = this.outputTarget;
    let hiddenURLField = this.hiddenURLFieldTarget;
    let hiddenDataURLField = this.hiddenDataURLFieldTarget;
    const footer = this.modalFooterTarget;
    const link = this.showModalLinkTarget;

    if (this.imageURLRadioButtonTarget.checked && url) {
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
        this.imageUrlTarget.value = '';
      };
      // image.onerror
    }
  }

  undoImageAttachment() {
    const output = this.outputTarget;
    output.querySelector('img').remove();
    output.style.display = "none";
    this.hiddenURLFieldTarget.value = ''
    this.hiddenDataURLFieldTarget.value = ''
    // this.showModalLinkTarget.dataset.action = "click->modal#show"
  }

  stopPropagation(event) {
    event.stopPropagation();
  }

  disableFileImage() {
    this.labelButtonTarget.setAttribute("for", "post_ximage_file");
    this.filefrompcTarget.disabled = true;
    this.filefrompcTarget.value = "";
    this.imageUrlTarget.disabled = false;
    this.submitBtnTarget.onclick = (e) => e.preventDefault();
    const imagePreviewContainer = this.imagePreviewContainerTarget;
    imagePreviewContainer.textContent = '';
    imagePreviewContainer.style.width = "auto";
    imagePreviewContainer.style.height = "auto";
  }

  disableImageURL() {
    const imagePreviewContainer = this.imagePreviewContainerTarget;
    this.labelButtonTarget.setAttribute("for", "post_image_file");
    this.filefrompcTarget.disabled = false;
    this.imageUrlTarget.value = "";
    this.imageUrlTarget.disabled = true;
    imagePreviewContainer.textContent = '';
    imagePreviewContainer.style.width = "auto";
    imagePreviewContainer.style.height = "auto";
  }

  showCropper(e) {
    const file = this.filefrompcTarget;
    const container = this.imagePreviewContainerTarget;

    let reader = new FileReader();
    reader.onload = () => {
      const img = new Image();
      img.src = reader.result;
      img.classList.add('cropper-image-preview');
      img.setAttribute('data-image-preview-target', 'newPostImage');
      container.textContent = '';
      container.style.width = "200px";
      container.style.height = "200px";
      container.appendChild(img);
    }
    reader.readAsDataURL(file.files[0]);
  }

  loadImagePreview(e) {
    const container = this.imagePreviewContainerTarget;
    container.textContent = '';
    let url;
    try {
      url = new URL(e.target.value).toString();
    } catch {
      return;
    }
    const img = new Image();
    img.onload = () => {
      img.classList.add('cropper-image-preview');
      container.textContent = '';
      container.style.width = "200px";
      container.style.height = "200px";
      container.appendChild(img);
    };
    img.onerror = () => {
      const div = document.createElement('div');
      div.style.cssText = `
        width: 100px;
        height: 100px;
        display: flex;
        align-items: center;
        text-align: center;
        border: 2px dashed grey;
      `;
      div.textContent = "No image available.";
      container.appendChild(div);
    }
    img.src = url;
  }
}
