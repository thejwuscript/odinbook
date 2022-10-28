# Pin npm packages by running ./bin/importmap

pin 'application', preload: true
pin '@hotwired/turbo-rails', to: 'turbo.min.js', preload: true
pin '@hotwired/stimulus', to: 'stimulus.min.js', preload: true
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js', preload: true
pin 'date-fns', to: 'https://ga.jspm.io/npm:date-fns@2.29.3/esm/index.js'
# pin "cropperjs", to: "https://ga.jspm.io/npm:cropperjs@1.5.12/dist/cropper.js", preload: true
pin 'commentsSection'
pin 'cropper'
pin_all_from 'app/javascript/controllers', under: 'controllers'
