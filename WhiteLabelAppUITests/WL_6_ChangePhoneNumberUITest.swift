//
//  ChangePhoneNumberUITest.swift
//  WhiteLabelAppUITests
//
//  Created by hb on 04/10/19.
//  Copyright © 2019 hb. All rights reserved.
//

import XCTest

class WL_6_ChangePhoneNumberUITest:WhiteLabelAppUITests {
    
    // invalid 9876123455
    // valid 9876123445
    
    func test1CheckInvalidPhoneNumber() {
        app.tabBars.buttons["Settings"].tap()
        wait(for: delay)
        
        let scrollViewsQuery = app.scrollViews
        scrollViewsQuery.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .other).element(boundBy: 4).buttons["dropdown arrow s 10"].tap()
        wait(for: delay)
        
        let elementsQuery = scrollViewsQuery.otherElements
        let sendButton = elementsQuery.buttons["Send"]
        sendButton.tap()
        snapshot("6.0.1EnterPhoneNumber",timeWaitingForIdle: 3)
        wait(for: delay)
        
        let phoneNumberTextField = elementsQuery.textFields["Phone Number"]
        phoneNumberTextField.tap()
        wait(for: delay)
        
        self.tapAction(key: "987")
        
        sendButton.tap()
        snapshot("6.0.2InvalidPhoneNumber",timeWaitingForIdle: 3)
        wait(for: delay)
        phoneNumberTextField.tap()
        wait(for: delay)
        
        self.tapAction(key: "6123455")
        
        sendButton.tap()
        
        snapshot("6.0.3PhoneNumberNotFound",timeWaitingForIdle: 3)
        wait(for: delay)
    }
    
    
    func test2CheckValidPhoneNumber() {
        app.tabBars.buttons["Settings"].tap()
        wait(for: delay)
        
        let scrollViewsQuery = app.scrollViews
        scrollViewsQuery.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .other).element(boundBy: 4).buttons["dropdown arrow s 10"].tap()
        wait(for: delay)
        
        let elementsQuery = scrollViewsQuery.otherElements
        let sendButton = elementsQuery.buttons["Send"]
        sendButton.tap()
        snapshot("6.0.4EnterPhoneNumber",timeWaitingForIdle: 3)
        wait(for: delay)
        
        let phoneNumberTextField = elementsQuery.textFields["Phone Number"]
        phoneNumberTextField.tap()
        wait(for: delay)
        
        self.tapAction(key: "987")
        
        sendButton.tap()
        snapshot("6.0.5InvalidPhoneNumber",timeWaitingForIdle: 3)
        wait(for: delay)
        phoneNumberTextField.tap()
        wait(for: delay)
        
        self.tapAction(key: "6123445")
        
        sendButton.tap()
        
        snapshot("6.0.6PhoneNumberNotFound",timeWaitingForIdle: 10)
        wait(for: apiDelay)
        
        self.otpValidiationWithResendOtp()
    }
    
    func otpValidiationWithResendOtp() {
        elementsQuery.collectionViews.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .textField).element.tap()
        
        wait(for: delay)
        
        let submitButton = elementsQuery.buttons["Submit"]
        submitButton.tap()
        snapshot("6.0.7EnterOtp",timeWaitingForIdle: 3)
        
        wait(for: delay)
        elementsQuery.collectionViews.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .textField).element.tap()
        
        sleep(25)
        elementsQuery.buttons["Resend OTP"].tap()
        wait(for: apiDelay)
        
        snapshot("6.0.8ResendOtp",timeWaitingForIdle: 10)
        
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
        
        snapshot("6.0.9InvalidOtp",timeWaitingForIdle: 3)
        
        wait(for: delay)
        elementsQuery.collectionViews.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .textField).element.tap()
        
        self.deleteKey(value: 4, type: "Delete")
        
        wait(for: delay)
        
        self.tapAction(key: otp)
        
        submitButton.tap()
        
        snapshot("6.1.0Success",timeWaitingForIdle: 15)
        
        wait(for: apiDelay)
    }
    
}
