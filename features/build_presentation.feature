Feature: Build Presentation

  As a speaker
  I want to send my presentation to this service
  In order to get back a compiled version

  Scenario: Send valid source zip file
    Given I use presentation fixture "simple1" with title "This is a title"
    When I send a valid presentation as zip file
    Then I get back a build version of my presentation
