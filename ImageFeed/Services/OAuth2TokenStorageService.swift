//
//  OAuth2TokenStorageService.swift
//  ImageFeed
//
//  Created by Анна Рыкунова on 05.08.2024.
//

import Foundation

final class OAuth2TokenStorageService {
    static let shared = OAuth2TokenStorageService()
    private init() { }
    
    var token: String? {
        get {
            UserDefaults.standard.string(forKey: Constants.Token.storageKey)
        } set {
            UserDefaults.standard.setValue(newValue, forKey: Constants.Token.storageKey)
        }
    }
}
