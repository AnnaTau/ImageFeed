//
//  ProfileViewTests.swift
//  ImageFeed
//
//  Created by Анна Рыкунова on 22.09.2024.
//

@testable import ImageFeed
import XCTest

final class ProfileViewTests: XCTestCase {
    func testAvatarUpdateCalled() {
        let profileViewController = ProfileViewController()
        let profilePresenterSpy = ProfilePresenterSpy()
        profilePresenterSpy.view = profileViewController
        profileViewController.presenter = profilePresenterSpy
        
        _ = profileViewController.view
        XCTAssertTrue(profilePresenterSpy.updateAvatarCalled)
    }
    
    func testProfileInfoIsSet() {
        let profileViewController = ProfileViewController()
        let profilePresenterSpy = ProfilePresenterSpy()
        profilePresenterSpy.view = profileViewController
        profileViewController.presenter = profilePresenterSpy
        
        _ = profileViewController.view
        XCTAssertEqual(profileViewController.nameLabel.text, "TestName")
        XCTAssertEqual(profileViewController.loginNameLabel.text, "TestLogin")
        XCTAssertEqual(profileViewController.descriptionLabel.text, "TestDescription")
    }
}

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var view: ImageFeed.ProfileViewControllerProtocol?
    var updateAvatarCalled: Bool = false
    
    func viewDidLoad() {
        view?.setProfileInfo(name: "TestName", login: "TestLogin", bio: "TestDescription")
    }
    
    func avatarURL() -> URL? {
        updateAvatarCalled = true
        return nil
    }
    
    func logout() {
        
    }
}
