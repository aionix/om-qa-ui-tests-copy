class AddressBookPage < BasePage
  ##login form
element :login_field,     "#LoginForm>input[name=user]"
element :password_field,  "#LoginForm>input[name=pass]"

end