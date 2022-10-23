import { Controller } from "@hotwired/stimulus"
import { showComments } from "commentsSection"

// Connects to data-controller="comments"
export default class extends Controller {
  static targets = [ "commentsButton", "publishedPost" ];

  commentsButtonTargetConnected(target) {
    target.addEventListener('click', showComments);
  };

  publishedPostTargetConnected(target) {
    const commentCountLine = target.querySelector('.comment-count-line');
    commentCountLine && commentCountLine.addEventListener('click', showComments);
  };
};
