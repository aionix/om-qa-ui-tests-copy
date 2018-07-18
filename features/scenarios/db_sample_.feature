Feature: DB connection examples

  Scenario: 1. Execute some sql query
    Given system connect to sql data base
    When user deletes a project with name auto from data base
