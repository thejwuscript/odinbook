import { Controller } from "@hotwired/stimulus"
import { showComments } from "../commentsSection"

// Connects to data-controller="comments"
export default class extends Controller {
  static targets = [ "commentsButton" ];

  commentsButtonTargetConnected(target) {
    target.addEventListener('click', showComments)
  }

  connect() {
  }

}
