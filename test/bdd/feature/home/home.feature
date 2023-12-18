Feature: Home page BDD testing

  After:
  Then clean up after the test

  Scenario: Home page is presented
    Given I'm opening app
    And the app is running
    Then I see {'No TODO found'} text
    And I see {'TODO App'} text

  Scenario: Home page is presented with todo 1 and todo 2
    Given I'm opening app with todos in DB
    And the app is running
    And I see {'TODO App'} text
    Then I see {'title_1'} text
    And I see {'title_2'} text


  @testMethodName: testGoldens

  Scenario: Home page screenshot is verified
    Given The app is rendered
    Then The {'home_page_screenshot'} screenshot verified