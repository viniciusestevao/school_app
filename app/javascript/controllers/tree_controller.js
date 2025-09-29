import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
  static values = { courseId: Number }
  static targets = ["list"] // listas <ul> que aceitam drop

  connect() {
    console.log("[tree] connected")
    this.listTargets.forEach((ul) => {
        Sortable.create(ul, {
        group: "nodes",
        handle: ".drag-handle",
        animation: 150,
        ghostClass: "opacity-50",
        onEnd: (evt) => this.onEnd(evt),
        })
    })
    }

  onEnd(evt) {
    // item arrastado
    const item = evt.item
    const nodeId = item.dataset.nodeId

    // novo pai = dataset.parentId da UL destino (ou "" para raiz)
    const toUL = evt.to
    const newParentId = toUL.dataset.parentId || ""

    // nova posição (index começa em 0, acts_as_list usa 1-based)
    const newPosition = evt.newDraggableIndex + 1

    // chama endpoint para salvar
    const url = `/courses/${this.courseIdValue}/nodes/${nodeId}/reorder`
    fetch(url, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ parent_id: newParentId, position: newPosition })
    }).then(resp => {
      if (!resp.ok) { throw new Error("Falha ao reordenar") }
    }).catch(err => {
      console.error(err)
      // opcional: recarregar para “desfazer”
      window.location.reload()
    })
  }
}
