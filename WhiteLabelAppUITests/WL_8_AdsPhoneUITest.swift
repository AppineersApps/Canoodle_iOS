//
//  AdsUITest.swift
//  WhiteLabelAppUITests
//
//  Created by hb on 07/10/19.
//  Copyright © 2019 hb. All rights reserved.
//

import XCTest

class WL_8_AdsPhoneUITest: WhiteLabelAppUITests {
    
    func test1DisplayBeforeRemove() {
        wait(for: delay)
        let app = XCUIApplication()
        app.tabBars.buttons["Friends"].tap()
        snapshot("8.0.1ShowAdsScreenWithAds",timeWaitingForIdle: 3)
        let button = app.navigationBars["Friends"].children(matching: .button).element
        button.tap()
        wait(for: delay)
        button.tap()
        wait(for: delay)
        button.tap()
        wait(for: delay)
        button.tap()
        snapshot("8.0.2DisplayAds",timeWaitingForIdle: 3)
        wait(for: delay)
    }
    
    func test2RemoveAds() {
        let app = XCUIApplication()
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Settings"].tap()
        wait(for: delay)
        app.scrollViews.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .other).element(boundBy: 1).buttons["dropdown arrow s 10"].tap()
        snapshot("8.0.3AlertForRemoveAds",timeWaitingForIdle: 3)
        wait(for: delay)
        app.alerts["The Appineers"].buttons["Buy for $0.99"].tap()
        snapshot("8.0.4RemoveAds",timeWaitingForIdle: 2)
        wait(for: delay)
        app.tabBars.buttons["Home"].tap()
        wait(for: delay)
        app.tabBars.buttons["Friends"].tap()
        snapshot("8.0.5ShowAdsScreenWithOutAds",timeWaitingForIdle: 3)
        let button = app.navigationBars["Friends"].children(matching: .button).element
        button.tap()
        wait(for: delay)
        button.tap()
        wait(for: delay)
        button.tap()
        wait(for: delay)
        button.tap()
        app.tabBars.buttons["Messages"].tap()
        wait(for: delay)
        app.tabBars.buttons["My Profile"].tap()
        wait(for: delay)
        app.tabBars.buttons["Settings"].tap()
        wait(for: delay)
        
        app.buttons["Logout"].tap()
        wait(for: delay)
        app.alerts["The Appineers"].buttons["Yes"].tap()
        wait(for: apiDelay)
    }
    
}
