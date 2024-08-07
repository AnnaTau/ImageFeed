//
//  OAuthTokenResponse.swift
//  ImageFeed
//
//  Created by Анна Рыкунова on 05.08.2024.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: UInt
}
