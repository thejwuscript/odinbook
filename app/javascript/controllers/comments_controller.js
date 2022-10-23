import { Controller } from "@hotwired/stimulus"
import { showComments } from "commentsSection"

// Connects to data-controller="comments"
export default class extends Controller {
  static targets = [ "commentsButton", "publishedPost" ];

  commentsButtonTargetConnected(target) {
    target.addEventListener('click', showComments)
  }

  publishedPostTargetConnected(target) {
    const postId = target.id.replace(/\D/g, ''); //string type
    fetch(`/posts/${postId}/comments`, {
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    })
      .then(res => res.json())
      .then(data => {
        const commentCount = data.length;
        if (commentCount == 0) return;

        const span = document.createElement('span');
        span.classList.add('comment-count-line');
        if (commentCount == 1) {
          span.textContent = `1 Comment`;
        } else {
          span.textContent = `${commentCount} Comments`;
        };
        const container = target.querySelector('.counts-container');
        container.appendChild(span);
      });
  }

  connect() {

  }

}
