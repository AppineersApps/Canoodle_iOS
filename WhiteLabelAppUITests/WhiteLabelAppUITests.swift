//
//  WhiteLabelAppUITests.swift
//  WhiteLabelAppUITests
//
//  Created by hb on 01/10/19.
//  Copyright © 2019 hb. All rights reserved.
//

import XCTest

class WhiteLabelAppUITests: XCTestCase {
    
    let delay = TimeInterval(2)
    let apiDelay = TimeInterval(10)
    
    let app = XCUIApplication()
    let scrollViewsQuery = XCUIApplication().scrollViews
    let elementsQuery = XCUIApplication().scrollViews.otherElements
    
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = true
        
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        let app = XCUIApplication()
     
        setupSnapshot(app)
        app.launch()
        
//        let emailFlow = LoginEmailUITest()
//        emailFlow.testLoginValidiationExample()
        
        //Phone Testcase
             //   self.phoneTestCase()

        // Email Testcase
      // self.emailTestCase()
    }

//    func phoneTestCase() {
//        let signUpEmail = SignUpViewControllerUITests()
//        signUpEmail.testPhoneSignUp()
//
//        self.logOut()
//
//        let skipFlow = LoginPhoneUITest()
//        skipFlow.testSkipFlow()
//
//        XCUIApplication().launch()
//
//        skipFlow.testLoginPhoneFlow()
//
//        self.login()
//
//        let editProfile = EditProfileUITest()
//        editProfile.testPhoneEditProfile()
//
//        let changePassword = ChangePasswordUITest()
//        changePassword.testChangePasswordFlow()
//
//        let changePhoneNumber = ChangePhoneNumberUITest()
//        changePhoneNumber.testChangePhoneNumberFlow()
//
//        let sendFeedBack = SendFeedbackUITest()
//        sendFeedBack.testSendFeedbackWithoutImageFlow()
//
//        let ads = AdsUITest()
//        ads.testShowAds()
//
//        self.logOut()
//
//        let forgotPassword = ForgotPasswordPhoneUITest()
//        forgotPassword.testForgotPasswordFlow()
//    }
//
//    func emailTestCase() {
//        let signUpEmail = SignUpViewControllerUITests()
//        signUpEmail.testEmailSignUp()
//
//
//        let skipFlow = LoginPhoneUITest()
//        skipFlow.testSkipFlow()
//
//        XCUIApplication().launch()
//
//        let emailFlow = LoginEmailUITest()
//        emailFlow.testLoginValidiationExample()
//
//        self.login()
//
//        let editProfile = EditProfileUITest()
//        editProfile.testEmailEditProfile()
//
//        let changePassword = ChangePasswordUITest()
//        changePassword.testChangePasswordFlow()
//
//        let sendFeedBack = SendFeedbackUITest()
//        sendFeedBack.testSendFeedbackWithoutImageFlow()
//
//        let ads = AdsUITest()
//        ads.testShowAds()
//
//        self.logOut()
//
//        let forgotPassword = ForgotPasswordEmailUITest()
//        forgotPassword.testForgotPasswordFlow()
//    }
//
//    func logOut() {
//        app.tabBars.buttons["Settings"].tap()
//        wait(for: delay)
//        app.buttons["Logout"].tap()
//        wait(for: delay)
//        app.alerts["The Appineers"].buttons["Yes"].tap()
//        wait(for: apiDelay)
//    }
//
//    func login() {
//        //loginButton Instance
//        let loginButton = elementsQuery.buttons["Login"]
//
//        //textFieldPhoneNumber Instance
//        let phoneNumberTextField = elementsQuery.textFields["Phone Number"]
//
//        //Move cursor to textfieldPhoneNumber
//        phoneNumberTextField.tap()
//        scrollViewsQuery.otherElements.containing(.image, identifier:"login_logo").element.swipeUp()
//
//        //Delete invalid phone number
//        self.tapAction(key: "9876123455")
//
//        //passwordTextField Instance
//        let passwordSecureTextField = elementsQuery.secureTextFields["Password"]
//
//        passwordSecureTextField.tap()
//
//        let shiftButton = app/*@START_MENU_TOKEN@*/.buttons["shift"]/*[[".keyboards.buttons[\"shift\"]",".buttons[\"shift\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        shiftButton.tap()
//
//        self.tapAction(key: "Qwerty")
//        self.getKey(key: "more").tap()
//        self.tapAction(key: "123")
//
//        loginButton.tap()
//        //call API with invalid credentials
//
//        //Delay for API response message
//        wait(for: apiDelay)
//    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
    }
    
    
    func getKey(key:String)-> XCUIElement {
        return XCUIApplication().keys[key]
    }
    
    func deleteKey(value: Int, type: String) {
        let deleteKey = app.keys[type]
        for _ in 1...value {
            deleteKey.tap()
        }
    }
    
    func checkCondition(value: String) -> Bool {
        return  ["true", "y", "t", "yes", "1"].contains { value.caseInsensitiveCompare($0) == .orderedSame }
    }
    
    func tapAction(key: String)  {
        let characters = Array(key)
        for (index) in 0...characters.count - 1 {
            XCUIApplication().keys[String(characters[index])].tap()
        }
        
    }
    
}

extension XCTestCase {
    
    func wait(for duration: TimeInterval) {
        let waitExpectation = expectation(description: "Waiting")
        
        let when = DispatchTime.now() + duration
        DispatchQueue.main.asyncAfter(deadline: when) {
            waitExpectation.fulfill()
        }
        
        // We use a buffer here to avoid flakiness with Timer on CI
        waitForExpectations(timeout: duration + 0.5)
    }
}


extension XCUIElement {
    func forceTapElement() {
        if self.isHittable {
            self.tap()
        }
        else {
            let coordinate: XCUICoordinate = self.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
            
            coordinate.tap()
        }
    }
}


extension WhiteLabelAppUITests {
    
    
}
