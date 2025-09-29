module CourseNodesHelper
  def node_kind_chip(node)
    case
    when node.kind_container?
      { icon: "bi-collection", btn: "btn-outline-secondary", label: "Seção" }
    when node.kind_activity?
      { icon: "bi-check2-square", btn: "btn-outline-success", label: "Atividade" }
    else
      { icon: "bi-file-earmark-text", btn: "btn-outline-info", label: "Recurso" }
    end
  end

  def parent_options(course, current_node = nil)
    arranged = course.course_nodes.arrange(order: :position)
    exclude_ids = current_node&.persisted? ? current_node.subtree_ids : []
    flatten_for_select(arranged, exclude_ids)
  end

  private

  def flatten_for_select(tree, exclude_ids, depth = 0)
    tree.flat_map do |node, children|
      next [] if exclude_ids.include?(node.id)
      label = "#{'— ' * depth}#{node.title}"
      [[label, node.id]] + flatten_for_select(children, exclude_ids, depth + 1)
    end
  end
end
