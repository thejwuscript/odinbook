# Pin npm packages by running ./bin/importmap

pin 'application', preload: true
pin '@hotwired/turbo-rails', to: 'turbo.min.js', preload: true
pin '@hotwired/stimulus', to: 'stimulus.min.js', preload: true
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js', preload: true
pin 'parseISO', to: 'https://ga.jspm.io/npm:date-fns@2.29.3/esm/parseISO/index.js'
pin 'cropperjs', to: 'https://ga.jspm.io/npm:cropperjs@1.5.12/dist/cropper.js'
pin 'commentsSection'
pin_all_from 'app/javascript/controllers', under: 'controllers'
