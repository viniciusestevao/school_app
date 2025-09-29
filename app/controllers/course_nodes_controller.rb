class CourseNodesController < ApplicationController
  before_action :set_course
  before_action :set_node, only: %i[edit update destroy move_up move_down reparent]

  def index
    @nodes = @course.course_nodes.order(:ancestry, :position)
    # para render recursivo já montado:
    @arranged = @course.course_nodes.arrange(order: :position)
  end

  def new
    @node = @course.course_nodes.new(parent_id: params[:parent_id])
  end

  def create
    @node = @course.course_nodes.new(node_params)
    if @node.save
      redirect_to course_nodes_path(@course), notice: "Nó criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @node.update(node_params)
      redirect_to course_nodes_path(@course), notice: "Nó atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @node.destroy!
    redirect_to course_nodes_path(@course), notice: "Nó excluído com sucesso."
  end

  # ----- Ordenação simples (setas ↑/↓) -----
  def move_up
    @node.move_higher
    redirect_to course_nodes_path(@course)
  end

  def move_down
    @node.move_lower
    redirect_to course_nodes_path(@course)
  end

  # ----- (Opcional) Trocar o pai via select/POST -----
  def reparent
    new_parent = @course.course_nodes.find_by(id: params[:parent_id])
    @node.parent = new_parent
    @node.save!
    redirect_to course_nodes_path(@course), notice: "Estrutura atualizada."
  end

  def reorder
    node = @course.course_nodes.find(params[:id])

    # mudar de pai (se necessário)
    new_parent_id = params[:parent_id].presence
    if node.parent_id.to_s != new_parent_id.to_s
      node.parent_id = new_parent_id
    end

    # posicionar entre os irmãos (1-based)
    new_position = params[:position].to_i
    new_position = 1 if new_position < 1

    # Salva e reposiciona no escopo
    node.save! if node.changed?
    node.insert_at(new_position)

    head :ok
  end

  private
    def set_course
      @course = Course.find(params[:course_id])
    end

    def set_node
      @node = @course.course_nodes.find(params[:id])
    end

    def node_params
      params.require(:course_node).permit(:title, :description, :kind, :parent_id)
            .merge(course_id: @course.id)
    end
end
