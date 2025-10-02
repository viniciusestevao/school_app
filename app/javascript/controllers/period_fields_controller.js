import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["daysField"]
  static values = { kind: String }

  connect() {
    this.toggle()
  }

  toggle(event) {
    let selected = event ? event.target.value : this.kindValue
    if (selected === "days") {
      this.daysFieldTarget.classList.remove("d-none")
    } else {
      this.daysFieldTarget.classList.add("d-none")
    }
  }
}