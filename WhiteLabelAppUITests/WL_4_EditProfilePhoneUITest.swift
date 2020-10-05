//
//  EditProfileUITest.swift
//  WhiteLabelAppUITests
//
//  Created by hb on 08/10/19.
//  Copyright © 2019 hb. All rights reserved.
//

import XCTest

class WL_4_EditProfilePhoneUITest: WhiteLabelAppUITests {
    
    let phone = "9876123455"
    //password Qwerty123
    
    let aModel = SignUpConfig.SignUptextField()
    
    func buttonCreateAction(screenShotName: String) {
        elementsQuery.buttons["Update"].tap()
        snapshot(screenShotName,timeWaitingForIdle: 3)
        //Delay
        wait(for: delay)
    }
    
    func toolBarDone(screenShotName: String) {
        //Done tapped
        app.toolbars["Toolbar"].buttons["Done"].tap()
        //Button Create Tapped
        elementsQuery.buttons["Update"].tap()
        
        snapshot(screenShotName,timeWaitingForIdle: 3)
        
        wait(for: delay)
    }
    
    
    func initialFlow() {
        wait(for: delay)
        app.tabBars.buttons["Settings"].tap()
        scrollViewsQuery.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .other).element(boundBy: 2).buttons["dropdown arrow s 10"].tap()
    }
    
    func test1Login() {
        let loginButton = elementsQuery.buttons["Login"]
        
        let phoneNumberTextField = elementsQuery.textFields["Phone Number"]
        phoneNumberTextField.tap()
        self.tapAction(key: phone)
        
        //passwordTextField Instance
        let passwordSecureTextField = elementsQuery.secureTextFields["Password"]
        passwordSecureTextField.tap()
        
        app.buttons["shift"].tap()
        app/*@START_MENU_TOKEN@*/.keys["Q"]/*[[".keyboards.keys[\"Q\"]",".keys[\"Q\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        self.tapAction(key: "werty")
        self.getKey(key: "more").tap()
        self.tapAction(key: "123")
        
        loginButton.tap()
        
        wait(for: apiDelay)
        wait(for: delay)
        
    }
    
    func test2ProfilePictureValidation() {
        
        initialFlow()
        
        XCUIApplication().buttons["EDIT"].tap()
        wait(for: delay)
        
        app.sheets["The Appineers"].buttons["Gallery"].forceTapElement()
        XCTAssertTrue(XCUIApplication().navigationBars.otherElements["Photos"].waitForExistence(timeout: 5))
        
        //Check if Moments is visible on the view
        XCTAssertTrue(XCUIApplication().otherElements.tables.cells["Moments"].waitForExistence(timeout: 5))
        
        //Click on Moments to see the image collection list
        XCUIApplication().otherElements.tables.cells["Moments"].tap()
        
        //Checking for "Photo, Portrait, August 08, 2012, 11:29 PM" exist
        XCTAssertTrue(((XCUIApplication().otherElements.collectionViews.cells.allElementsBoundByIndex.last?.tap()) != nil))
        
        //wait(for: delay)
        XCUIApplication().buttons["Choose"].tap()
        wait(for: delay)
    }
    
    
    func test3FirstNameValidation() {
        
        initialFlow()
        
        
        //Check visible and optional conditions
        if self.checkCondition(value: aModel.firstname.visible) {
            if !self.checkCondition(value: aModel.firstname.optional) {
                
                //TextField Instance
                elementsQuery.textFields["First Name"].tap()
                
                if let firstName = elementsQuery.textFields["First Name"].value as? String {
                    deleteKey(value: firstName.count, type: "delete")
                    wait(for: delay)
                }
                
                //Done action on textfield and tap action on Create and delay
                self.toolBarDone(screenShotName: "4.0.1FirstNameValidation")
                
                //TextField Instance
                elementsQuery.textFields["First Name"].tap()
                
                //Type value in textfield
                self.tapAction(key: "White")
                
            }else if self.checkCondition(value: aModel.firstname.optional) {
                
                //TextField Instance
                elementsQuery.textFields["First Name (optional)"].tap()
                
                if let firstName = elementsQuery.textFields["First Name (optional)"].value as? String {
                    deleteKey(value: firstName.count, type: "delete")
                    wait(for: delay)
                }
                
                //Done action on textfield and tap action on Create and delay
                self.toolBarDone(screenShotName: "4.0.2FirstNameOptionalValidation")
                
                //TextField Instance
                elementsQuery.textFields["First Name (optional)"].tap()
                
                //Type value in textfield
                self.tapAction(key: "White")
            }
        }
    }
    
    func test4LastNameValidation() {
        
        initialFlow()
        
        //Check visible and optional conditions
        if self.checkCondition(value: aModel.lastname.visible) {
            if !self.checkCondition(value: aModel.lastname.optional) {
                
                //TextField Instance
                elementsQuery.textFields["Last Name"].tap()
                
                if let lastName = elementsQuery.textFields["Last Name"].value as? String {
                    deleteKey(value: lastName.count, type: "delete")
                    wait(for: delay)
                }
                
                //Done action on textfield and tap action on Create and delay
                self.toolBarDone(screenShotName: "4.0.3LastNameValidation")
                
                //TextField Instance
                elementsQuery.textFields["Last Name"].tap()
                
                //Type value in textfield
                self.tapAction(key: "Label")
                
            }else if self.checkCondition(value: aModel.lastname.optional) {
                
                //TextField Instance
                elementsQuery.textFields["Last Name (optional)"].tap()
                
                if let lastName = elementsQuery.textFields["Last Name (optional)"].value as? String {
                    deleteKey(value: lastName.count, type: "delete")
                    wait(for: delay)
                }
                
                //Done action on textfield and tap action on Create and delay
                self.toolBarDone(screenShotName: "4.0.4LastNameOptionalValidation")
                
                //TextField Instance
                elementsQuery.textFields["Last Name (optional)"].tap()
                
                //Type value in textfield
                self.tapAction(key: "Label")
            }
        }
    }
    
    func test5UserNameValidation() {
        
        initialFlow()
        
        //Check visible and optional conditions
        if self.checkCondition(value: aModel.username.visible) {
            if !self.checkCondition(value: aModel.username.optional) {
                
                //TextField Instance
                elementsQuery.textFields["Username"].tap()
                
                if let userName = elementsQuery.textFields["Username"].value as? String {
                    deleteKey(value: userName.count, type: "delete")
                    wait(for: delay)
                }
                
                //Done action on textfield and tap action on Create and delay
                self.toolBarDone(screenShotName: "4.0.5UserNameEmptyValidation")
                
                //TextField Instance
                elementsQuery.textFields["Username"].tap()
                
                //Type value in textfield
                self.tapAction(key: "Ap")
                
                //Done action on textfield and tap action on Create and delay
                self.toolBarDone(screenShotName: "4.0.6UserNameMinimumCharacterValidation")
                
                elementsQuery.textFields["Username"].tap()
                //Remove all text from textfield
                self.deleteKey(value: 2, type: "delete")
                
                //Type value in textfield
                self.tapAction(key: "App")
                self.getKey(key: "more").tap()
                self.tapAction(key: "@12")
                
                //Done action on textfield and tap action on Create and delay
                self.toolBarDone(screenShotName: "4.0.7UserNameInValidValidation")
                
                elementsQuery.textFields["Username"].tap()
                //Remove all text from textfield
                self.deleteKey(value: 6, type: "delete")
                
                //Type value in textfield
                self.tapAction(key: "Appineers")
                
            } else if self.checkCondition(value: aModel.username.optional) {
                
                elementsQuery.textFields["Username (optional)"].tap()
                
                //TextField Instance optional case
                if let userName = elementsQuery.textFields["Username (optional)"].value as? String {
                    deleteKey(value: userName.count, type: "delete")
                    wait(for: delay)
                }
                
                //Type value in textfield
                self.tapAction(key: "App")
                self.getKey(key: "more").tap()
                self.tapAction(key: "@12")
                
                //Done action on textfield and tap action on Create and delay
                self.toolBarDone(screenShotName: "4.0.8UserNameOptionalValidation")
                
                elementsQuery.textFields["Username (optional)"].tap()
                //Remove all text from textfield
                self.deleteKey(value: 6, type: "delete")
                
                //Type value in textfield
                self.tapAction(key: "Appineers")
            }
        }
    }
    
    func test6AddressValidation() {
        
        initialFlow()
        
        //Check visible and optional conditions
        if self.checkCondition(value: aModel.streetaddress.visible) {
            if !self.checkCondition(value: aModel.streetaddress.optional) {
                
                //TextField Instance
                elementsQuery.textFields["Address"].tap()
                
                //Type value in textfield
                self.getKey(key: "more").tap()
                self.tapAction(key: "101")
                
                snapshot("4.1.2Address",timeWaitingForIdle: 3)
                
                //Select address from table
                app.tables/*@START_MENU_TOKEN@*/.staticTexts["1010 Massachusetts Avenue"]/*[[".cells.staticTexts[\"1010 Massachusetts Avenue\"]",".staticTexts[\"1010 Massachusetts Avenue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
                
                
                if !self.checkCondition(value: aModel.city.optional) {
                    elementsQuery.textFields["City"].tap()
                    
                    //Remove all text from textfield
                    self.deleteKey(value: 6, type: "delete")
                    
                    //Done action on textfield and tap action on Create and delay
                    self.toolBarDone(screenShotName: "4.1.3CityValidation")
                    
                    elementsQuery.textFields["City"].tap()
                    
                    //Type value in textfield
                    self.tapAction(key: "Boston")
                    
                    //Done tapped
                    app.toolbars["Toolbar"].buttons["Done"].tap()
                    
                }
                if self.checkCondition(value: aModel.city.optional) {
                    elementsQuery.textFields["City (optional)"].tap()
                    
                    //Remove all text from textfield
                    self.deleteKey(value: 6, type: "delete")
                    
                    //Done action on textfield and tap action on Create and delay
                    self.toolBarDone(screenShotName: "4.1.4CityOptionalValidation")
                    
                    elementsQuery.textFields["City (optional)"].tap()
                    
                    //Type value in textfield
                    self.tapAction(key: "Boston")
                    
                    //Done tapped
                    app.toolbars["Toolbar"].buttons["Done"].tap()
                }
                
                if !self.checkCondition(value: aModel.state.optional) {
                    elementsQuery.textFields["State"].tap()
                    
                    app.toolbars["Toolbar"].buttons["Done"].tap()
                }
                if self.checkCondition(value: aModel.state.optional) {
                    elementsQuery.textFields["State (optional)"].tap()
                    
                    app.toolbars["Toolbar"].buttons["Done"].tap()
                }
                
                
            }else if self.checkCondition(value: aModel.streetaddress.optional) {
                
                //TextField Instance optional case
                elementsQuery.textFields["Address (optional)"].tap()
                
                //Type value in textfield
                self.getKey(key: "more").tap()
                self.tapAction(key: "101")
                
                //Select address from table
                app.tables/*@START_MENU_TOKEN@*/.staticTexts["1010 Massachusetts Avenue"]/*[[".cells.staticTexts[\"1010 Massachusetts Avenue\"]",".staticTexts[\"1010 Massachusetts Avenue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
                
                if !self.checkCondition(value: aModel.city.optional) {
                    elementsQuery.textFields["City"].tap()
                    
                    //Remove all text from textfield
                    self.deleteKey(value: 6, type: "delete")
                    
                    //Done action on textfield and tap action on Create and delay
                    self.toolBarDone(screenShotName: "4.1.5CityValidation")
                    
                    elementsQuery.textFields["City"].tap()
                    
                    //Type value in textfield
                    self.tapAction(key: "Boston")
                    
                    //Done tapped
                    app.toolbars["Toolbar"].buttons["Done"].tap()
                }
                if self.checkCondition(value: aModel.city.optional) {
                    elementsQuery.textFields["City (optional)"].tap()
                    
                    //Remove all text from textfield
                    self.deleteKey(value: 6, type: "delete")
                    
                    //Done action on textfield and tap action on Create and delay
                    self.toolBarDone(screenShotName: "4.1.6CityOptionalValidation")
                    
                    elementsQuery.textFields["City (optional)"].tap()
                    
                    //Type value in textfield
                    self.tapAction(key: "Boston")
                    
                    app.toolbars["Toolbar"].buttons["Done"].tap()
                }
                
                if !self.checkCondition(value: aModel.state.optional) {
                    elementsQuery.textFields["State"].tap()
                    
                    app.toolbars["Toolbar"].buttons["Done"].tap()
                    
                }
                if self.checkCondition(value: aModel.state.optional) {
                    elementsQuery.textFields["State (optional)"].tap()
                    
                    app.toolbars["Toolbar"].buttons["Done"].tap()
                }
            }
        }
    }
    
    func test7ZipCodeValidation() {
        
        initialFlow()
        
        if !self.checkCondition(value: aModel.zip.optional) {
            elementsQuery.textFields["Zip Code"].tap()
            
            let text = (elementsQuery.textFields["Zip Code"].value as! String)
            if text.count > 0 {
                self.deleteKey(value: text.count, type: "delete")
                elementsQuery.buttons["Update"].tap()
                snapshot("4.1.7ZipCodeValidation",timeWaitingForIdle: 3)
                wait(for: delay)
            }
            
            self.getKey(key: "more").tap()
            self.tapAction(key: "12")
            elementsQuery.buttons["Update"].tap()
            snapshot("4.1.8ZipCodeInvalidValidation",timeWaitingForIdle: 3)
            wait(for: delay)
            
            self.deleteKey(value: 2, type: "delete")
            self.tapAction(key: "12345")
            
        }
        if self.checkCondition(value: aModel.zip.optional) {
            elementsQuery.textFields["Zip Code (optional)"].tap()
            
            let text = (elementsQuery.textFields["Zip Code (optional)"].value as! String)
            if text.count > 0 {
                self.deleteKey(value: text.count, type: "delete")
            }
            self.getKey(key: "more").tap()
            self.tapAction(key: "12")
            elementsQuery.buttons["Update"].tap()
            snapshot("4.1.9ZipCodeInvalidOptionalValidation",timeWaitingForIdle: 3)
            wait(for: delay)
            
            self.deleteKey(value: 2, type: "delete")
            self.tapAction(key: "12345")
        }
    }
    
    func test8DateOfBirthValidation() {
        
        initialFlow()
        
        
        if !self.checkCondition(value: aModel.dateofbirth.optional) {
            elementsQuery.textFields["Date of Birth"].tap()
            
            //Done action on textfield and tap action on Create and delay
            self.toolBarDone(screenShotName: "4.2.0Success")
            wait(for: apiDelay)
            
        }
        if self.checkCondition(value: aModel.dateofbirth.optional) {
            elementsQuery.textFields["Date of Birth (optional)"].tap()
            
            //Done action on textfield and tap action on Create and delay
            self.toolBarDone(screenShotName: "4.2.1SuccessOptional")
            wait(for: apiDelay)
        }
    }
}
