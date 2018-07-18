## module for common buttons actions
module ButtonActions

  def press_btn(btn_name)
    find('button', text: btn_name).click
  end

  def press_button(locator)
    locator.click
  end

  def press_tile_by_name(tile_name)
    xpath_expression = "//h4[contains(text(), '#{tile_name}')]"
    find(:xpath, xpath_expression).click
  end

  def press_excel_tab(tab_name)
    find("span.k-link[Title='#{tab_name}']").click
  end

end