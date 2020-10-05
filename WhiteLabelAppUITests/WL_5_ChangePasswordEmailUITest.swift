//
//  ChangePasswordUITest.swift
//  WhiteLabelAppUITests
//
//  Created by hb on 04/10/19.
//  Copyright © 2019 hb. All rights reserved.
//

import XCTest

class WL_5_ChangePasswordEmailUITest: WhiteLabelAppUITests {
    
    lazy var updatePasswordButton = elementsQuery.buttons["Update"]
    lazy var oldPasswordSecureTextField = elementsQuery.secureTextFields["Old Password"]
    lazy var newPasswordSecureTextField = elementsQuery.secureTextFields["New Password"]
    lazy var confirmPasswordSecureTextField = elementsQuery.secureTextFields["Confirm Password"]
    

    func initial() {
        let element = app.scrollViews.children(matching: .other).element.children(matching: .other).element
        app.tabBars.buttons["Settings"].tap()
        wait(for: delay)
        let dropdownArrowS10Button = element.children(matching: .other).element(boundBy: 1).children(matching: .other).element(boundBy: 3).buttons["dropdown arrow s 10"]
        dropdownArrowS10Button.tap()
        wait(for: delay)
    }
    
    func test1CheckEmptyOldPassword() {
        
        initial()
        
        updatePasswordButton.tap()
        snapshot("5.0.1OldPasswordEmptyValidation",timeWaitingForIdle: 3)
        
        wait(for: delay)
        
        oldPasswordSecureTextField.tap()
        wait(for: delay)
        
        app.buttons["shift"].tap()
        wait(for: delay)
        self.getKey(key: "Q").tap()
        wait(for: delay)
        self.tapAction(key: "weqw")
        
        wait(for: delay)
        
    }
    
    func test2CheckNewPasswordValidiations() {
        
        initial()
        
        oldPasswordSecureTextField.tap()
        app.buttons["shift"].tap()
        self.getKey(key: "Q").tap()
        self.tapAction(key: "weqw")
        
        updatePasswordButton.tap()
        snapshot("5.0.2NewPasswordEmptyValidation",timeWaitingForIdle: 3)
        
        
        newPasswordSecureTextField.tap()
        
        self.tapAction(key: "test")
        self.getKey(key: "more").tap()
        self.tapAction(key: "@123")
        
        updatePasswordButton.tap()
        snapshot("5.0.3NewPasswordValidation",timeWaitingForIdle: 3)
        wait(for: delay)
        newPasswordSecureTextField.tap()
        wait(for: delay)
        
        self.deleteKey(value: 8, type: "delete")
        wait(for: delay)
        
        app.buttons["shift"].tap()
        wait(for: delay)
        self.getKey(key: "Q").tap()
        wait(for: delay)
        self.tapAction(key: "werty")
        self.getKey(key: "more").tap()
        self.tapAction(key: "@123")
        
        wait(for: delay)
        
        
    }
    
    func test3CheckConfirmPasswordValidiations() {
        
        initial()
        
        oldPasswordSecureTextField.tap()
        app.buttons["shift"].tap()
        self.getKey(key: "Q").tap()
        self.tapAction(key: "weqw")
        
        newPasswordSecureTextField.tap()
        app.buttons["shift"].tap()
        self.getKey(key: "Q").tap()
        self.tapAction(key: "werty")
        self.getKey(key: "more").tap()
        self.tapAction(key: "@123")
        
        updatePasswordButton.tap()
        snapshot("5.0.4ConfirmPasswordEmptyValidation",timeWaitingForIdle: 3)
        
        
        confirmPasswordSecureTextField.tap()
        
        app.buttons["shift"].tap()
        wait(for: delay)
        self.getKey(key: "T").tap()
        wait(for: delay)
        self.tapAction(key: "est")
        
        updatePasswordButton.tap()
        snapshot("5.0.5ConfirmAndNewPasswordValidation",timeWaitingForIdle: 3)
        
        wait(for: delay)
        confirmPasswordSecureTextField.tap()
        wait(for: delay)
        self.deleteKey(value: 4, type: "delete")
        wait(for: delay)
        
        app.buttons["shift"].tap()
        wait(for: delay)
        self.getKey(key: "Q").tap()
        wait(for: delay)
        self.tapAction(key: "werty")
        self.getKey(key: "more").tap()
        self.tapAction(key: "@123")
        
        updatePasswordButton.tap()
        
        snapshot("5.0.6OldPasswordDoesNotMatch",timeWaitingForIdle: 3)
        
        wait(for: delay)
    }
    
    func test4CheckOldPasswordValidiation() {
        
        initial()
        
        oldPasswordSecureTextField.tap()
        app.buttons["shift"].tap()
        wait(for: delay)
        self.getKey(key: "Q").tap()
        wait(for: delay)
        self.tapAction(key: "werty")
        self.getKey(key: "more").tap()
        self.tapAction(key: "123")
        
        newPasswordSecureTextField.tap()
        app.buttons["shift"].tap()
        self.getKey(key: "Q").tap()
        self.tapAction(key: "werty")
        self.getKey(key: "more").tap()
        self.tapAction(key: "123")
        
        
        confirmPasswordSecureTextField.tap()
        app.buttons["shift"].tap()
        self.getKey(key: "Q").tap()
        self.tapAction(key: "werty")
        self.getKey(key: "more").tap()
        self.tapAction(key: "123")
        
        
        updatePasswordButton.tap()
        snapshot("5.0.7PasswordChange",timeWaitingForIdle: 10)
        wait(for: delay)
    }
    
}
