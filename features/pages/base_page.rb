## Base Page for all pages
require_relative '../../features/modules/button_actions'
require_relative '../../features/modules/drop_downs_actions'
require_relative '../../features/modules/fields_actions'
class BasePage < SitePrism::Page
  include ButtonActions
  include DropDownsActions
  include FieldsActions

end