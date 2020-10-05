//
//  The_AppineersUITests.swift
//  The AppineersUITests
//
//  Created by hb on 01/10/19.
//  Copyright © 2019 hb. All rights reserved.
//

import XCTest

class WL_3_LoginEmailUITest: WhiteLabelAppUITests {
    
    lazy var loginButton = elementsQuery.buttons["Login"]
    
    //Invalid credentials:
    //test@grr.la pass. Qwerty
    //Valid credentials:
    //white@label.com pass. Qwerty123
    
    let email = "iphoneemail@grr.la"
    
     
    func test1EmailValidiations() {
        
        loginButton.tap()
        snapshot("3.1LoginEmailValidation",timeWaitingForIdle: 3)
        
        wait(for: delay)
        
        elementsQuery.textFields["Email"].tap()
        
        self.tapAction(key: "white")
        
        app.scrollViews.otherElements.containing(.image, identifier:"login_logo").element.swipeUp()
        loginButton.tap()
        
        snapshot("3.2LoginInvalidEmailValidation",timeWaitingForIdle: 3)

        wait(for: delay)
        
        self.tapAction(key: "@label.com")
        loginButton.tap()
        
        snapshot("3.3LoginValidEmailValidation",timeWaitingForIdle: 3)

        wait(for: delay)
    }
    
    func test2PasswordValidiations() {
        
        elementsQuery.textFields["Email"].tap()
        self.tapAction(key: "whitee@label.com")
        

        elementsQuery.secureTextFields["Password"].tap()
        
        app.buttons["shift"].tap()
        app/*@START_MENU_TOKEN@*/.keys["Q"]/*[[".keyboards.keys[\"Q\"]",".keys[\"Q\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        self.tapAction(key: "werty")
        

        loginButton.tap()
        snapshot("3.4LoginInvalidPasswordValidation",timeWaitingForIdle: 3)

        wait(for: delay)
        

    }
    
    func test3Login() {
        elementsQuery.textFields["Email"].tap()
        self.tapAction(key: email)
        
        elementsQuery.secureTextFields["Password"].tap()
        app.buttons["shift"].tap()
        app/*@START_MENU_TOKEN@*/.keys["Q"]/*[[".keyboards.keys[\"Q\"]",".keys[\"Q\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        self.tapAction(key: "werty")
        self.getKey(key: "more").tap()
        self.tapAction(key: "123")
        
        loginButton.tap()
        snapshot("3.5LoginSuccess",timeWaitingForIdle: 10)

        wait(for: apiDelay)
        
    }
    
    func test4Logout() {
        wait(for: delay)
        app.tabBars.buttons["Settings"].tap()
        app.buttons["Logout"].tap()
        wait(for: delay)
        
        snapshot("3.6LogoutAlert",timeWaitingForIdle: 3)
        
        app.alerts["The Appineers"].buttons["Yes"].tap()
        
        snapshot("3.7LogoutSuccess",timeWaitingForIdle: 3)
        
        wait(for: apiDelay)
        
    }
}
