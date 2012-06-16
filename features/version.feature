Feature: Version
  In order to know what version of rst I'm using
  I want rst to print that out
  So I don't have to look it up in the code

  Scenario: rst --version
    When I run `rst --version`
    Then the exit status should be 0
    And the output should be the version
