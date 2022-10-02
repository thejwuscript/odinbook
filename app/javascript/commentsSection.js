import { parseISO, differenceInMinutes } from "date-fns";

function showComments(e) {
  e.target.addEventListener('click', removeCommentsSection);
  e.target.removeEventListener('click', showComments);
  const postId = e.target.dataset.postid;
  const postContainer = e.target.closest(".post-container.published");
  const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute('content')

  const buildNewCommentForm = (data) => {
    const form = document.createElement('form');
    form.dataset.turbo = "false"
    form.action = `/posts/${postId}/comments`;
    form.method = 'post';
    form.addEventListener('submit', async (e) => {
      const commentsSection = e.target.closest('.comments-section');
      const newComment = await buildIndividualComment({author: data.name, body: form.elements['comment_body'].value}, data);
      let showCommentRegion = commentsSection.querySelector('.show-comment-region');
      if (showCommentRegion === null) {
        showCommentRegion = await buildPostCommentsContainer(data);
        commentsSection.appendChild(showCommentRegion);
      };
      showCommentRegion.appendChild(newComment);
      form.reset();
    })

    const input = document.createElement('input');
    input.placeholder = "Type your comment here";
    input.type = "text";
    input.name = "comment[body]";
    input.id = "comment_body";
    form.appendChild(input);

    const hiddenInput = document.createElement('input');
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
      div.prepend(individualComment);
    }
    return div;
  }

  const buildIndividualComment = async (comment, data) => {
    const div = document.createElement('div');
    div.classList.add('individual-comment-container')
    const avatar = await commentAvatar(data);

    const commentDetails = document.createElement('div');
    commentDetails.classList.add('comment-details');

    const textContainer = individualCommentText(comment);

    commentDetails.appendChild(textContainer);

    const time = document.createElement('span');
    time.classList.add('comment-elapsed-time');
    const createdAt = parseISO(comment.createdAt)
    const elapsedTime = differenceInMinutes(new Date(), createdAt) + 'm';
    time.textContent = elapsedTime;

    commentDetails.appendChild(time);

    div.appendChild(avatar);
    div.appendChild(commentDetails);
    return div;
  };

  const individualCommentText = (comment) => {
    const div = document.createElement('div');
    div.classList.add('individual-comment-text-container');

    const author = document.createElement('span');
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
    div.id = `comments-section-${postId}`;
    const newCommentContainer = await buildNewCommentContainer(data);
    div.appendChild(newCommentContainer);

    if (data.postComments.length > 0) {
      const postCommentsContainer = await buildPostCommentsContainer(data);
      div.appendChild(postCommentsContainer);
    };
    
    return div;
  };

  fetch(`/posts/${postId}/comments/new`, {
    headers: {
      "Content-Type": "application/json",
    },
  })
    .then((res) => res.json())
    .then((data) => buildCommentSection(data))
    .then((commentSection) => postContainer.appendChild(commentSection))
};

function removeCommentsSection(e) {
  const postId = e.target.dataset.postid;
  document.getElementById(`comments-section-${postId}`).remove();
  e.target.addEventListener('click', showComments)
  e.target.removeEventListener('click', removeCommentsSection)
};

function attachHandlers() {
  for (const button of document.querySelectorAll(".comment-button")) {
    button.addEventListener('click', showComments)
  };
};

export {attachHandlers, showComments};