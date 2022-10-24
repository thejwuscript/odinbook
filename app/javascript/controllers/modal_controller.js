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

  imageUrlTargetConnected(element) {
    const submitBtn = this.submitBtnTarget;
    let timerId;
    element.addEventListener('input', (e) => {
      submitBtn.onclick = (e) => e.preventDefault();
      clearTimeout(timerId);
      timerId = setTimeout(() => {
        this.loadImagePreview();
      }, 600)
    })
  }

  show(event) {
    let element = this.modalcontainerTarget;
    event.preventDefault();
    element.style.display = "block";
    document.body.classList.add('no-scroll');
  }

  close(event) {
      event.preventDefault();
      document.body.classList.remove('no-scroll');
      let element = this.modalcontainerTarget;
      element.style.display = "none";
      if (this.imageUrlTarget) this.imageUrlTarget.value = '';
      this.disableImageURL();
      this.disableFileImage();
  }

  selectImage(event) {
    event.preventDefault();
    let url = this.imageUrlTarget.value;
    let file = this.filefrompcTarget;
    let output = this.outputTarget;
    let hiddenURLField = this.hiddenURLFieldTarget;
    let hiddenDataURLField = this.hiddenDataURLFieldTarget;
    const imageURLRadioButton = this.imageURLRadioButtonTarget;
    const imagePreviewContainer = this.imagePreviewContainerTarget;
    const footer = this.modalFooterTarget;
    const link = this.showModalLinkTarget;

    if (imageURLRadioButton.checked && url) {
      const message = footer.querySelector('span') || document.createElement('span');
      message.style.color = "black";
      message.textContent = "Loading image..."
      footer.appendChild(message);
      const image = new Image();
      image.src = url;
      image.onload = () => {
        const oldImg = output.querySelector('img');
        if (oldImg) {
          oldImg.replaceWith(image);
        } else {
          output.appendChild(image);
        }
        image.classList.add("post-image");
        imagePreviewContainer.textContent = '';
        output.style.display = "flex";
        message.remove();
        hiddenURLField.value = url;
        document.body.classList.remove('no-scroll');
        this.disableImageURL();
        this.modalcontainerTarget.style.display = "none";
        // link.removeAttribute('data-action');
      };
      image.onerror = () => {
        message.textContent = "Unable to load image";
        message.color.style = "maroon";
      }
    }
  }

  undoImageAttachment() {
    const output = this.outputTarget;
    output.querySelector('img').remove();
    output.style.display = "none";
    this.hiddenURLFieldTarget.value = ''
    this.hiddenDataURLFieldTarget.value = ''
    this.showModalLinkTarget.dataset.action = "click->modal#show"
  }

  stopPropagation(event) {
    event.stopPropagation();
  }

  disableFileImage() {
    this.labelButtonTarget.setAttribute("for", "post_ximage_file");
    this.imageFileRadioButtonTarget.checked = false;
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
    const imageURLRadioButton = this.imageURLRadioButtonTarget;
    imageURLRadioButton.checked = false;
    this.labelButtonTarget.setAttribute("for", "post_image_file");
    this.filefrompcTarget.disabled = false;
    this.imageUrlTarget.value = "";
    this.imageUrlTarget.disabled = true;
    imagePreviewContainer.textContent = '';
    imagePreviewContainer.style.width = "auto";
    imagePreviewContainer.style.height = "auto";
  }

  showCropper(e) {
    if (e.target.value == '') return;

    const file = this.filefrompcTarget;
    const container = this.imagePreviewContainerTarget;
    this.appendSpinner(container);
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

  clearImagePreviewContainer() {
    this.imagePreviewContainerTarget.textContent = '';
  }

  loadImagePreview() {
    const container = this.imagePreviewContainerTarget;
    const imageUrl = this.imageUrlTarget.value;
    let url;
    try {
      url = new URL(imageUrl).toString();
    } catch {
      return;
    }
    this.appendSpinner(container);
    const img = new Image();
    img.onload = () => {
      img.classList.add('cropper-image-preview');
      container.textContent = '';
      container.style.width = "200px";
      container.style.height = "200px";
      container.appendChild(img);
      this.submitBtnTarget.onclick = (e) => {
        e.preventDefault();
        this.selectImage(e);
      }
    };
    img.onerror = () => {
      container.textContent = '';
      const div = document.createElement('div');
      div.style.cssText = `
        width: 100px;
        height: 100px;
        display: flex;
        align-items: center;
        text-align: center;
        border: 2px dashed grey;
      `;
      div.textContent = "No image available";
      container.appendChild(div);
    }
    img.src = url;
  }

  appendSpinner(container) {
    const loading = document.createElement('div');
    loading.classList.add('loading');
    container.appendChild(loading);
  }

  showPageSpinner(e) {
    const overlay = document.createElement('div');
    overlay.classList.add('page', 'overlay');
    overlay.id = 'page-overlay';
    overlay.style.display = "flex";
    
    const loading = document.createElement('div');
    loading.classList.add('big', 'loading');
    overlay.appendChild(loading);

    document.body.appendChild(overlay);
  }
}
