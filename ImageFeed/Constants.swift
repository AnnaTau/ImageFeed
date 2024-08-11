//
//  Constants.swift
//  ImageFeed
//
//  Created by Анна Рыкунова on 30.07.2024.
//

import Foundation

enum Constants {
    enum API {
        static let accessKey: String = "dV4inl3UtmKrC9KUhytRAFQFAi1UtqQ8aFtbuFE70tk"
        static let secretKey: String = "iVZG1jL0X4XJq1ERrp5zhFHx38Q-gnBn_L0w0RncE28"
        static let redirectURI: String = "urn:ietf:wg:oauth:2.0:oob"
        static let accessScope: String = "public"
    }
    
    enum Token {
        static let grantType: String = "authorization_code"
        static let storageKey: String = "token"
        static let baseURLString: String =  "https://unsplash.com/oauth/token"
    }
    
    enum Auth {
        static let authorizeURLString: String = "https://unsplash.com/oauth/authorize"
        static let defaultBaseURL: URL? = .init(string: "https://api.unsplash.com/")
    }
}
