## drop downs actions helper
module DropDownsActions

  def select_option_by_element(drop_down_el_object, option)
      drop_down_el_object.click
      within(drop_down_el_object) do
        find('option', text: option, match: :first).click
    end
  end
  #used for Project creation only
  def select_option_by_label(label_name, option)
    xpath_expression = "//label[contains(text(),'#{label_name}')]/parent::div/descendant::select"
    drop_down = find(:xpath, xpath_expression)
    drop_down.click
    within(drop_down) do
      sleep(0.3)
      find(:xpath,"//option[contains(text(),'#{option}')]", match: :first).click
    end
  end
  #used on Projects Dashboard
  def select_tile_option(option_text)
    find(:xpath, "//a[text()='#{option_text}']").click
  end

end