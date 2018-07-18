require 'win32ole'
## Wscript login for Internet Explorer method

def login_in_model_window(user, password)
  wsh = WIN32OLE.new('Wscript.Shell')
  wsh.AppActivate('Windows Security')
  wsh.SendKeys(user)
  wsh.SendKeys("{TAB}")
  sleep(1)
  copy_string_to_clipboard(password)
  wsh.SendKeys("^V")
  sleep(0.5)
  clear_buffer
  current_capybara_session.driver.browser.switch_to.alert.accept
  # wsh.SendKeys("{TAB}")
  # wsh.SendKeys("{ENTER}")
end