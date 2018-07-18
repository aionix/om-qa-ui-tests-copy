require_relative '../../../features/pages/base_page'

class AddressBookLoginPage < BasePage
  #login page
  element :login_field,           'input[name=user]'
  element :password_field,        'input[name=pass]'
  element :login_button,          "#LoginForm>input[value='Login']"
  element :address_logo,          "#header>a>img[title='Address book']"
  #groups creation form
  element :group_link,:xpath,   "//a[text()='groups']"
  element :new_group_button,              '#content>form>input:nth-of-type(1)'
  element :delete_group_button,           "#content>form>input:nth-of-type(2)"

  element :group_name_field,      'input[name=group_name]'
  element :group_header_field,    'textarea[name=group_header]'
  element :group_footer,          'textarea[name=group_footer'
  element :submit_group_button,           'input[name=submit]'
  ##
  element :window_after_gr_creation, '.msgbox'

  def login(user_name, user_password)
    login_field.set(user_name)
    password_field.set(user_password)
    login_button.click
  end

  def has_address_logo_el?
    has_address_logo? :wait => 2.0
  end

  def create_group(group_data_hash)
    new_group_button.click
    group_name_field.set(group_data_hash[:group_name])
    group_header_field.set(group_data_hash[:group_header])
    group_footer.set(group_data_hash[:group_footer])
    submit_group_button.click
  end

  def open_groups_page
      group_link.click
  end

  def delete_group
    find(:xpath, "//*[@id='content']/form/span[1]/input1").click
    sleep(3)
    delete_group_button.click
    wait_until_window_after_gr_creation_visible(10)
  end


end