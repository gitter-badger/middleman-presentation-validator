Feature: Read presentations from filesystem

  As an presentation builder
  I want to place my presentations in filesystem 
  I want the application to find those presentations in filesystem
  In order to use them in my website

  @wip
  Scenario: Existing presentation
    Given a presentation "test1" with config file:
    """
    author: Dennis Günnewig
    date: 29.10.2014
    description: This is a wonderful presentation
    license: CC BY 4.0
    speaker: Dennis Günnewig
    title: New Title
    version: v0.0.1
    """
    When I request to find new presentations
    Then I should see information about the presentation "New Title" in json response
