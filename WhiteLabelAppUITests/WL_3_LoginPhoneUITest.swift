//
//  LoginPhoneUITest.swift
//  WhiteLabelAppUITests
//
//  Created by hb on 01/10/19.
//  Copyright © 2019 hb. All rights reserved.
//

import XCTest

class WL_3_LoginPhoneUITest: WhiteLabelAppUITests {
    
    //Invalid credentials:
    //7898146964 pass. Qwerty@12345
    
    //Valid credentials:
    //9876123455 pass. Qwerty123
    
    
    let validPhone = "9876123455"
    
    func test1PhoneValidation() {
        wait(for: delay)
        //loginButton Instance
        let loginButton = elementsQuery.buttons["Login"]
        
        //loginButton Action
        loginButton.tap()
        
        snapshot("3.0.1EmptyPhoneNumber",timeWaitingForIdle: 3)
        
        //Validation for enter phone number
        //Delay for enter phone number validation
        wait(for: delay)
        
        //textFieldPhoneNumber Instance
        let phoneNumberTextField = elementsQuery.textFields["Phone Number"]
        
        //Move cursor to textfieldPhoneNumber
        phoneNumberTextField.tap()
        scrollViewsQuery.otherElements.containing(.image, identifier:"login_logo").element.swipeUp()
        
        //Delete invalid phone number
        self.tapAction(key: "789814")
        
        loginButton.tap()
        
        snapshot("3.0.1InvalidPhoneNumber",timeWaitingForIdle: 3)
        //Validation for valid phone number
        
        //Delay for valid phone number validation
        wait(for: delay)
        
        self.tapAction(key: "6964")
        
        loginButton.tap()
        //Validation for enter password
        snapshot("3.0.2EnterPassword",timeWaitingForIdle: 3)
        //Delay for enter password validation
        wait(for: delay)
    }
    
    func test2PasswordValidation() {
         wait(for: delay)
        //textFieldPhoneNumber Instance
        let phoneNumberTextField = elementsQuery.textFields["Phone Number"]
        phoneNumberTextField.tap()
        self.tapAction(key: "7898146964")
        
        //passwordTextField Instance
        let passwordSecureTextField = elementsQuery.secureTextFields["Password"]
        
        passwordSecureTextField.tap()
        
        let shiftButton = app/*@START_MENU_TOKEN@*/.buttons["shift"]/*[[".keyboards.buttons[\"shift\"]",".buttons[\"shift\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        shiftButton.tap()
        
        self.tapAction(key: "Qwerty")
        self.getKey(key: "more").tap()
        self.tapAction(key: "@12345")
        
        let loginButton = elementsQuery.buttons["Login"]
        loginButton.tap()
        
        snapshot("3.0.3InvalidCredentials",timeWaitingForIdle: 10)
        //call API with invalid credentials
        
        //Delay for API response message
        wait(for: apiDelay)
        
        phoneNumberTextField.tap()
        //Remove all text from textfieldPhoneNumber
        self.deleteKey(value: 10, type: "Delete")
        
        passwordSecureTextField.tap()
        
        let deleteKey1 = app/*@START_MENU_TOKEN@*/.keys["delete"]/*[[".keyboards.keys[\"delete\"]",".keys[\"delete\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        //Remove all text from textfieldPassword
        deleteKey1.tap()
        deleteKey1.tap()
        
        phoneNumberTextField.tap()
        //Enter text for textfieldPhoneNumber
        
        self.tapAction(key: validPhone)
        
        passwordSecureTextField.tap()
        //Enter text for textfieldPassword
        
        shiftButton.tap()
        
        self.tapAction(key: "Qwerty")
        self.getKey(key: "more").tap()
        self.tapAction(key: "123")
        
        //loginButton.tap()
        //Call API
        scrollViewsQuery.otherElements.containing(.image, identifier:"login_logo").element.tap()
        
        elementsQuery.buttons["Login"].tap()
        
         snapshot("3.0.4LoginSuccess",timeWaitingForIdle: 10)
        //Redirect to Home
        wait(for: delay)
        
        app.tabBars.buttons["Settings"].tap()
        wait(for: delay)
        app.buttons["Logout"].tap()
        wait(for: delay)
        app.alerts["The Appineers"].buttons["No"].tap()
        wait(for: delay)
        app.buttons["Logout"].tap()
        wait(for: delay)
        app.alerts["The Appineers"].buttons["Yes"].tap()
        
        wait(for: apiDelay)
    }
    
}
