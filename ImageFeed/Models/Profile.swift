//
//  Profile.swift
//  ImageFeed
//
//  Created by Анна Рыкунова on 15.08.2024.
//

import Foundation

struct Profile {
    let username: String
    let name: String
    var loginName: String {
        return "@\(username)"
    }
    let bio: String?
}
