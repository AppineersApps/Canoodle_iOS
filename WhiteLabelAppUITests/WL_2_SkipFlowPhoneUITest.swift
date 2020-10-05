//
//  SkipFlowUITest.swift
//  WhiteLabelAppUITests
//
//  Created by hb on 15/10/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation

class WL_2_SkipFlowPhoneUITest: WhiteLabelAppUITests {
    
    func test1SkipFlow() {
        
        //Skip Button Instance
        wait(for: delay)
        snapshot("2.0.1loginDisplay",timeWaitingForIdle: 3)
        
        let skipButton = app.navigationBars["Login"].buttons["Skip "]
        skipButton.tap()
        snapshot("2.0.2SkipButton",timeWaitingForIdle: 3)
        
        wait(for: delay)
        
        //TabBar Instance
        let tabBarsQuery = app.tabBars
        
        //TabBar Setting tab action
        tabBarsQuery.buttons["Settings"].tap()
        wait(for: delay)
        
        snapshot("2.0.3Setting",timeWaitingForIdle: 3)
        
        let element = app.scrollViews.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1)
        element.children(matching: .other).element(boundBy: 0).buttons["dropdown arrow s 10"].tap()
        
        snapshot("2.0.4AboutUs",timeWaitingForIdle: 1)
        
        wait(for: delay)
        
        //Aboutus action
        app.navigationBars["About Us"].buttons["Settings"].tap()
        element.children(matching: .other).element(boundBy: 1).buttons["dropdown arrow s 10"].tap()
        snapshot("2.0.5AboutUs",timeWaitingForIdle: 0)
        
        wait(for: delay)
        
        //Privacy policy action
        app.navigationBars["Privacy Policy"].buttons["Settings"].tap()
        element.children(matching: .other).element(boundBy: 2).buttons["dropdown arrow s 10"].tap()
        
        snapshot("2.0.6PrivacyPolicy",timeWaitingForIdle: 0)
        
        wait(for: delay)
        
        //T&C  action
        app.navigationBars["Terms & Conditions"].buttons["Settings"].tap()
        element.children(matching: .other).element(boundBy: 3).buttons["dropdown arrow s 10"].tap()
        
        snapshot("2.0.7TermsConditions",timeWaitingForIdle: 0)
        
        wait(for: delay)
        
        app.buttons["Cancel"].tap()
        wait(for: delay)
    }
    
}
