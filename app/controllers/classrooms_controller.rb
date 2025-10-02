class ClassroomsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!, only: %i[new create edit update destroy]
  before_action :set_classroom, only: %i[show edit update destroy]
  rescue_from Pagy::OverflowError, with: :redirect_to_last_page

  SORTABLE_COLUMNS = %w[title created_at].freeze

  def index
    sort = params[:sort].presence_in(SORTABLE_COLUMNS) || 'created_at'
    dir  = params[:dir].in?(%w[asc desc]) ? params[:dir] : 'desc'

    scope = Classroom.includes(:course, :teacher).order("#{sort} #{dir}")

    @pagy, @classrooms = pagy(scope, items: (params[:items] || Pagy::DEFAULT[:items]))
  end

  def show
  end

  def new
    @classroom = Classroom.new
  end

  def create
    @classroom = Classroom.new(classroom_params)
    @classroom.teacher = current_user if current_user.admin?

    if @classroom.save
      redirect_to classrooms_path(page: params[:page]), notice: "Turma criada com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @classroom.update(classroom_params)
      redirect_to classrooms_path(page: params[:page]), notice: "Turma atualizada com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @classroom.destroy
    redirect_to classrooms_path(page: params[:page]), notice: "Turma excluída com sucesso."
  end

  private

  def set_classroom
    @classroom = Classroom.find(params[:id])
  end

  def classroom_params
    params.require(:classroom).permit(:title, :description, :course_id, :teacher_id, student_ids: [])
  end

  def redirect_to_last_page(error)
    redirect_to url_for(page: error.pagy.last)
  end
end
