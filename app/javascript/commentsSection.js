import { parseISO } from "date-fns";

function showComments(e) {
  const postContainer = e.currentTarget.closest(".post-container.published");
  // const commentsSection = postContainer.querySelector('.comments-section');
  const postId = e.currentTarget.dataset.postid;
  const commentCount = postContainer.querySelector('.comment-count-line');
  const commentButton = postContainer.querySelector('.comment-button');
  // const icon = e.currentTarget.querySelector(".mdi");
  const csrfToken = document
    .querySelector("meta[name='csrf-token']")
    .getAttribute("content");

  // icon && e.currentTarget.replaceChild(toggleCommentIcon(commentsSection), icon);
  commentCount.removeEventListener('click', showComments);
  commentCount.addEventListener('click', removeCommentsSection);
  commentButton.removeEventListener('click', showComments);
  commentButton.addEventListener('click', removeCommentsSection);
  
  const buildNewCommentForm = (data) => {
    const form = document.createElement("form");
    form.dataset.turbo = "false";
    form.action = `/posts/${postId}/comments`;
    form.method = "post";
    form.addEventListener("submit", async (e) => {
      e.preventDefault();
      const formData = new FormData(e.target);
      fetch(form.action, {
        method: form.method,
        body: formData,
        headers: {
          Accept: "application/json",
        },
      })
        .then(async (res) => {
          if (res.ok) {
            const commentsSection = e.target.closest(".comments-section");
            const newComment = await buildIndividualComment(
              {
                author: data.name,
                body: form.elements["comment_body"].value,
                createdAt: "now",
              },
              data
            );
            let showCommentRegion = commentsSection.querySelector(
              ".show-comment-region"
            );
            if (showCommentRegion === null) {
              showCommentRegion = await buildPostCommentsContainer(data);
              commentsSection.appendChild(showCommentRegion);
            }
            showCommentRegion.appendChild(newComment);
            updateCommentCount(postId, postContainer);
            form.reset();
          } else if (res.status == 422) {
            res.json().then((data) => {
              if (form.querySelector(".comment-form-validation-error-message"))
                return;

              let errorText = "Comment " + data.body[0];
              const errorDisplay = document.createElement("span");
              errorDisplay.textContent = errorText;
              errorDisplay.classList.add(
                "comment-form-validation-error-message"
              );
              form.appendChild(errorDisplay);
            });
          }
        })
        .catch((error) => console.log(error));
    });

    const input = document.createElement("input");
    input.placeholder = "Type your comment here";
    input.type = "text";
    input.name = "comment[body]";
    input.id = "comment_body";
    input.addEventListener("input", () => {
      const errorMsg = form.querySelector(
        ".comment-form-validation-error-message"
      );
      if (errorMsg) errorMsg.remove();
    });
    form.appendChild(input);

    const hiddenInput = document.createElement("input");
    hiddenInput.type = "hidden";
    hiddenInput.name = "authenticity_token";
    hiddenInput.value = csrfToken;
    form.appendChild(hiddenInput);

    return form;
  };

  const commentAvatar = (data) => {
    return new Promise((resolve, reject) => {
      const img = new Image();
      img.classList.add("profile-pic", "comment");
      img.onload = () => resolve(img);
      img.onerror = reject;
      img.src = data.imageUrl;
    });
  };

  const buildNewCommentContainer = async (data) => {
    const div = document.createElement("div");
    div.classList.add("new-comment-container");
    const form = buildNewCommentForm(data);
    const avatar = await commentAvatar(data);
    div.appendChild(avatar);
    div.appendChild(form);
    return div;
  };

  const buildPostCommentsContainer = async (data) => {
    const div = document.createElement("div");
    div.classList.add("show-comment-region");
    for (const comment of data.postComments) {
      let individualComment = await buildIndividualComment(comment, data);
      div.prepend(individualComment);
    }
    return div;
  };

  const buildIndividualComment = async (comment, data) => {
    const div = document.createElement("div");
    div.classList.add("individual-comment-container");
    const avatar = await commentAvatar(data);

    const commentDetails = document.createElement("div");
    commentDetails.classList.add("comment-details");

    const textContainer = individualCommentText(comment);

    commentDetails.appendChild(textContainer);

    const time = document.createElement("span");
    time.classList.add("comment-elapsed-time");
    const elapsedTime = displayableTime(comment.createdAt);
    time.textContent = elapsedTime;

    commentDetails.appendChild(time);

    div.appendChild(avatar);
    div.appendChild(commentDetails);
    return div;
  };

  const displayableTime = (commentTimeInString) => {
    if (commentTimeInString === "now") return "now";
    const earlierTime = parseISO(commentTimeInString);
    const presentTime = new Date().getTime();
    const diff = Math.floor(Math.abs(presentTime - earlierTime) / 1000);
    if (diff < 60) {
      return diff + "s";
    } else if (diff < 3600) {
      return Math.floor(diff / 60) + "m";
    } else if (diff < 86400) {
      return Math.floor(diff / 3600) + "h";
    } else {
      return Math.floor(diff / 86400) + "d";
    }
  };

  const individualCommentText = (comment) => {
    const div = document.createElement("div");
    div.classList.add("individual-comment-text-container");

    const author = document.createElement("span");
    author.classList.add("comment-author");
    author.textContent = comment.author;

    const body = document.createElement("p");
    body.classList.add("comment-body");
    body.textContent = comment.body;

    div.appendChild(author);
    div.appendChild(body);
    return div;
  };

  const buildCommentSection = async (data) => {
    const div = document.createElement("div");
    div.classList.add("comments-section");
    div.id = `comments-section-${postId}`;
    const newCommentContainer = await buildNewCommentContainer(data);
    div.appendChild(newCommentContainer);

    if (data.postComments.length > 0) {
      const postCommentsContainer = await buildPostCommentsContainer(data);
      div.appendChild(postCommentsContainer);
    }

    return div;
  };

  fetch(`/posts/${postId}/comments/new`, {
    headers: {
      "Content-Type": "application/json",
    },
  })
    .then((res) => res.json())
    .then((data) => buildCommentSection(data))
    .then((commentSection) => postContainer.appendChild(commentSection));
}

function removeCommentsSection(e) {
  const postId = e.currentTarget.dataset.postid;
  const commentsSection = document.getElementById(`comments-section-${postId}`);
  // icon && e.currentTarget.replaceChild(toggleCommentIcon(commentsSection), icon);
 
  commentsSection.remove();

  const postContainer = e.currentTarget.closest(".post-container.published");

  const commentCount = postContainer.querySelector('.comment-count-line');
  const commentButton = postContainer.querySelector('.comment-button');
  commentCount.removeEventListener('click', removeCommentsSection);
  commentCount.addEventListener('click', showComments);
  commentButton.removeEventListener('click', removeCommentsSection);
  commentButton.addEventListener('click', showComments);
}

function updateCommentCount(id, postContainer) {
  const commentCountContainer = postContainer.querySelector(
    ".comment-count-line"
  );
  fetch(`/posts/${id}/comments`)
    .then((res) => res.json())
    .then((data) => {
      let count = data.length;
      if (count == 0) commentCountContainer.remove();
      else if (count == 1 && !commentCountContainer)
        initiateCommentCountContainer(id, postContainer);
      else if (count == 1) commentCountContainer.textContent = "1 Comment";
      else commentCountContainer.textContent = `${count} Comments`;
    });
}

function initiateCommentCountContainer(id, postContainer) {
  const countsContainer = postContainer.querySelector(".counts-container");
  const span = document.createElement("span");
  span.classList.add("comment-count-line");
  span.dataset.commentsTarget = 'commentCount';
  span.dataset.postid = id;
  span.textContent = "1 Comment";
  countsContainer.appendChild(span);
}

export { showComments };
