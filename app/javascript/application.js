// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";
import attachHandlersToCommentButton from './commentsSection';

document.addEventListener('turbo:load', attachHandlersToCommentButton);
document.addEventListener('load', attachHandlersToCommentButton);

