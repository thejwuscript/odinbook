import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["output", "input"];

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
}
