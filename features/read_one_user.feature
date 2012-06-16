Feature: read [username]
  In order to read one user's updates on rstat.us
  I want `rst user [username]` to return all updates by just that user
  So that I can see what they are up to and if I want to follow them or not

  Scenario: read a particular user
    When I run `rst user carols10cents`
    Then the exit status should be 0
    And the output should contain 20 updates

  Scenario: no argument
    When I run `rst user`
    Then the exit status should be 1
    And the output should contain "Username is required."