Feature: Some examples of things you might test.

  @api
  Scenario:
    Given I am on the homepage
    Then I should get a 200 HTTP response

  @api
  Scenario: Test that the user can access the My Account page
    Given I am logged in as a user with the "authenticated user" role
    When I click "My account"
    Then I should see "Member for"
