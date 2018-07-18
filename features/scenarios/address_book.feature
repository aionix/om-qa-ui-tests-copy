Feature: create a group and verify it was created

  #@debug
  Scenario: User checks page is opened
    Given user opens address book in web-browser
    When user creates a group with such parameters:
    |group_name|group_header|group_footer|
    |auto-ruby|header      |some_footer |
    #Then user verifies that a group has been created

  @debug
  Scenario: User removes first group from the list
    Given user opens address book in web-browser
    When user removes group from the list







