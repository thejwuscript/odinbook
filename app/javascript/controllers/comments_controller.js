import { Controller } from "@hotwired/stimulus"
import { showComments, removeCommentsSection } from "commentsSection"

// Connects to data-controller="comments"
export default class extends Controller {
  static targets = [ "commentsButton", "commentCount", "publishedPost" ];

  commentsButtonTargetConnected(target) {
    target.addEventListener('click', showComments);
  };

  commentCountTargetConnected(target) {
    const publishedPost = this.publishedPostTarget;
    const commentsSection = publishedPost.querySelector('.comments-section');
    if (commentsSection) {
      target.addEventListener('click', removeCommentsSection);
    } else {
      target.addEventListener('click', showComments);
    };
  };

  commentCountTargetDisconnected(target) {
    target.removeEventListener('click', showComments);
  }
};
