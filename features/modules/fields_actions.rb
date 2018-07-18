## common fields actions
module FieldsActions
  #used in creation scenario
  def fill_input_field_by_label(label_name, value)
    find(:xpath, "//div/label[contains(text(),'#{label_name}')]/following-sibling::input").set(value)
    lost_field_focus_by_js
  end

  def set_text(locator, value)
    locator.set(value)
  end

  def fill_textarea_field_by_label(label_name, value)
    find(:xpath, "//div/label[contains(text(),'#{label_name}')]/following-sibling::textarea").set(value)
    lost_field_focus_by_js
  end

end