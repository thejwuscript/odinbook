import { Controller } from "@hotwired/stimulus";
import Cropper from "cropper";
export default class extends Controller {
  static targets = ["output", "input", "newPostImage", "cropperContainer", "submitBtn", "filefrompc", "output", "modalContainer"];

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
    const output = this.outputTarget;
    const modal = this.modalContainerTarget;
    const imageType = this.filefrompcTarget.files[0].type;
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
      minContainerWidth: 0,
      minContainerHeight: 0,
      restore: false,
      responsive: false,
      ready() {
        const imageData = this.cropper.getImageData();
        if (imageData.naturalWidth < 200 && imageData.naturalHeight < 200) this.cropper.zoomTo(1);
      },
    });
    this.appendRotateButton(cropper, element)

    this.submitBtnTarget.onclick = (e) => {
      e.preventDefault();
      let dataURL = cropper.getCroppedCanvas().toDataURL();
      let img = new Image();
      img.classList.add('post-image');
      img.onload = () => {
        output.querySelectorAll('img').forEach(element => element.remove());
        modal.style.display = "none";
        output.appendChild(img);
        output.style.display = "block";
      }
      img.src = dataURL;
    }
  }

  appendRotateButton(cropper) {
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
