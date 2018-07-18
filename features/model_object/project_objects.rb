class ProjectObjects

  attr_accessor :project_name

  def initialize(options = {})
    @project_name = options.fetch(:project_name, nil)
  end

end