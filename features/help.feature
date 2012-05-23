Feature: Help text
  In order to be easy to learn and familiar
  I want rst to have help text
  So I don't have to look it up outside rst

  Scenario: rst without args
    When I run `rst`
    Then the exit status should be 0
    And the banner should be present
    And the banner should document that this app takes options
    And the following options should be documented:
      |--version|

  Scenario: rst --help
    When I get help for "rst"
    Then the exit status should be 0
    And the banner should be present
    And the banner should document that this app takes options
    And the following options should be documented:
      |--version|
    And the banner should document that this app takes no arguments
