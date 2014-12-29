Feature: Generate rss feed for available presentations

  As an web site builder
  I want to get a list of the presentations as rss feed
  In order to stay upto date

  Scenario: Single presentation
    Given a presentation fixture "presentation" with:
      | attribute | value |
      | title     | Title1 |
    When I request a rss feed for available presentations
    Then I should see information about the presentation "Title1" in rss feed

  Scenario: Multiple presentations
    Given a presentation fixture "presentation" with:
      | attribute | value |
      | title     | Title1 |
    And a presentation fixture "presentation" with:
      | attribute | value |
      | title     | Title2 |
    When I request a rss feed for available presentations
    Then I should see information about the presentation "Title1" in rss feed
    And I should see information about the presentation "Title2" in rss feed
