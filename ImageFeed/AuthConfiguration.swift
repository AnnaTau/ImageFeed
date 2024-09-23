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
        static let accessScope: String = "public+read_user+write_likes"
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
    
    enum Profile {
        static let profileURLString: String = "https://api.unsplash.com/me"
        static let usersURLString: String = "https://api.unsplash.com/users/"
    }
    
    enum Photos {
        static let photosURLString: String = "https://api.unsplash.com/photos"
        static let perPage: Int = 10
    }
    
    enum Segues {
        static let showSingleImageSegueIdentifier = "ShowSingleImage"
        static let webViewSegueIdentifier = "WebViewSegue"
    }
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    init(accessKey: String,
         secretKey: String,
         redirectURI: String,
         accessScope: String,
         authURLString: String,
         defaultBaseURL: URL
    ) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
        guard let baseURL = Constants.Auth.defaultBaseURL else {
            preconditionFailure("Wrong base URL")
        }
        return .init(
            accessKey: Constants.API.accessKey,
            secretKey: Constants.API.secretKey,
            redirectURI: Constants.API.redirectURI,
            accessScope: Constants.API.accessScope,
            authURLString: Constants.Auth.authorizeURLString,
            defaultBaseURL: baseURL
        )
    }
}
