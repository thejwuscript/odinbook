import parseISO from "parseISO";

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
  commentCount && commentCount.removeEventListener('click', showComments);
  commentCount && commentCount.addEventListener('click', removeCommentsSection);
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
        .then(async res => {
          if (res.ok) {
            const commentData = await res.json();
            const commentsSection = e.target.closest(".comments-section");
            const newComment = await buildIndividualComment({
              ...commentData,
              authorId: commentData.author_id,
              author: data.name,
              authorImageUrl: data.imageUrl,
              createdAt: "now",
            }, data);
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
            form.querySelector("input[type='text']").blur();
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
    form.appendChild(authTokenInput(csrfToken));

    return form;
  };

  const authTokenInput = (token) => {
    const input = document.createElement("input");
    input.type = "hidden";
    input.name = "authenticity_token";
    input.value = token;
    return input;
  }

  const commentAvatar = (url) => {
    return new Promise((resolve, reject) => {
      const img = new Image();
      img.classList.add("profile-pic", "comment");
      img.onload = () => resolve(img);
      img.onerror = reject;
      img.src = url;
    });
  };

  const buildNewCommentContainer = async (data) => {
    const div = document.createElement("div");
    div.classList.add("new-comment-container");
    const form = buildNewCommentForm(data);
    const avatar = await commentAvatar(data.imageUrl);
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
    const frame = document.createElement('turbo-frame');
    frame.id = `comment_${comment.id}`;
    
    const div = document.createElement("div");
    div.classList.add("individual-comment-container");
    const avatar = await commentAvatar(comment.authorImageUrl);

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
    if (comment.authorId === data.currentUserId) div.appendChild(buildEllipsisMenu(comment));

    frame.appendChild(div);
    return frame;
  };

  const buildEllipsisMenu = (comment) => {
    const id = comment.id;
    const postId = comment.postId;
    const ellipsisContainer = document.createElement('div');
    ellipsisContainer.classList.add('ellipsis-container', 'comment');
    ellipsisContainer.dataset.controller = "menu";

    const ellipsisIcon = document.createElement('span');
    ellipsisIcon.classList.add('mdi', 'mdi-dots-horizontal');
    ellipsisIcon.dataset.action = "click->menu#toggleMenu";

    const dropdownContainer = document.createElement('div');
    dropdownContainer.classList.add('ellipsis-dropdown-container');
    dropdownContainer.dataset.menuTarget = "menu";

    const editLink = document.createElement('a');
    editLink.classList.add('item', 'edit-post-link');
    editLink.href = `/posts/${postId}/comments/${id}/edit`;
    editLink.textContent = "Edit";

    const form = document.createElement('form');
    form.method = 'post';
    form.action = `/posts/${postId}/comments/${id}`;

    const methodInput = document.createElement('input');
    methodInput.type = "hidden";
    methodInput.name = "_method";
    methodInput.value = "delete";

    const tokenInput = authTokenInput(csrfToken);

    const deleteBtn = document.createElement('button');
    deleteBtn.textContent = "Delete";
    deleteBtn.classList.add('item');
    deleteBtn.type = "submit";

    form.append(methodInput, tokenInput, deleteBtn);
    dropdownContainer.append(editLink, form);

    ellipsisContainer.append(ellipsisIcon, dropdownContainer);
    return ellipsisContainer;
  }

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
  commentCount && commentCount.removeEventListener('click', removeCommentsSection);
  commentCount && commentCount.addEventListener('click', showComments);
  commentButton.removeEventListener('click', removeCommentsSection);
  commentButton.addEventListener('click', showComments);
};

function updateCommentCount(id, postContainer) {
  const commentCountContainer = postContainer.querySelector(
    ".comment-count-line"
  );
  fetch(`/posts/${id}/comments`)
    .then((res) => res.json())
    .then((data) => {
      let count = data.comments.length;
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

export { showComments, removeCommentsSection };
