//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Анна Рыкунова on 21.09.2024.
//

import XCTest

final class ImageFeedUITests: XCTestCase {

    private let app = XCUIApplication() // переменная приложения
        
        override func setUpWithError() throws {
            continueAfterFailure = false // настройка выполнения тестов, которая прекратит выполнения тестов, если в тесте что-то пошло не так
            
            app.launch() // запускаем приложение перед каждым тестом
        }
        
        func testAuth() throws {
            // тестируем сценарий авторизации
            app.buttons["Authenticate"].tap()
            
        }
        
        func testFeed() throws {
            // тестируем сценарий ленты
        }
        
        func testProfile() throws {
            // тестируем сценарий профиля
        }
    
}
