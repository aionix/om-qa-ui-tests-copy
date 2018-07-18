class ScenariosListPage < BasePage
  ##
  element :edit_scenario_title,   'h4.modal-title.pull-left', text: 'Edit scenario'
  element :remove_scenario_title, 'h4.modal-title.pull-left', text: 'Remove scenario'
  element :scenario_name, 'h3>span' #used at data-collection page

  ##
  def get_scenario_data_by_name(name)
    scenario_data_hash = {}
    row = find_scenario_by_name(name)
    within(row) do
      scenario_data_hash['scenario_name']   = find('td:nth-of-type(1)').text
      scenario_data_hash['created_by']      = find('td:nth-of-type(2)').text
      scenario_data_hash['created_on']      = find('td:nth-of-type(3)').text
      find('td:nth-of-type(4)').click
      sleep(0.5)
    end
    scenario_data_hash['summary'] = find('.comment-text').text
    scenario_data_hash
  end

  def find_scenario_by_name(name)
    find('tr', text: name)
  end

  def edit_scenario_by_name(name_to_edit, scenario_name, scenario_summary)
    row = find_scenario_by_name(name_to_edit)
    within(row) do
      find('td:nth-of-type(5)').click
      find(:xpath, "//a[text()='Edit']").click
    end
    wait_until_edit_scenario_title_visible
    fill_input_field_by_label('Scenario Name', scenario_name)
    fill_textarea_field_by_label('Scenario Summary', scenario_summary)
    press_btn('Save')
    wait_until_edit_scenario_title_invisible
  end

  def remove_scenario_by_name(name)
    row = find_scenario_by_name(name)
    within(row) do
      find('td:nth-of-type(5)').click
      find(:xpath, "//a[text()='Remove']").click
    end
    wait_until_remove_scenario_title_visible
    press_btn('Remove')
    wait_until_remove_scenario_title_invisible
    sleep(1)
  end

  def has_no_scenario?(name)
    has_no_css?('tr', text: name)
  end

  def click_scenario_by_name(name)
    row = find_scenario_by_name(name)
    within(row) do
      find('td:nth-of-type(1)').click
    end
    wait_until_scenario_name_visible
  end


end