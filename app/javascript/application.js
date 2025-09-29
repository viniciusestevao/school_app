import "@hotwired/turbo-rails"
import * as bootstrap from "bootstrap"
import { Application } from "@hotwired/stimulus"
const Stimulus = Application.start()

import TreeController from "./controllers/tree_controller"
Stimulus.register("tree", TreeController)

// -------- Toasts (canto superior direito) --------
function showToasts() {
  document.querySelectorAll(".toast").forEach((el) => {
    bootstrap.Toast.getOrCreateInstance(el).show()
  })
}

// --- Modal de confirmação (API nova do Turbo) ---
let confirmModalInstance, confirmOkBtn, confirmCancelBtn, confirmBody
function setupConfirmModal() {
  const modalEl = document.getElementById("confirmModal")
  if (!modalEl) return

  confirmModalInstance = bootstrap.Modal.getOrCreateInstance(modalEl)
  confirmOkBtn = document.getElementById("confirmOk")
  confirmCancelBtn = document.getElementById("confirmCancel")
  confirmBody = modalEl.querySelector(".modal-body")

  Turbo.config.forms.confirm = (message) => {
    return new Promise((resolve) => {
      if (confirmBody) confirmBody.textContent = message

      const onOk = () => { cleanup(); resolve(true) }
      const onCancel = () => { cleanup(); resolve(false) }
      function cleanup() {
        confirmOkBtn?.removeEventListener("click", onOk)
        confirmCancelBtn?.removeEventListener("click", onCancel)
        confirmModalInstance?.hide()
      }

      confirmOkBtn?.addEventListener("click", onOk, { once: true })
      confirmCancelBtn?.addEventListener("click", onCancel, { once: true })
      confirmModalInstance?.show()
    })
  }
}

// -------- Inicialização a cada navegação Turbo --------
function boot() {
  setupConfirmModal()
  showToasts()
}

document.addEventListener("turbo:load", boot)
// Se quiser suporte a páginas não-Turbo (render inicial sem Turbo), descomente:
// document.addEventListener("DOMContentLoaded", boot)
