import { Controller } from "@hotwired/stimulus"
import { showComments } from "../commentsSection"

// Connects to data-controller="comments"
export default class extends Controller {
  connect() {
    console.log("connected")
  }

  show(e) {
    showComments(e);
  }
}
