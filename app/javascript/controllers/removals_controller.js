import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static target = [ "flash" ]

  remove() {
    const element = this.flashTarget
    element.remove()
  }
}