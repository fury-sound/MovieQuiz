//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Valery Zvonarev on 15.07.2024.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        app = XCUIApplication()
        app.launch()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        // это специальная настройка для тестов: если один тест не прошёл,
        // то следующие тесты запускаться не будут; и правда, зачем ждать?
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
        app.terminate()
        app = nil
    }
    
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testScreenCast() throws {
        
        //        let app = XCUIApplication()
        app.buttons["Да"].tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["Нет"]/*[[".buttons[\"Нет\"].staticTexts[\"Нет\"]",".staticTexts[\"Нет\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
    }
    
    func testYesButton() {
        let indexLabel = app.staticTexts["Index"]
        sleep(15)
        let firstPoster = app.images["Poster"]  // находим первоначальный постер
        //        XCTAssertTrue(firstPoster.exists)
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["Yes"].tap() // находим кнопку "Да" и нажимаем ее
        sleep(15)
        let secondPoster = app.images["Poster"] // еще раз находим постер
        //        XCTAssertTrue(secondPoster.exists)
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        //        XCTAssertFalse(firstPoster == secondPoster) // проверяем, что постеры разные
        //        XCTAssertFalse(firstPosterData == secondPosterData) // проверяем, что постеры разные
        XCTAssertNotEqual(firstPosterData, secondPosterData) // проверяем, что постеры разные - другая функция
        let res = indexLabel.label
        XCTAssertEqual(res, "2/10")
    }
    
    func testNoButton() {
        var indexLabel = app.staticTexts["Index"]
        sleep(5)
        let firstPoster = app.images["Poster"]
        let firstPosterData  = firstPoster.screenshot().pngRepresentation
        XCTAssertEqual(indexLabel.label, "1/10")
        app.buttons["No"].tap()
        indexLabel = app.staticTexts["Index"]
        sleep(5)
        let secondPoster = app.images["Poster"]
        let secondPosterData  = secondPoster.screenshot().pngRepresentation
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testAlertDialog() {
        let id = "MyAlert"
        for _ in 1...10 {
            sleep(1)
//            print(ind)
            app.buttons["Yes"].tap()
        }
        sleep(1)
        XCTAssertTrue(app.alerts[id].exists)
        let alert = app.alerts[id]
//        print("Elements:" ,  alert.label)
        XCTAssertEqual(alert.label, "Раунд окончен")
        XCTAssertEqual(alert.buttons.firstMatch.label, "Сыграть еще раз!")
    }
    
}
