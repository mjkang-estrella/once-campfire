import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static classes = [ "toggle" ]

  toggle() {
    this.element.classList.toggle(this.toggleClass)
  }

  remove() {
    this.element.classList.remove(this.toggleClass)
  }
}
