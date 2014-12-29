Feature: List presentations as JSON
  As an web site builder
  I want to get a list of the presentations in json
  In order to use them in my website

  Scenario: Single presentation
    Given a presentation fixture "presentation"
    When I request a list of presentations as json
    Then I should see information about the presentation "This is a title" in json response

  Scenario: Multiple presentations
    Given a presentation fixture "presentation" with:
      | attribute | value |
      | title     | Title1 |
    And a presentation fixture "presentation" with:
      | attribute | value |
      | title     | Title2 |
    When I request a list of presentations as json
    Then I should see information about the presentation "Title1" in json response
    And I should see information about the presentation "Title2" in json response

