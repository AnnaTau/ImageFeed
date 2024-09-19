//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Анна Рыкунова on 19.09.2024.
//

import UIKit

public protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func avatarURL() -> URL?
    func logout()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    private let profileService = ProfileService.shared
    private let profileLogoutService = ProfileLogoutService.shared
    
    func viewDidLoad() {
        let profile = profileService.profile ?? Profile(username: "", name: "", bio: "")
        view?.setProfileInfo(name: profile.name, login: profile.username, bio: profile.bio)
    }
    
    func avatarURL() -> URL? {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else {
            preconditionFailure("Profile image URL is invalid")
        }
        return url
    }
    
    func logout() {
        profileLogoutService.logout()
    }
}
