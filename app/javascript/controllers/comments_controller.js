import { Controller } from "@hotwired/stimulus"
import { showComments } from "commentsSection"

// Connects to data-controller="comments"
export default class extends Controller {
  static targets = [ "commentsButton", "commentCount" ];

  commentsButtonTargetConnected(target) {
    target.addEventListener('click', showComments);
  };

  commentCountTargetConnected(target) {
    target.addEventListener('click', showComments);
  };

  commentCountTargetDisconnected(target) {
    target.removeEventListener('click', showComments);
  }
};
