//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Анна Рыкунова on 01.08.2024.
//

import UIKit

final class AuthViewController: UIViewController {
    weak var delegate: AuthViewControllerDelegate?
    
    // MARK: - Private properties
    private let WebViewSegueIdentifier = "WebViewSegue"
    private let oAuth2Service = OAuth2Service.shared
    private let oAuth2Storage = OAuth2TokenStorageService.shared

    @IBOutlet var loginButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLoginButton()
        configureBackButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if
            segue.identifier == WebViewSegueIdentifier,
            let webViewViewController = segue.destination as? WebViewViewController
        {
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Private methods
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: #selector(webViewViewControllerDidCancel))
        navigationItem.backBarButtonItem?.tintColor = .ypBlack
    }
    
    private func configureLoginButton() {
        loginButton.layer.cornerRadius = 16
        loginButton.layer.masksToBounds = true
    }
}

// MARK: - WebViewViewControllerDelegate
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
        oAuth2Service.fetchOAuthToken(code: code) { [weak self] result in
            guard let self, let delegate = self.delegate else { return }
            switch result {
            case .success(let token):
                self.oAuth2Storage.token = token
                delegate.didAuthenticate(self)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
