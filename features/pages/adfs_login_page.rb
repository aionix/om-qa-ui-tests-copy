require_relative '../../features/pages/base_page'

class ADFSLoginPage < BasePage

  element :account, :xpath, "//span[contains(text(),'auth.us.deloitte.com')]"
  element :stage_account, :xpath, "//span[contains(text(),'STG Deloitte professional')]"
  element :login_field, '#userNameInput'
  element :password_field, '#passwordInput'
  element :submit_button, '#submitButton'
  element :adfs_deloitte_logo, "img[src*='/adfs/portal/logo/'"

  def open_login_form(environment)
    if environment == 'QA' || environment == 'DEV'
      account.click
    elsif environment == 'Staging'
      stage_account.click
    end
  end

  def login(user_name, user_password)
    login_field.set(user_name)
    password_field.set(user_password)
    submit_button.click
  end

  def has_accounts_form?
    has_account? :wait => 2.0
  end

  def has_login_field_element?
    has_login_field? :wait => 2.0
  end

  def has_adfs_deloitte_logo_el?
    has_adfs_deloitte_logo?
  end

end