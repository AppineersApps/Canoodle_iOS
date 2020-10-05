//
//  ForgotPasswordPhoneUITest.swift
//  WhiteLabelAppUITests
//
//  Created by hb on 03/10/19.
//  Copyright © 2019 hb. All rights reserved.
//

import XCTest
import UIKit

class WL_9_ForgotPasswordPhoneUITest: WhiteLabelAppUITests {
    
    
    let validPhone = "9876123445"
    
    func test1CheckInvalidPhoneNumber() {
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["Forgot Password?"].tap()
        
        let nextButton = elementsQuery.buttons["Next"]
        nextButton.tap()
        snapshot("9.0.1PhoneNumberEmptyValidation",timeWaitingForIdle: 3)
        wait(for: delay)
        
        //Enter invalid phone number
        self.tapAction(key: "78981")
        nextButton.tap()
        snapshot("9.0.2InvalidPhoneNumberValidation",timeWaitingForIdle: 3)
        wait(for: delay)
        
        //Delete invalid phone number
        self.deleteKey(value: 5, type: "Delete")
        wait(for: delay)
        
        //Enter phone number that not exist in data base
        self.tapAction(key: "9876123455")
        
        //Call API and show alert
        elementsQuery.buttons["Next"].tap()
        snapshot("9.0.2PhoneNumberNotExistValidation",timeWaitingForIdle: 3)
        wait(for: delay)
        
    }
    
    func test2CheckPhoneNumberAndResetPassword() {
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["Forgot Password?"].tap()
        //Enter valid phone number
        self.tapAction(key: validPhone)
        let nextButton = elementsQuery.buttons["Next"]
        nextButton.tap()
        snapshot("9.0.4SuccessValidation",timeWaitingForIdle: 3)
        wait(for: apiDelay)
        self.otpValidiationWithResendOtp()
    }
    
    
    func otpValidiationWithResendOtp() {
        elementsQuery.collectionViews.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .textField).element.tap()
        
        wait(for: delay)
        
        let submitButton = elementsQuery.buttons["Submit"]
        submitButton.tap()
        snapshot("9.0.5EnterOtp",timeWaitingForIdle: 3)
        
        wait(for: delay)
        elementsQuery.collectionViews.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .textField).element.tap()
        
        sleep(25)
        elementsQuery.buttons["Resend OTP"].tap()
        snapshot("9.0.6ResendOtp",timeWaitingForIdle: 10)
        wait(for: apiDelay)
        
        self.OTPValidiation()
        
    }
    
    func OTPValidiation() {
        elementsQuery.collectionViews.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .textField).element.tap()
        
        let otp = (elementsQuery.textFields["otp"].value as! String)
        wait(for: delay)
        
        let submitButton = elementsQuery.buttons["Submit"]
        submitButton.tap()
        
        wait(for: delay)
        
        self.tapAction(key: "1234")
        submitButton.tap()
        
        snapshot("9.0.7InvalidOtp",timeWaitingForIdle: 3)
        
        wait(for: delay)
        elementsQuery.collectionViews.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .textField).element.tap()
        
        self.deleteKey(value: 4, type: "Delete")
        
        wait(for: delay)
        
        self.tapAction(key: otp)
        
        submitButton.tap()
        
        snapshot("9.0.8Success",timeWaitingForIdle: 15)
        
        wait(for: apiDelay)
        
        resetPassword()
    }
    
    
    func resetPassword() {
        
        let resetPasswordButton = elementsQuery.buttons["Reset Password"]
        resetPasswordButton.tap()
        snapshot("9.0.9EmptyNewPassword",timeWaitingForIdle: 3)
        
        wait(for: delay)
        
        elementsQuery.secureTextFields["New Password"].tap()
        
        self.tapAction(key: "test")
        resetPasswordButton.tap()
        snapshot("9.1.0InvalidNewPassword",timeWaitingForIdle: 3)
        wait(for: delay)
        
        self.deleteKey(value: 4, type: "delete")
        
        let shiftButton = app/*@START_MENU_TOKEN@*/.buttons["shift"]/*[[".keyboards.buttons[\"shift\"]",".buttons[\"shift\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        shiftButton.tap()
        
        self.tapAction(key: "Qwerty")
        
        self.getKey(key: "more").tap()
        
        self.tapAction(key: "123")
        
        resetPasswordButton.tap()
        snapshot("9.1.1EmptyConfirmPassword",timeWaitingForIdle: 3)
        wait(for: delay)
        elementsQuery.secureTextFields["Confirm Password"].tap()
        
        self.tapAction(key: "test")
        resetPasswordButton.tap()
        snapshot("9.1.2NewandConfirmPasswordCheck",timeWaitingForIdle: 3)
        wait(for: delay)
        self.deleteKey(value: 4, type: "delete")
        
        shiftButton.tap()
        
        self.tapAction(key: "Qwerty")
        
        self.getKey(key: "more").tap()
        
        self.tapAction(key: "123")
        
        resetPasswordButton.tap()
        snapshot("9.1.3Success",timeWaitingForIdle: 15)
        wait(for: apiDelay)
    }
    
}
