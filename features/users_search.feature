Feature: users-search [pattern]
  If I don't know someone's username exactly
  I want to be able to look it up with a pattern

  Scenario: search that returns results
    When I run `rst users-search carols10cent`
    Then the exit status should be 0
    And the output should contain 2 users

  Scenario: search that does not return results
    When I run `rst users-search carols10centz`
    Then the exit status should be 0
    And the output should contain 0 users
    And the output should contain "No users that match."

  Scenario: no argument
    When I run `rst users-search`
    Then the exit status should be 1
    And the output should contain "Username search pattern is required."
