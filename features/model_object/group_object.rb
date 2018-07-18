class GroupObject
  attr_accessor :group_name, :group_header, :group_footer

  def initialize(options = {})
    @group_name = options.fetch(:group_name, nil)
  end
end