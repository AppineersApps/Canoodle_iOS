//
//  SignUpViewControllerUITests.swift
//  WhiteLabelAppUITests
//
//  Created by hb on 04/10/19.
//  Copyright © 2019 hb. All rights reserved.
//

import XCTest

class WL_1_SignUpEmailUITests: WhiteLabelAppUITests {
    
    let aModel = SignUpConfig.SignUptextField()
    
    let fName = "Paul"
    let lName = "Smith"
    let uName = "Paulsmith"
    let email = "paulsmith@grr.la"
    let phone = "0009990019"
    let address = ""
    let city = ""
    let state = ""
    let zip = ""
    let password = ""
    let confirmPassword = ""
    
    
    func initial() {
        elementsQuery.buttons["Create Now!"].tap()
        wait(for: TimeInterval(20))
    }
    
    
    func scrollUp() {
        let signupDefaultUserElement = scrollViewsQuery.otherElements.containing(.image, identifier:"signup_default_user").element
        signupDefaultUserElement.swipeUp()
    }
    
    func scrollDown() {
        let signupDefaultUserElement = scrollViewsQuery.otherElements.containing(.image, identifier:"signup_default_user").element
        signupDefaultUserElement.swipeDown()
    }
    
    func buttonCreateAction(screenShotName: String) {
        elementsQuery.buttons["Create"].tap()
        snapshot(screenShotName,timeWaitingForIdle: 3)
        wait(for: delay)
    }
    
    func toolBarDone(screenShotName: String) {
        //Done tapped
        app.toolbars["Toolbar"].buttons["Done"].tap()
        //Button Create Tapped
        elementsQuery.buttons["Create"].tap()
        snapshot(screenShotName,timeWaitingForIdle: 3)
        wait(for: delay)
    }
    
    func test01FirstNameValidation() {
        
        initial()
        
        //Check visible and optional conditions
        if self.checkCondition(value: aModel.firstname.visible) {
            if !self.checkCondition(value: aModel.firstname.optional) {
                
                //Adjust screen scroll
                self.scrollUp()
                self.buttonCreateAction(screenShotName: "1.0.1FirstNameEmpty")
                self.scrollDown()
                
                //TextField Instance
                elementsQuery.textFields["First Name"].tap()
                
                //Type value in textfield
                self.tapAction(key: fName)
                
                //Done action on textfield and tap action on Create and delay
                self.toolBarDone(screenShotName: "1.0.2LastNameEmpty")
                
            }else if self.checkCondition(value: aModel.firstname.optional) {
                
                //TextField Instance optional case
                let firstNameTextField = elementsQuery.textFields["First Name (optional)"]
                
                //Textfield text length check for optional case if less than 0 means empty so no need to check validation
                if firstNameTextField.staticTexts.count == 0 {
                    elementsQuery.buttons["Create"].tap()
                    wait(for: delay)
                }
                    
                    //Textfield text length check for optional case
                else if firstNameTextField.staticTexts.count > 0 {
                    elementsQuery.buttons["Create"].tap()
                    self.buttonCreateAction(screenShotName: "1.0.2LastNameEmpty")
                    wait(for: delay)
                }
            }
        }
    }
    
    
    func test02LastNameValidation() {
        
        initial()
        
        //TextField Instance
        elementsQuery.textFields["First Name"].tap()
        
        //Type value in textfield
        self.tapAction(key: fName)
        
        
        //Check visible and optional conditions
        if self.checkCondition(value: aModel.lastname.visible) {
            if !self.checkCondition(value: aModel.lastname.optional) {
                
                //Adjust screen scroll
                self.scrollUp()
                
                //TextField Instance
                elementsQuery.textFields["Last Name"].tap()
                
                //Type value in textfield
                self.tapAction(key: lName)
                
                //Done action on textfield and tap action on Create and delay
                self.toolBarDone(screenShotName: "1.0.3EmailEmpty")
                
            }else if self.checkCondition(value: aModel.lastname.optional) {
                
                //TextField Instance optional case
                let firstNameTextField = elementsQuery.textFields["Last Name (optional)"]
                
                //Textfield text length check for optional case if less than 0 means empty so no need to check validation
                if firstNameTextField.staticTexts.count == 0 {
                    elementsQuery.buttons["Create"].tap()
                    wait(for: delay)
                }
                    
                    //Textfield text length check for optional case
                else if firstNameTextField.staticTexts.count > 0 {
                    elementsQuery.buttons["Create"].tap()
                    snapshot("1.0.3OptionalEmailEmpty",timeWaitingForIdle: 3)
                    wait(for: delay)
                }
            }
        }
    }
    
    func test03EmailValidation() {
        
        initial()
        
        //TextField Instance
        elementsQuery.textFields["First Name"].tap()
        
        //Type value in textfield
        self.tapAction(key: fName)
        
        //TextField Instance
        elementsQuery.textFields["Last Name"].tap()
        
        //Type value in textfield
        self.tapAction(key: lName)
        
        //TextField Instance
        elementsQuery.textFields["Email"].tap()
        
        //Type value in textfield
        self.tapAction(key: "label")
        
        //Done action on textfield and tap action on Create and delay
        self.toolBarDone(screenShotName: "1.0.4EmailInvalid")
        
        //Adjust scroll of screen
        self.scrollUp()
        self.scrollDown()
        
        elementsQuery.textFields["Email"].tap()
        //Remove all text from textfield
        self.deleteKey(value: 5, type: "delete")
        
        //Type value in textfield
        self.tapAction(key: email)
        
        //Done action on textfield and tap action on Create and delay
        self.toolBarDone(screenShotName: "1.0.5UserNameValidation")
    }
    
    func test04UserNameValidation() {
        
        initial()
        
        //TextField Instance
        elementsQuery.textFields["First Name"].tap()
        
        //Type value in textfield
        self.tapAction(key: fName)
        
        //TextField Instance
        elementsQuery.textFields["Last Name"].tap()
        
        //Type value in textfield
        self.tapAction(key: lName)
        
        //TextField Instance
        elementsQuery.textFields["Email"].tap()
        
        self.tapAction(key: email)
        
        
        //Check visible and optional conditions
        if self.checkCondition(value: aModel.username.visible) {
            if !self.checkCondition(value: aModel.username.optional) {
                
                //Adjust screen scroll
                self.scrollUp()
                self.scrollDown()
                
                //TextField Instance
                elementsQuery.textFields["Username"].tap()
                
                //Type value in textfield
                self.tapAction(key: "Ap")
                
                //Done action on textfield and tap action on Create and delay
                self.toolBarDone(screenShotName: "1.0.6MinimumCharacterUserName")
                
                //Adjust screen scroll
                self.scrollUp()
                self.scrollDown()
                
                //TextField Instance
                elementsQuery.textFields["Username"].tap()
                //Remove all text from textfield
                self.deleteKey(value: 2, type: "delete")
                
                //Type value in textfield
                self.tapAction(key: "App")
                self.getKey(key: "more").tap()
                self.tapAction(key: "@12")
                
                //Done action on textfield and tap action on Create and delay
                self.toolBarDone(screenShotName: "1.0.7InvalidUserName")
                
                //Adjust screen scroll
                self.scrollUp()
                self.scrollDown()
                
                elementsQuery.textFields["Username"].tap()
                //Remove all text from textfield
                self.deleteKey(value: 6, type: "delete")
                
                //Type value in textfield
                self.tapAction(key: uName)
                
                //Done action on textfield and tap action on Create and delay
                self.toolBarDone(screenShotName: "1.0.8PhoneNumberEmpty")
                
            } else if self.checkCondition(value: aModel.username.optional) {
                
                //TextField Instance optional case
                let userNameTextField = elementsQuery.textFields["Username (optional)"]
                
                if userNameTextField.staticTexts.count == 0 {
                    
                    //Adjust screen scroll
                    self.scrollUp()
                    self.scrollDown()
                    
                    app.toolbars["Toolbar"].buttons["Done"].tap()
                    elementsQuery.textFields["Username (optional)"].tap()
                    
                    //Type value in textfield
                    self.tapAction(key: "App")
                    self.getKey(key: "more").tap()
                    self.tapAction(key: "@12")
                    
                    //Done action on textfield and tap action on Create and delay
                    self.toolBarDone(screenShotName: "1.0.7OptionalInvalidUserName")
                    
                    //Adjust screen scroll
                    self.scrollUp()
                    self.scrollDown()
                    
                    elementsQuery.textFields["Username (optional)"].tap()
                    //Remove all text from textfield
                    self.deleteKey(value: 6, type: "delete")
                    
                    //Type value in textfield
                    self.tapAction(key: uName)
                    
                    //Done action on textfield and tap action on Create and delay
                    self.toolBarDone(screenShotName: "1.0.8PhoneNumberEmpty")
                }
                //Textfield text length check for optional case
                if userNameTextField.staticTexts.count > 0 {
                    elementsQuery.buttons["Create"].tap()
                    wait(for: delay)
                }
            }
        }
    }
    
    func test05MobileValidation() {
        
        initial()
        
        //TextField Instance
        elementsQuery.textFields["First Name"].tap()
        self.tapAction(key: fName)
        
        //TextField Instance
        elementsQuery.textFields["Last Name"].tap()
        self.tapAction(key: lName)
        
        //TextField Instance
        elementsQuery.textFields["Email"].tap()
        self.tapAction(key: email)
        
        //TextField Instance
        elementsQuery.textFields["Username"].tap()
        self.tapAction(key: uName)
        
        
        //Check visible and optional conditions
        if self.checkCondition(value: aModel.phonenumber.visible) {
            if !self.checkCondition(value: aModel.phonenumber.optional) {
                
                //Adjust screen scroll
                self.scrollUp()
                self.scrollDown()
                
                //TextField Instance
                elementsQuery.textFields["Phone Number"].tap()
                
                //Type value in textfield
                self.tapAction(key: "99")
                
                //Done action on textfield and tap action on Create and delay
                self.toolBarDone(screenShotName: "1.0.9InvalidPhoneNumber")
                
                //Adjust screen scroll
                self.scrollUp()
                self.scrollDown()
                
                elementsQuery.textFields["Phone Number"].tap()
                //Remove all text from textfield
                self.deleteKey(value: 2, type: "Delete")
                
                //Type value in textfield
                self.tapAction(key: phone)
                
                //Done action on textfield and tap action on Create and delay
                self.toolBarDone(screenShotName: "1.1.0EmptyAddress")
                
                
            }else if self.checkCondition(value: aModel.phonenumber.optional) {
                
                //TextField Instance optional case
                let phoneNumberTextField = elementsQuery.textFields["Phone Number (optional)"]
                
                if phoneNumberTextField.staticTexts.count == 0 {
                    
                    //Adjust screen scroll
                    self.scrollUp()
                    self.scrollDown()
                    
                    elementsQuery.textFields["Phone Number (optional)"].tap()
                    
                    //Type value in textfield
                    self.tapAction(key: "99")
                    
                    //Done action on textfield and tap action on Create and delay
                    self.toolBarDone(screenShotName: "1.0.9OptionalInvalidPhoneNumber")
                    
                    //Adjust screen scroll
                    self.scrollUp()
                    self.scrollDown()
                    
                    elementsQuery.textFields["Phone Number (optional)"].tap()
                    //Remove all text from textfield
                    self.deleteKey(value: 2, type: "Delete")
                    
                    //Type value in textfield
                    self.tapAction(key: phone)
                    
                    //Done action on textfield and tap action on Create and delay
                    self.toolBarDone(screenShotName: "1.1.0EmptyAddress")
                }
                //Textfield text length check for optional case
                if phoneNumberTextField.staticTexts.count > 0 {
                    elementsQuery.buttons["Create"].tap()
                    wait(for: delay)
                }
            }
        }
    }
    
    func test06AddressValidation() {
        
        initial()
        
        //TextField Instance
        elementsQuery.textFields["First Name"].tap()
        self.tapAction(key: fName)
        
        //TextField Instance
        elementsQuery.textFields["Last Name"].tap()
        self.tapAction(key: lName)
        
        //TextField Instance
        elementsQuery.textFields["Email"].tap()
        self.tapAction(key: email)
        
        //TextField Instance
        elementsQuery.textFields["Username"].tap()
        self.tapAction(key: uName)
        
        //TextField Instance
        elementsQuery.textFields["Phone Number"].tap()
        
        //Type value in textfield
        self.tapAction(key: phone)
        self.scrollUp()
        self.scrollDown()
        
        
        //Check visible and optional conditions
        if self.checkCondition(value: aModel.streetaddress.visible) {
            if !self.checkCondition(value: aModel.streetaddress.optional) {
                
                //Adjust screen scroll
                self.scrollDown()
                
                 //Done tapped
                app.toolbars["Toolbar"].buttons["Done"].tap()
                
                //Type value in textfield
                 elementsQuery.textFields["Address"].tap()
                
                
                self.getKey(key: "more").tap()
                self.tapAction(key: "1010")
                
                snapshot("1.1.1Adress",timeWaitingForIdle: 3)
                
                //Select address from table
                app.tables.staticTexts["1010 Massachusetts Avenue"].tap()
                
                //Button Create Tapped
                elementsQuery.buttons["Create"].tap()
                wait(for: delay)
                
                if !self.checkCondition(value: aModel.city.optional) {
                    elementsQuery.textFields["City"].tap()
                    
                    //Remove all text from textfield
                    self.deleteKey(value: 6, type: "delete")
                    
                    //Done action on textfield and tap action on Create and delay
                    self.toolBarDone(screenShotName: "1.1.2CityValidation")
                    
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
                    self.toolBarDone(screenShotName: "1.1.2OptionalCityValidation")
                    
                    elementsQuery.textFields["City (optional)"].tap()
                    
                    //Type value in textfield
                    self.tapAction(key: "Boston")
                    
                    //Done tapped
                    app.toolbars["Toolbar"].buttons["Done"].tap()
                }
                
                if !self.checkCondition(value: aModel.state.optional) {
                    elementsQuery.textFields["State"].tap()
                    
                    //Done action on textfield and tap action on Create and delay
                    self.toolBarDone(screenShotName: "1.1.5DateOfBirth")
                }
                
                if self.checkCondition(value: aModel.state.optional) {
                    elementsQuery.textFields["State (optional)"].tap()
                    
                    //Done action on textfield and tap action on Create and delay
                    self.toolBarDone(screenShotName: "1.1.5DateOfBirth")
                }
                
            }else if self.checkCondition(value: aModel.streetaddress.optional) {
                
                //TextField Instance optional case
                elementsQuery.textFields["Address (optional)"].tap()
                
                //Type value in textfield
                self.getKey(key: "more").tap()
                self.tapAction(key: "1010")
                
                snapshot("1.1.1Adress",timeWaitingForIdle: 3)
                
                //Select address from table
                app.tables/*@START_MENU_TOKEN@*/.staticTexts["1010 Massachusetts Avenue"]/*[[".cells.staticTexts[\"1010 Massachusetts Avenue\"]",".staticTexts[\"1010 Massachusetts Avenue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
                
                //Button Create Tapped
                elementsQuery.buttons["Create"].tap()
                wait(for: delay)
                
                
                if !self.checkCondition(value: aModel.city.optional) {
                    elementsQuery.textFields["City"].tap()
                    
                    //Remove all text from textfield
                    self.deleteKey(value: 6, type: "delete")
                    
                    //Done action on textfield and tap action on Create and delay
                    self.toolBarDone(screenShotName: "1.1.2CityValidation")
                    
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
                    self.toolBarDone(screenShotName: "1.1.2OptionalCityValidation")
                    
                    elementsQuery.textFields["City (optional)"].tap()
                    
                    //Type value in textfield
                    self.tapAction(key: "Boston")
                    
                    //Done action on textfield and tap action on Create and delay
                    //self.toolBarDone()
                    //Done tapped
                    app.toolbars["Toolbar"].buttons["Done"].tap()
                }
                
                if !self.checkCondition(value: aModel.state.optional) {
                    elementsQuery.textFields["State"].tap()
                    
                    //Done action on textfield and tap action on Create and delay
                    self.toolBarDone(screenShotName: "1.1.5DateOfBirth")
                    
                }
                if self.checkCondition(value: aModel.state.optional) {
                    elementsQuery.textFields["State (optional)"].tap()
                    
                    //Done action on textfield and tap action on Create and delay
                    self.toolBarDone(screenShotName: "1.1.5DateOfBirth")
                }
            }
        }
    }
    
    func test07ZipCodeValidation() {
        
        initial()
        
        //TextField Instance
        elementsQuery.textFields["First Name"].tap()
        self.tapAction(key: fName)
        
        //TextField Instance
        elementsQuery.textFields["Last Name"].tap()
        self.tapAction(key: lName)
        
        //TextField Instance
        elementsQuery.textFields["Email"].tap()
        self.tapAction(key: email)
        
        //TextField Instance
        elementsQuery.textFields["Username"].tap()
        self.tapAction(key: uName)
        
        //TextField Instance
        elementsQuery.textFields["Phone Number"].tap()
        
        //Type value in textfield
        self.tapAction(key: phone)
        
        app.toolbars["Toolbar"].buttons["Done"].tap()
        elementsQuery.textFields["Address"].tap()
        
        //Type value in textfield
        self.getKey(key: "more").tap()
        self.tapAction(key: "1010")
        //Select address from table
        app.tables.staticTexts["1010 Massachusetts Avenue"].tap()
        
        
        if !self.checkCondition(value: aModel.zip.optional) {
            elementsQuery.textFields["Zip Code"].tap()
            
            let text = (elementsQuery.textFields["Zip Code"].value as! String)
            if text.count > 0 {
                self.deleteKey(value: text.count, type: "delete")
                elementsQuery.buttons["Create"].tap()
                snapshot("1.1.3ZipValidation",timeWaitingForIdle: 3)
                wait(for: delay)
            }
            
            self.getKey(key: "more").tap()
            self.tapAction(key: "12")
            elementsQuery.buttons["Create"].tap()
            snapshot("1.1.4ZipInvalidValidation",timeWaitingForIdle: 3)
            wait(for: delay)
            
            self.deleteKey(value: 2, type: "delete")
            self.tapAction(key: "12345")
            elementsQuery.buttons["Create"].tap()
            snapshot("1.1.5DateOfBirth",timeWaitingForIdle: 3)
            wait(for: delay)
            
        }
        if self.checkCondition(value: aModel.zip.optional) {
            elementsQuery.textFields["Zip Code (optional)"].tap()
            
            let text = (elementsQuery.textFields["Zip Code (optional)"].value as! String)
            if text.count > 0 {
                self.deleteKey(value: text.count, type: "delete")
            }
            self.getKey(key: "more").tap()
            self.tapAction(key: "12")
            elementsQuery.buttons["Create"].tap()
            snapshot("1.1.4ZipInvalidValidation",timeWaitingForIdle: 3)
            wait(for: delay)
            
            self.deleteKey(value: 2, type: "delete")
            self.tapAction(key: "12345")
            elementsQuery.buttons["Create"].tap()
            snapshot("1.1.5DateOfBirth",timeWaitingForIdle: 3)
            wait(for: delay)
        }
    }
    
    func test08DateOfBirthValidation() {
        initial()
        
        //TextField Instance
        elementsQuery.textFields["First Name"].tap()
        self.tapAction(key: fName)
        
        //TextField Instance
        elementsQuery.textFields["Last Name"].tap()
        self.tapAction(key: lName)
        
        //TextField Instance
        elementsQuery.textFields["Email"].tap()
        self.tapAction(key: email)
        
        //TextField Instance
        elementsQuery.textFields["Username"].tap()
        self.tapAction(key: uName)
        
        //TextField Instance
        elementsQuery.textFields["Phone Number"].tap()
        
        //Type value in textfield
        self.tapAction(key: phone)
        
        app.toolbars["Toolbar"].buttons["Done"].tap()
        elementsQuery.textFields["Address"].tap()
        
        //Type value in textfield
        self.getKey(key: "more").tap()
        self.tapAction(key: "1010")
        //Select address from table
        app.tables.staticTexts["1010 Massachusetts Avenue"].tap()
        
        //        elementsQuery.textFields["Zip Code"].tap()
        //        self.getKey(key: "more").tap()
        //        self.tapAction(key: "12345")
        
        if !self.checkCondition(value: aModel.dateofbirth.optional) {
            elementsQuery.textFields["Date of Birth"].tap()
            
            //Done action on textfield and tap action on Create and delay
            self.toolBarDone(screenShotName: "1.1.6EnterPassword")
        }
        if self.checkCondition(value: aModel.dateofbirth.optional) {
            elementsQuery.textFields["Date of Birth (optional)"].tap()
            
            //Done action on textfield and tap action on Create and delay
            self.toolBarDone(screenShotName: "1.1.6EnterPassword")
        }
    }
    
    func test09PasswordValidation() {
        
        initial()
        
        //TextField Instance
        elementsQuery.textFields["First Name"].tap()
        self.tapAction(key: fName)
        
        //TextField Instance
        elementsQuery.textFields["Last Name"].tap()
        self.tapAction(key: lName)
        
        //TextField Instance
        elementsQuery.textFields["Email"].tap()
        self.tapAction(key: email)
        
        //TextField Instance
        elementsQuery.textFields["Username"].tap()
        self.tapAction(key: uName)
        
        //TextField Instance
        elementsQuery.textFields["Phone Number"].tap()
        
        //Type value in textfield
        self.tapAction(key: phone)
        
        app.toolbars["Toolbar"].buttons["Done"].tap()
        elementsQuery.textFields["Address"].tap()
        
        //Type value in textfield
        self.getKey(key: "more").tap()
        self.tapAction(key: "1010")
        //Select address from table
        app.tables.staticTexts["1010 Massachusetts Avenue"].tap()
        
        
        elementsQuery.textFields["Date of Birth"].tap()
        
        //Done action on textfield and tap action on Create and delay
        self.toolBarDone(screenShotName: "1.1.6EnterPassword")
        
        
        
        //TextField Instance
        elementsQuery.secureTextFields["Password"].tap()
        
        //Type value in textfield
        self.tapAction(key: "qw")
        
        //Done action on textfield and tap action on Create and delay
        self.toolBarDone(screenShotName: "1.1.7InvalidPassword")
        
        //Adjust screen scroll
        self.scrollUp()
        self.scrollDown()
        
        elementsQuery.secureTextFields["Password"].tap()
        //Remove all text from textfield
        self.deleteKey(value: 2, type: "delete")
        
        //Type value in textfield
        app/*@START_MENU_TOKEN@*/.buttons["shift"]/*[[".keyboards.buttons[\"shift\"]",".buttons[\"shift\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        self.tapAction(key: "Qwerty")
        self.getKey(key: "more").tap()
        self.tapAction(key: "123")
        
        //Done action on textfield and tap action on Create and delay
        self.toolBarDone(screenShotName: "1.1.8EnterConfirmPassword")
    }
    
    func test10ConfirmPasswordValidation() {
        
        initial()
        
        //TextField Instance
        elementsQuery.textFields["First Name"].tap()
        self.tapAction(key: fName)
        
        //TextField Instance
        elementsQuery.textFields["Last Name"].tap()
        self.tapAction(key: lName)
        
        //TextField Instance
        elementsQuery.textFields["Email"].tap()
        self.tapAction(key: email)
        
        //TextField Instance
        elementsQuery.textFields["Username"].tap()
        self.tapAction(key: uName)
        
        //TextField Instance
        elementsQuery.textFields["Phone Number"].tap()
        
        //Type value in textfield
        self.tapAction(key: phone)
        
        app.toolbars["Toolbar"].buttons["Done"].tap()
        elementsQuery.textFields["Address"].tap()
        
        //Type value in textfield
        self.getKey(key: "more").tap()
        self.tapAction(key: "1010")
        //Select address from table
        app.tables.staticTexts["1010 Massachusetts Avenue"].tap()
        
        
        elementsQuery.textFields["Date of Birth"].tap()
        
        //Done action on textfield and tap action on Create and delay
        self.toolBarDone(screenShotName: "1.1.6EnterPassword")
        
        //TextField Instance
        elementsQuery.secureTextFields["Password"].tap()
        
        app/*@START_MENU_TOKEN@*/.buttons["shift"]/*[[".keyboards.buttons[\"shift\"]",".buttons[\"shift\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        self.tapAction(key: "Qwerty")
        self.getKey(key: "more").tap()
        self.tapAction(key: "123")
        
        //TextField Instance
        elementsQuery.secureTextFields["Confirm Password"].tap()
        
        //Type value in textfield
        self.tapAction(key: "qwqw")
        
        //Done action on textfield and tap action on Create and delay
        self.toolBarDone(screenShotName: "1.1.9PasswordAndConfirmPassword")
        
        //Adjust screen scroll
        self.scrollUp()
        self.scrollDown()
        
        elementsQuery.secureTextFields["Confirm Password"].tap()
        //Remove all text from textfield
        self.deleteKey(value: 2, type: "delete")
        
        //Type value in textfield
        app/*@START_MENU_TOKEN@*/.buttons["shift"]/*[[".keyboards.buttons[\"shift\"]",".buttons[\"shift\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        self.tapAction(key: "Qwerty")
        self.getKey(key: "more").tap()
        self.tapAction(key: "123")
        
        //Done action on textfield and tap action on Create and delay
        self.toolBarDone(screenShotName: "1.2.0AcceptTermsCondition")
    }
    
    func test11CheckTermsCondition() {
        
        initial()
        
        //TextField Instance
        elementsQuery.textFields["First Name"].tap()
        self.tapAction(key: fName)
        
        //TextField Instance
        elementsQuery.textFields["Last Name"].tap()
        self.tapAction(key: lName)
        
        //TextField Instance
        elementsQuery.textFields["Email"].tap()
        self.tapAction(key: email)
        
        //TextField Instance
        elementsQuery.textFields["Username"].tap()
        self.tapAction(key: uName)
        
        //TextField Instance
        elementsQuery.textFields["Phone Number"].tap()
        
        //Type value in textfield
        self.tapAction(key: phone)
        
        app.toolbars["Toolbar"].buttons["Done"].tap()
        elementsQuery.textFields["Address"].tap()
        
        //Type value in textfield
        self.getKey(key: "more").tap()
        self.tapAction(key: "1010")
        //Select address from table
        app.tables.staticTexts["1010 Massachusetts Avenue"].tap()
        
        
        elementsQuery.textFields["Date of Birth"].tap()
        
        //Done action on textfield and tap action on Create and delay
        self.toolBarDone(screenShotName: "1.1.6EnterPassword")
        
        //TextField Instance
        elementsQuery.secureTextFields["Password"].tap()
        
        app.buttons["shift"].tap()
        self.tapAction(key: "Qwerty")
        self.getKey(key: "more").tap()
        self.tapAction(key: "123")
        
        //TextField Instance
        elementsQuery.secureTextFields["Confirm Password"].tap()
        
        //Type value in textfield
        app.buttons["shift"].tap()
        self.tapAction(key: "Qwerty")
        self.getKey(key: "more").tap()
        self.tapAction(key: "123")
        
        
        elementsQuery.buttons["signup uncheck"].tap()
        //Button Create Tapped
        elementsQuery.buttons["Create"].tap()
        snapshot("1.2.1Success",timeWaitingForIdle: 10)
        wait(for: apiDelay)
    }
    
}
