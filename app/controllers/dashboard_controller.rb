class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @course_count = Course.count
    @activity_count = Activity.count
    @upcoming_activities = Activity.includes(course_node: :course)
                                   .where("due_at >= ?", Time.current)
                                   .order(:due_at)
                                   .limit(5)
  end
end
