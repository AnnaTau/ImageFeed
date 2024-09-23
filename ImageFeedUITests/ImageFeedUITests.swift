//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Анна Рыкунова on 21.09.2024.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    
    private let app = XCUIApplication()
    enum UserData {
        static let username = ""
        static let password = ""
        static let fullName = ""
        static let userName = ""
    }
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchEnvironment = ["isUITesting": "YES"]
        app.launch()
    }
    
    func testAuth() throws {
        // тестируем сценарий авторизации
        let loginButton = app.buttons["Authenticate"]
        XCTAssertTrue(loginButton.waitForExistence(timeout: 10))
        loginButton.tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 10))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText(UserData.username)
        webView.swipeUp()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        sleep(1)
        passwordTextField.typeText(UserData.password)
        webView.swipeUp()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 10))
        
    }
    
    func testFeed() throws {
        // тестируем сценарий ленты
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 10))
        cell.swipeUp()
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        if cellToLike.buttons["like_button_off"].waitForExistence(timeout: 5) {
            cellToLike.buttons["like_button_off"].tap()
            XCTAssertTrue(cellToLike.buttons["like_button_on"].waitForExistence(timeout: 5))
            cellToLike.buttons["like_button_on"].tap()
            XCTAssertTrue(cellToLike.buttons["like_button_off"].waitForExistence(timeout: 5))
        } else {
            XCTAssertTrue(cellToLike.buttons["like_button_on"].waitForExistence(timeout: 5))
            cellToLike.buttons["like_button_on"].tap()
            XCTAssertTrue(cellToLike.buttons["like_button_off"].waitForExistence(timeout: 5))
            cellToLike.buttons["like_button_off"].tap()
            XCTAssertTrue(cellToLike.buttons["like_button_on"].waitForExistence(timeout: 5))
        }
        
        cellToLike.tap()
        let fullImage = app.scrollViews.images["full_image"]
        XCTAssertTrue(fullImage.waitForExistence(timeout: 30))
        sleep(1)
        
        fullImage.pinch(withScale: 3, velocity: 1)
        fullImage.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["nav_back_button"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        // тестируем сценарий профиля
        let profileTab = app.tabBars.buttons.element(boundBy: 1)
        XCTAssertTrue(profileTab.waitForExistence(timeout: 10))
        profileTab.tap()
        
        XCTAssertTrue(app.staticTexts[UserData.fullName].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts[UserData.userName].waitForExistence(timeout: 5))
        
        app.buttons["logoutButton"].tap()
        
        let yesButton = app.alerts.buttons["yesAlertButton"]
        XCTAssertTrue(yesButton.waitForExistence(timeout: 5))
        yesButton.tap()
        
        let loginButton = app.buttons["Authenticate"]
        XCTAssertTrue(loginButton.waitForExistence(timeout: 10))
    }
}
    

