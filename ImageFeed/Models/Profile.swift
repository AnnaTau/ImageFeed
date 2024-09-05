//
//  Profile.swift
//  ImageFeed
//
//  Created by Анна Рыкунова on 15.08.2024.
//

import Foundation

struct Profile {
    let username: String
    let name: String?
    var loginName: String {
        return "@\(username)"
    }
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
