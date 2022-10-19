import { Controller } from "@hotwired/stimulus";
import Cropper from "cropper";
export default class extends Controller {
  static targets = ["output", "input", "newPostImage", "fileFieldRow", "cropperContainer"];

  connect() {
  }

  readImage() {
    let input = this.inputTarget;
    let output = this.outputTarget;

    if (input.files[0]) {
      let reader = new FileReader();

      reader.onload = function () {
        output.src = reader.result;
      };

      reader.readAsDataURL(input.files[0]);
    }
  }

  newPostImageTargetConnected(element) {
    let container = this.cropperContainerTarget;
    element.onload = () => {
      let width = element.naturalWidth;
      let height = element.naturalHeight;
      if ((width > 240) || (height > 240)) {
        container.style.width = "240px";
        container.style.height = "240px";
      } else {
        let length = Math.max(width, height);
        container.style.width = Math.max(200, length) + 'px';
        container.style.height = length + 'px';
      }
    }
    
    const cropper = new Cropper(element, {
      dragMode: 'none',
      modal: false,
      guides: false,
      center: false,
      highlight: false,
      autoCrop: false,
      autoCropArea: 1,
      cropBoxMovable: true,
      cropBoxResizable: false,
      rotatable: true,
      toggleDragModeOnDblclick: false,
      ready() {
      },
    });

    this.appendRotateButton(cropper, element)
  }

  appendRotateButton(cropper, image) {
    const container = this.cropperContainerTarget;
    container.style.position = "relative";
    const button = document.createElement('span');
    button.classList.add('mdi', 'mdi-rotate-right');
    button.addEventListener('click', () => {
      cropper.rotate(90);
    })


    container.appendChild(button);
  }
}
