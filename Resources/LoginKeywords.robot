*** Settings ***
Library     SeleniumLibrary
Variables   ../PageObjects/Locators.py

*** Keywords ***
Open Chrome Browser
    [Arguments]     ${SiteUrl}  ${Browser}
    Open Browser    ${SiteUrl}  ${Browser}
    Maximize Browser Window

Enter UserName
    [Arguments]     ${loginUserName}
    Input Text    id=email      ${loginUserName}    ${username}

Enter Password
    [Arguments]     ${loginPassword}
    Input Text    id=passwd     ${loginPassword}    ${password}

Click SignIn
    Click Button  id=${signInButton}