*** Settings ***
Library  SeleniumLibrary
Library  String
Library  Browser
Resource  ../Resources/LoginKeywords.robot

*** Variables ***
${BROWSER}        chrome
${MyAccountUrl}   http://automationpractice.com/index.php?controller=authentication&back=my-account
${BaseUrl}        http://automationpractice.com/index.php
${username}       bozsozoltan1@gmail.com
${password}       example12

*** Test Cases ***
LoginTest
    Open Browser and successful login
    Search product with keyword
    Go to homepage and select Popular option
    Add products to cart from Popular tab on Home Page
    Delete products from cart
    Purchase products with bank wire

*** Keywords ***
Open Browser and successful login
    Open Chrome Browser    ${MyAccountUrl}    ${BROWSER}
    Enter UserName      ${username}
    Enter Password      ${password}
    Click SignIn
    Wait Until Page Contains    Welcome to your account.

Search product with keyword
    Input Text          id=search_query_top   Printed
    Click Button        name=submit_search
    ${searchKey}        Get Text    xpath=/html/body//h1/*[@class='lighter']
    Should Be Equal As Strings    ${searchKey}    "PRINTED"
    ${searchResultMessage}    Get Text    xpath=/html/body//h1/*[@class='heading-counter']
    Should Be Equal As Strings    ${searchResultMessage}    5 results have been found.

Go to homepage and select Popular option
    Click Image         xpath=//*[@class='logo img-responsive']
    Wait Until Page Contains Element    id:home-page-tabs
    Click Link          xpath=//*[@class='homefeatured']

Add products to cart from Popular tab on Home Page
    Click Image         xpath=//*[@id="homefeatured"]/li[1]/div/div[1]/div/a[1]/img
    Sleep               2s
    ${firstItemId}      Get Text    xpath=//*[@id="product_reference"]/span
    ${firstItemPrice}   Get Text    xpath=//*[@id="our_price_display"]
    Click Button        name=Submit
    ${itemCount}=       Set Variable    1
    Sleep               3s
    Page Should Contain Element     //*[@id="layer_cart"]/div[1]
    ${addCartMessage}   Get Text    xpath=//*[@id="layer_cart"]/div[1]/div[2]/h2/span[2]
    Wait Until Page Contains    Product successfully added
    Should Be Equal As Strings    ${addCartMessage}    There is 1 item in your cart.
    Click Element       xpath=//*[@class='cross']
    Go Back

    reload page
    ${cartQuantity}      Get Text    xpath=//*[@id="header"]/div[3]/div/div/div[3]/div/a/span[1]
    Should Be Equal As Integers    ${cartQuantity}    1

    Click Image          xpath=//*[@id="homefeatured"]/li[2]/div/div[1]/div/a[1]/img
    Sleep                2s
    ${secondItemId}      Get Text    xpath=//*[@id="product_reference"]/span
    ${secondItemPrice}   Get Text    xpath=//*[@id="our_price_display"]
    Click Button         name=Submit
    ${itemCount}=        Evaluate  ${itemCount} + 1
    Sleep                3s

    ${addCartMessage}    Get Text    xpath=//*[@id="layer_cart"]/div[1]/div[2]/h2/span[1]
    Should Be Equal As Strings    ${addCartMessage}    There are 2 items in your cart.
    Click Element        xpath=//*[@class='cross']
    Go Back

    reload page
    ${cartQuantity}    Get Text    xpath=//*[@id="header"]/div[3]/div/div/div[3]/div/a/span[1]
    Should Be Equal As Integers    ${cartQuantity}    2

    Click Link       xpath=//*[@id="header"]/div[3]/div/div/div[3]/div/a
    ${firstItemIdToCheck}     Get Text    xpath=//*[@id="product_1_1_0_497772"]/td[2]/small[1]
    ${secondItemIdToCheck}    Get Text    xpath=//*[@id="product_2_7_0_497772"]/td[2]/small[1]
    Should Contain    ${firstItemIdToCheck}     ${firstItemId}
    Should Contain    ${secondItemIdToCheck}    ${secondItemId}
    Should Be Equal As Integers     2   ${itemCount}

    ${firstItemPriceToCheck}     Get Text    xpath=//*[@id="product_price_1_1_497772"]
    ${secondItemPriceToCheck}    Get Text    xpath=//*[@id="product_price_2_7_497772"]
    Should Be Equal As Strings   ${firstItemPriceToCheck}    ${firstItemPrice}
    Should Be Equal As Strings   ${secondItemPriceToCheck}   ${secondItemPrice}

Delete products from cart
    ${firstItemIdForDelete}=           get element attribute     xpath=//*[@id="1_1_0_497772"]   id
    ${secondItemIdForDelete}=          get element attribute     xpath=//*[@id="2_7_0_497772"]   id
    ${totalAmount}=         Get Text    xpath=//*[@id="total_price"]
    ${totalAmount}=         Remove String   ${totalAmount}        $
    ${totalAmountNum}=      Convert To Number   ${totalAmount}
    ${firstItemPrice}=      Get Text    xpath=//*[@id="total_product_price_1_1_497772"]
    ${secondItemPrice}=     Get Text    xpath=//*[@id="total_product_price_2_7_497772"]
    ${firstItemPriceNum}=   Remove String   ${firstItemPrice}        $
    ${secondItemPriceNum}=  Remove String   ${secondItemPrice}        $
    ${firstItemPriceNum}=   Convert To Number   ${firstItemPriceNum}
    ${secondItemPriceNum}=  Convert To Number   ${secondItemPriceNum}

    Click Link              id:${firstItemIdForDelete}
    Sleep                   2s
    ${totalAmountNumAfterDelete}=     Get Text    xpath=//*[@id="total_price"]
    ${totalAmountNumAfterDelete}=     Remove String   ${totalAmountNumAfterDelete}        $
    ${totalAmountNumAfterDelete}=     Convert To Number   ${totalAmountNumAfterDelete}
    ${reductionAmount}=     Evaluate    ${totalAmountNum} - ${totalAmountNumAfterDelete}
    Should Be Equal As Numbers  ${reductionAmount}  ${firstItemPriceNum}
    Click Link              id:${secondItemIdForDelete}

    Page Should Contain     Your shopping cart is empty.

Purchase products with bank wire
    Go Back
    Click Image             xpath=//*[@id="homefeatured"]/li[1]/div/div[1]/div/a[1]/img
    Click Button            name=Submit
    Sleep                   3s
    Click Element           xpath=//*[@class='cross']
    Click Link              xpath=//*[@id="header"]/div[3]/div/div/div[3]/div/a
    Click Link              xpath=//*[@id="center_column"]/p[2]/a[1]
    Click Button            name=processAddress
    Select Checkbox         id:cgv
    Click Button            name=processCarrier
    Click Link              xpath=//*[@id="HOOK_PAYMENT"]/div[1]/div/p/a
    Click Button            xpath=//*[@id="cart_navigation"]/button
    Page Should Contain     Your order on My Store is complete.

    Close Browser