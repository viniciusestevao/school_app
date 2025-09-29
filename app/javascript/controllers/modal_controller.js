// app/javascript/controllers/modal_controller.js
import { Controller } from "@hotwired/stimulus"
import * as bootstrap from "bootstrap"

export default class extends Controller {
  static targets = ["dialog", "frame"]

  connect() {
    this.bs = bootstrap.Modal.getOrCreateInstance(this.dialogTarget)

    // Abre quando o frame carregar um form (new/edit)
    this.onFrameLoad = () => this.open()
    this.frameTarget.addEventListener("turbo:frame-load", this.onFrameLoad)

    // Fecha quando um turbo-stream mexe no alvo "modal"
    // (update / replace / remove)
    this.onBeforeStreamRender = (ev) => {
      const stream = ev.target
      const target = stream.getAttribute("target")
      const action = stream.getAttribute("action")
      if (target === "modal" && ["update", "replace", "remove"].includes(action)) {
        // espera o stream aplicar as mudanças e fecha
        requestAnimationFrame(() => this.close())
      }
    }
    document.addEventListener("turbo:before-stream-render", this.onBeforeStreamRender)

    // Limpa o conteúdo do frame ao esconder
    this.onHidden = () => { this.frameTarget.innerHTML = "" }
    this.dialogTarget.addEventListener("hidden.bs.modal", this.onHidden)
  }

  disconnect() {
    this.frameTarget.removeEventListener("turbo:frame-load", this.onFrameLoad)
    document.removeEventListener("turbo:before-stream-render", this.onBeforeStreamRender)
    this.dialogTarget.removeEventListener("hidden.bs.modal", this.onHidden)
  }

  open()  { this.bs?.show() }
  close() { this.bs?.hide() }
}
