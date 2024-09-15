//
//  Profile.swift
//  ImageFeed
//
//  Created by Анна Рыкунова on 15.08.2024.
//

import Foundation

// MARK: - UI Model

struct Profile {
    let username: String
    let name: String?
    var loginName: String {
        return "@\(username)"
    }
    let bio: String?
}

// MARK: - Data Model

struct ProfileResult: Codable {
    let username: String
    let firstName: String?
    let lastName: String?
    let bio: String?
}

struct UserResult: Codable {
    let profileImage: AvatarUrls
}

struct AvatarUrls: Codable {
    let small: String
    let medium: String
    let large: String
}
