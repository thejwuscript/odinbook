import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="account"
export default class extends Controller {
  static targets = ["avatarIcon", "menu"];

  connect() {
  }

  toggleMenu() {
    this.menuTarget.classList.toggle("visible");
  }
}
