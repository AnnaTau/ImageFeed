//
//  AuthViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Анна Рыкунова on 06.08.2024.
//

import Foundation

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ viewController: AuthViewController)
}
