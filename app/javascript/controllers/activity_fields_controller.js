import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["kindSelect", "activityWrap", "destroyField"]

  connect() { this.toggle() }

  toggle() {
    const isActivity = this.kindSelectTarget.value === "activity"
    this.activityWrapTarget.classList.toggle("d-none", !isActivity)

    this.activityWrapTarget
      .querySelectorAll("input,select,textarea")
      .forEach(el => {
        if (!this.hasDestroyFieldTarget || el !== this.destroyFieldTarget) el.disabled = !isActivity
      })

    if (this.hasDestroyFieldTarget) {
      this.destroyFieldTarget.disabled = false
      this.destroyFieldTarget.value = isActivity ? "0" : "1"
    }
  }
}
