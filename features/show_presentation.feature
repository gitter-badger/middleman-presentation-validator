Feature: Show information about presentation as JSON

  As an web site builder
  I want to show information about a presentation in json
  In order to use them in my website

  @wip
  Scenario: Single presentation
    Given a presentation fixture "presentation"
    When I request information about presentation "1" as json
    Then I should see the title "This is a title" in json response
