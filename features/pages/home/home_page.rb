## Home page
class HomePage < BasePage

  ## page elements
  element :transform_type, '#type'
  elements :dates_inputs, "input[placeholder='mm/dd/yyyy']"
  element :tick_icon, '.cr-icon.icon-checkbox-tick-special'
  element :checkbox, 'span.cr'
  element :modal_window, 'div.modal-content'
  element :team_members_window, '.popover.in.popover-top.bs-popover-top.top.add-project'
  element :team_members_input, :xpath, "//label[contains (text(), 'Team members')]/parent::div/descendant::input"
  element :team_member_tick, :xpath, "//div[@class='pop-body']/div/label/span"
  element :search_box, '.form-control'
  element :bca_icon, '.navbar-brand.p-0'

  ### tiles elements
  elements :project_tiles, 'article.col-xs-3.project-tile'
  element :project_title, 'h6.w-100'
  element :transform_type, 'span.small-text'
  element :mixed_dates, 'div.dates.text-muted > div'
  element :client_name, 'div.client-name.text-muted > div'
  element :first_tile, 'article', match: :first
  element :first_container, :xpath, "//*[@class='row']/article[1]"
  element :pic, :xpath, "//div[@class='image-container w-100']/img"
  element :upload, :xpath, "//input[@class='file']", visible: false
  element :tile_edit_button, '.icon-ellipsis-special'

  ## page actions
  def create_project(project_data_hash)
    #//button[@class='btn btn-primary pl-4 pr-4'] use this locator for create_proj when no projects on dashboard
    press_btn('New project')
    wait_for_modal_window
    fill_input_field_by_label('Project name', project_data_hash[:project_name])
    select_option_by_label('Transformation type', project_data_hash[:transform_type])
    set_start_date(project_data_hash[:start_date])
    set_end_date(project_data_hash[:end_date])
    set_confidential(project_data_hash[:confidential])
    fill_input_field_by_label('Client name', project_data_hash[:client_name])
    select_option_by_label('Base year', project_data_hash[:base_year])
    select_option_by_label('Business case time horizon', project_data_hash[:business_case])
    unless project_data_hash[:team_member].nil? && project_data_hash[:team_member2].nil?
      select_member_by_name(project_data_hash[:team_member])
      select_member_by_name(project_data_hash[:team_member2])
    end
    file_path = get_resources_file_path(project_data_hash[:pic])
    upload_logo(file_path)

    press_btn('Create project')
    wait_until_modal_window_invisible(15)
  end

  def upload_logo(file_path)
    if Capybara.current_driver == :internet_explorer
      file_path = file_path.gsub('/', "\\")
    end
    upload.set(file_path)
    sleep(1)
  end

  def set_start_date(date)
    dates_inputs[0].set(date)
    lost_field_focus_by_js
  end

  def set_end_date(date)
    dates_inputs[1].set(date)
    lost_field_focus_by_js
  end

  def set_confidential(value)
    if %w(Yes yes).include? value
      checkbox.click
    end
  end

  def find_tile(tile_title)
    sleep(0.5)
    wait_for_project_tiles
    tile_to_return = nil
    all_tiles = project_tiles
    all_tiles.each do |tile|
      if tile.text.include?(tile_title)
        tile_to_return = tile
        break
      end
    end
    tile_to_return
  end

  def open_project(project_title)
    project_tile = find_tile(project_title)
    project_tile.click
    switch_to_window(windows.last)
  end

  def get_project_tile_data(tile_name)
    tile_data = Hash.new
    project_tile = find_tile(tile_name)
    within(project_tile) do
      tile_data['project_name'] = project_title.text
      tile_data['transform_type'] = transform_type.text
      tile_data['date'] = mixed_dates.text
      tile_data['client_name'] = client_name.text
      tile_data['pic'] = has_a_pic
    end
    tile_data
  end

  def open_first_project
    first_container.click
    switch_to_window(windows.last)
  end

  def select_member_by_name(team_member)
    team_members_input.native.clear
    team_members_input.click
    wait_for_team_members_window
    team_members_input.set(team_member)
    team_member_tick.click
    press_btn('Add')
  end

  def has_a_pic
    has_selector?('.img-responsive').to_s
  end

  def on_project_dashboard_page?
    has_selector?(search_box)
  end

  def remove_project(project_title)
    if has_no_search_box?
      bca_icon.click
      wait_until_search_box_visible
    end
    project_tile = find_tile(project_title)
    project_tile.hover
    wait_for_tile_edit_button
    tile_edit_button.click
    select_tile_option("Delete")
    wait_until_modal_window_visible
    press_btn('Yes')
    wait_until_modal_window_invisible
  end

end