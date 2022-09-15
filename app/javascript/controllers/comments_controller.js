import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="comments"
export default class extends Controller {
  connect() {}

  something(e) {
    const postId = e.target.dataset.postid;
    const postContainer = e.target.closest(".post-container.published");

    const buildNewCommentForm = () => {
      const form = document.createElement('form');
      form.action = `/posts/${postId}/comments`;
      form.method = 'post';

      const input = document.createElement('input');
      input.placeholder = "Type your comment here";
      input.type = "text";
      input.name = "comment[body]";
      input.id = "comment_body";

      form.appendChild(input);
      return form;
    }

    const commentAvatar = (data) => {
      return new Promise((resolve, reject) => {
        const img = new Image();
        img.classList.add("profile-pic", "comment");
        img.onload = () => resolve(img)
        img.onerror = reject
        img.src = data.imageUrl;
      });
    };

    const buildNewCommentContainer = async (data) => {
      const div = document.createElement('div');
      div.classList.add("new-comment-container");
      const form = buildNewCommentForm(data);
      const avatar = await commentAvatar(data);
      div.appendChild(avatar);
      div.appendChild(form);
      return div;
    };

    const buildPostCommentsContainer = async (data) => {
      const div = document.createElement('div');
      div.classList.add('show-comment-region');
      for (const comment of data.postComments) {
        let individualComment = await buildIndividualComment(comment, data);
        div.appendChild(individualComment);
      }
      return div;
    }

    const buildIndividualComment = async (comment, data) => {
      const div = document.createElement('div');
      div.classList.add('individual-comment-container')
      const avatar = await commentAvatar(data);
      const textContainer = individualCommentText(comment);

      div.appendChild(avatar);
      div.appendChild(textContainer);
      return div;
    }

    const individualCommentText = (comment) => {
      const div = document.createElement('div');
      div.classList.add('individual-comment-text-container');

      const author = document.createElement('p');
      author.classList.add('comment-author');
      author.textContent = comment.author;

      const body = document.createElement('p');
      body.classList.add('comment-body');
      body.textContent = comment.body;

      div.appendChild(author);
      div.appendChild(body);
      return div;
    };

    const buildCommentSection = async (data) => {
      const div = document.createElement('div');
      div.classList.add('comments-section');
      const newCommentContainer = await buildNewCommentContainer(data);
      const postCommentsContainer = await buildPostCommentsContainer(data);
      div.appendChild(newCommentContainer);
      div.appendChild(postCommentsContainer);
      return div;
    }
    
    fetch(`/posts/${postId}/comments/new`, {
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((res) => res.json())
      //.then(data => console.log(data))
      .then((data) => buildCommentSection(data))
      .then((commentSection) => postContainer.appendChild(commentSection))
  }
}
