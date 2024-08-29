//
//  OAuth2TokenStorageService.swift
//  ImageFeed
//
//  Created by Анна Рыкунова on 05.08.2024.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorageService {
    static let shared = OAuth2TokenStorageService()
    private init() { }
    
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: Constants.Token.storageKey)
        } set {
            if let newValue {
                let isSuccess = KeychainWrapper.standard.set(newValue, forKey: Constants.Token.storageKey)
                guard isSuccess else {
                    preconditionFailure("Writing auth token was fail")
                }
            } else {
                preconditionFailure("Writing auth token was fail: newValue is nil")
            }
            
        }
    }
}
