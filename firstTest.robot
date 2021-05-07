*** Settings ***
Library  SeleniumLibrary

*** Variables ***
${Browser}        chrome
${SiteUrl}        http://automationpractice.com/index.php?controller=authentication&back=my-account

*** Test Cases ***
LoginTest
    Open Browser to the Login Page
    Enter User Name
    Enter Password
    Click Signin

*** Keywords ***
Open Browser to the Login Page
    open browser    ${SiteUrl}    ${Browser}
    Maximize Browser Window

Enter User Name
    Input Text    id=email       bozsozoltan1@gmail.com

Enter Password
    Input Text    id=passwd  example12

Click Signin
    click button    id = SubmitLogin

      [Teardown]    Close Browser