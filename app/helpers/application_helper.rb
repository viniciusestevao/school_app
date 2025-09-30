module ApplicationHelper
  include Pagy::Frontend

  def sort_link(column, label)
    current_sort = params[:sort]
    current_dir  = params[:dir] || 'desc'

    next_dir = (current_sort == column && current_dir == 'asc') ? 'desc' : 'asc'
    active   = (current_sort == column)

    icon = if active
      current_dir == 'asc' ? '▲' : '▼'
    else
      '' # sem ícone quando não está ativo
    end

    new_params = request.query_parameters.merge(sort: column, dir: next_dir, page: nil)

    link_to(
      "#{ERB::Util.html_escape(label)}#{icon.present? ? " <span class='sort-icon'>#{icon}</span>" : ''}".html_safe,
      url_for(new_params),
      class: "text-reset text-decoration-none fw-semibold"
    )
  end
end
