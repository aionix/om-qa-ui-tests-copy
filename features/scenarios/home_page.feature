Feature: Checks Home page functionality


  Background: User opens and login to portal
    Given user opens the BCA portal in web-browser
    And system sets Rest Api general parameters

  @implemented @smoke
  Scenario: 1. User verifies that a created project is present on Home page with corresponding data in tile
    When user creates a new project with such parameters from Home page:
      | project_name | transform_type         | start_date | end_date   | confidential | client_name | base_year | business_case |   pic          |
      | auto         | HR Technology Strategy | 12/04/2017 | 12/04/2018 | No           | Client      | 2018      | 9 years       |           1600x900.gif |
    Then user verifies that new project is created and present on Home page
      | project_name | transform_type         | date                    | client_name | pic  |
      | auto         | HR Technology Strategy | 12/04/2017 - 12/04/2018 | Client      | true |
    And user removes just created project by Rest Api

  @implemented @smoke
  Scenario: 2. User creates a new project from Home page and verifies data on Project details page
    When user creates a new project with such parameters from Home page:
      | project_name | transform_type         | start_date | end_date   | confidential | client_name | base_year | business_case | team_member | team_member2 | pic          |
      | auto         | HR Technology Strategy | 12/04/2017 | 12/04/2018 | No           | Client      | 2018      | 9 years       | Hennadii    | Oleg         | 1600x900.gif |
    And user opens created Project from Home page
    Then user observes a project data on Project Detailed page:
      | project_name | transform_type         | date                    | client_name | base_year       | business_case | team_member                        | pic  |
      | auto         | HR Technology Strategy | 12/04/2017 - 12/04/2018 | Client      | Base year: 2018 | 9 years       | bca_user bca_user / 2 Team member(s) | true |
    And user removes just created project by Rest Api

  @implemented @smoke
  Scenario: 3. User verifies that created project can be removed
    Given user creates a new project with such parameters from Home page:
      | project_name | transform_type           | start_date | end_date   | confidential | client_name | base_year | business_case | pic          |
      | auto         | Global HR Transformation | 12/05/2018 | 03/07/2019 | No           | Client      | 2018      | 3 years       | 1600x900.gif |
    And user removes just created project