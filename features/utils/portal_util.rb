### portal helper
def current_capybara_session
  Capybara.current_session
end

def refresh_page
  current_capybara_session.driver.browser.navigate.refresh
end

def lost_field_focus_by_js
  capybara_session = current_capybara_session
  script_to_lost_focus = "$(':focus').blur()"
  capybara_session.execute_script(script_to_lost_focus)
end

def alert_present?
  begin
    current_capybara_session.driver.browser.switch_to.alert
    p 'Alert is shown'
    true
  rescue
    return false
  end
end