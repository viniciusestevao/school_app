class CoursesController < ApplicationController
  before_action :set_course, only: %i[ show edit update destroy ]
  rescue_from Pagy::OverflowError, with: :redirect_to_last_page

  SORTABLE_COLUMNS = %w[title description created_at].freeze

  def index
    sort = params[:sort].presence_in(SORTABLE_COLUMNS) || 'created_at'
    dir  = params[:dir].in?(%w[asc desc]) ? params[:dir] : 'desc'

    scope = Course.order("#{sort} #{dir}")   # seguro porque sort vem da whitelist

    @pagy, @courses = pagy(scope, items: (params[:items] || Pagy::DEFAULT[:items]))
  end


  def show
  end

  def new
    @course = Course.new
  end

  def edit
    @course = Course.find(params[:id])
    @arranged_nodes = @course.course_nodes.arrange(order: :position)
  end

  def create
    @course = Course.new(course_params)

    if @course.save
      redirect_to courses_path(page: params[:page]), notice: "Curso criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @course.update(course_params)
      redirect_to courses_path(page: params[:page]), notice: "Curso atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @course.destroy!
    redirect_to courses_path(page: params[:page]), notice: "Curso excluído com sucesso."
  end

  private
    def set_course
      @course = Course.find(params[:id])
    end

    def course_params
      params.require(:course).permit(:title, :description)
    end

    def redirect_to_last_page(error)
      redirect_to url_for(page: error.pagy.last)
    end
end
