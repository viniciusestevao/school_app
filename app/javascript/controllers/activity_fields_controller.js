import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["kindSelect", "activityWrap", "destroyField"]

  connect() { this.toggle() }

  toggle() {
    const isActivity = this.kindSelectTarget.value === "activity"
    this.activityWrapTarget.classList.toggle("d-none", !isActivity)

    if (this.hasDestroyFieldTarget) {
      this.destroyFieldTarget.value = isActivity ? "0" : "1"
    }

    this.activityWrapTarget
      .querySelectorAll("input,select,textarea")
      .forEach(el => el.disabled = !isActivity)
  }
}
