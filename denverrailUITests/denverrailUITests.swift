//
//  denverrailUITests.swift
//  denverrailUITests
//
//  Created by Naomi Himley on 6/1/16.
//  Copyright © 2016 Tack Mobile. All rights reserved.
//

import XCTest

class denverrailUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    func testOpenThenCloseMap() {
        app.buttons["mapButton"].tap()
        
        let webViewQuery:XCUIElementQuery = app.descendants(matching: .any)
        let pdfMapView = webViewQuery.element(matching: .any, identifier:"Map View")
        XCTAssertNotNil(pdfMapView)
        XCTAssertTrue(pdfMapView.isHittable)
        
        //Close map and make sure table with Eastbound/Westbound is showing
        app.buttons["mapButton"].tap()
        let eastboundButton = app.buttons["South Or East Button"]
        XCTAssertTrue(eastboundButton.isHittable)
    }
    
    func testAutoButton() {
        let autobuttonButton = app.buttons["autoButton"]
        autobuttonButton.tap()
        
        //After tapping the auto button make sure the picker appears
        app.buttons["Open Time Picker"].tap()
        let datePicker = app.pickers["Non Auto Time Picker"]
        XCTAssertNotNil(datePicker)
        
        //Set picker to Holiday then dismiss
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "Holiday")
        app.buttons["Done"].tap()
        
        //Check that label showing Holiday exists
        let label = app.staticTexts["Holiday"]
        let exists = NSPredicate(format: "exists == true")
        
        expectation(for: exists, evaluatedWith: label, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSearch () {
        //Tap to open Search
        app.buttons["Station Search Button"].tap()
        
        //Check number of rows is 61 for all 64 stations
        let tablesQuery = app.tables
        let count = tablesQuery.cells.count
        XCTAssert(count == 61)
        
        //Search for Union
        let searchTextField = app.textFields["Find a Station"]
        searchTextField.tap()
        searchTextField.typeText("Union")
        app.keyboards.buttons["Done"].tap()
        
        //Check there is only one result
        let searchTableQuery = app.tables
        let resultCount = searchTableQuery.cells.count
        XCTAssert(resultCount == 1)
        
        //Select Union to dismiss search and check Union was selected
        app.tables.staticTexts["Union "].tap()
        
        let stationNameQuery:XCUIElementQuery = app.descendants(matching: .any)
        let stationNameLabel = stationNameQuery.element(matching: .any, identifier:"Station Name Label")
        XCTAssertTrue(stationNameLabel.label == "Union Station")
    }
    
    func testNowButton () {
        //Get time test is being run
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd h:mm a"
        let constructedTimeString = dateFormatter.string(from: now)
        
        //Start test
        app.buttons["autoButton"].tap()
        
        //Make sure the picker appears
        app.buttons["Open Time Picker"].tap()
        let datePicker = app.pickers["Non Auto Time Picker"]
        XCTAssertNotNil(datePicker)
        
        //Mess up the picker
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "Holiday")
        app.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "12")
        app.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "59")

        //Tap NOW, dismiss and then make sure the current times show up
        app.buttons["Now"].tap()
        app.buttons["Done"].tap()
        
        let label = app.staticTexts[constructedTimeString]
        let exists = NSPredicate(format: "exists == true")
        expectation(for:exists, evaluatedWith: label, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
    }
}
