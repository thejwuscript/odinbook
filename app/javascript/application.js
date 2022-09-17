// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";
import {attachHandlers, showComments} from './commentsSection';

// document.addEventListener('turbo:load', attachHandlers);
// document.addEventListener('load', attachHandlers);