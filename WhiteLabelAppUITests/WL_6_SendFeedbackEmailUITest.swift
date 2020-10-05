//
//  SendFeedbackUITest.swift
//  WhiteLabelAppUITests
//
//  Created by hb on 07/10/19.
//  Copyright © 2019 hb. All rights reserved.
//

import XCTest

class WL_6_SendFeedbackEmailUITest: WhiteLabelAppUITests {
    
    func test1SendFeedback() {
        app.tabBars.buttons["Settings"].tap()
        wait(for: delay)
        
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        elementsQuery.staticTexts["Support"].swipeUp()
        scrollViewsQuery.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 4).children(matching: .other).element(boundBy: 3).buttons["dropdown arrow s 10"].tap()
        
        wait(for: delay)
        snapshot("6.0.1SendFeedScreen",timeWaitingForIdle: 3)
        
        // Empty TextView
        let sendButton = elementsQuery.buttons["Send"]
        sendButton.tap()
        snapshot("6.0.2EmptyText",timeWaitingForIdle: 3)
        
        wait(for: delay)
        
        scrollViewsQuery.otherElements.containing(.image, identifier:"login_logo").children(matching: .textView).element.tap()
        
        // TextView With feedback
        self.getKey(key: "T").tap()
        self.tapAction(key: "est")
        app.buttons["Return"].tap()
        wait(for: delay)
        
        wait(for: delay)
        self.getKey(key: "L").tap()
        self.tapAction(key: "orem")
        app/*@START_MENU_TOKEN@*/.keys["space"]/*[[".keyboards.keys[\"space\"]",".keys[\"space\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        self.tapAction(key: "ipsum")
        app/*@START_MENU_TOKEN@*/.keys["space"]/*[[".keyboards.keys[\"space\"]",".keys[\"space\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        self.tapAction(key: "is")
        app/*@START_MENU_TOKEN@*/.keys["space"]/*[[".keyboards.keys[\"space\"]",".keys[\"space\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        self.tapAction(key: "simply")
        app/*@START_MENU_TOKEN@*/.keys["space"]/*[[".keyboards.keys[\"space\"]",".keys[\"space\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        self.tapAction(key: "dummy")
        app/*@START_MENU_TOKEN@*/.keys["space"]/*[[".keyboards.keys[\"space\"]",".keys[\"space\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        self.tapAction(key: "text")
        app/*@START_MENU_TOKEN@*/.keys["space"]/*[[".keyboards.keys[\"space\"]",".keys[\"space\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        self.tapAction(key: "of")
        app/*@START_MENU_TOKEN@*/.keys["space"]/*[[".keyboards.keys[\"space\"]",".keys[\"space\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        self.tapAction(key: "the")
        app/*@START_MENU_TOKEN@*/.keys["space"]/*[[".keyboards.keys[\"space\"]",".keys[\"space\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        self.tapAction(key: "printing")
        app/*@START_MENU_TOKEN@*/.keys["space"]/*[[".keyboards.keys[\"space\"]",".keys[\"space\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        self.tapAction(key: "and")
        app/*@START_MENU_TOKEN@*/.keys["space"]/*[[".keyboards.keys[\"space\"]",".keys[\"space\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        self.tapAction(key: "typesetting")
        app/*@START_MENU_TOKEN@*/.keys["space"]/*[[".keyboards.keys[\"space\"]",".keys[\"space\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        self.tapAction(key: "industry")
        app/*@START_MENU_TOKEN@*/.keys["space"]/*[[".keyboards.keys[\"space\"]",".keys[\"space\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        wait(for: delay)
        
        app.toolbars["Toolbar"].buttons["Done"].tap()
        wait(for: delay)
        
        sendButton.tap()
        snapshot("6.0.3Success",timeWaitingForIdle: 10)
        wait(for: apiDelay)
        wait(for: delay)
        
    }
    
}
