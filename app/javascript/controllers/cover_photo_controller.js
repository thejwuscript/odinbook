import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="cover-photo"
export default class extends Controller {
  static targets = [ "menu", "editButton" ];

  

  connect() {
  }

  toggle() {
    const menu = this.menuTarget;
    if (menu.style.display === "none") {
      menu.style.display = "flex";
    } else {
      menu.style.display = "none";
    }
  }

}
