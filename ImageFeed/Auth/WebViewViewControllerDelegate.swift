//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Анна Рыкунова on 02.08.2024.
//

import Foundation

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
