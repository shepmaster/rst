Feature: world
  In order to read all updates on rstat.us
  I want `rst world` to return all updates
  So that I can see what everyone is up to

  Scenario: default world
    When I run `rst world`
    Then the exit status should be 0
    And the output should contain 20 updates