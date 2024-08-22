//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Анна Рыкунова on 05.08.2024.
//

import UIKit

final class SplashViewController: UIViewController {
    private let oAuth2Storage = OAuth2TokenStorageService.shared
    private let profileService = ProfileService.shared
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthScene"
    
    // MARK: - Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let token = oAuth2Storage.token {
            fetchProfile(token)
            switchToTabBarController()
        } else {
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                assertionFailure("Failed to prepare for \(showAuthenticationScreenSegueIdentifier)")
                return
            }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

// MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        guard let token = oAuth2Storage.token else {
            return
        }
        fetchProfile(token)
        switchToTabBarController()
        UIBlockingProgressHUD.dismiss()
    }
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profileResult):
                ProfileImageService.shared.fetchProfileImageURL(username: profileResult.username) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let avatarResult):
                        print("Avatar loaded")
                    case .failure(let error):
                        preconditionFailure("Avatar loading failed")
                    }
                }
                self.switchToTabBarController()
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                preconditionFailure("Profile loading failed")
            }
        }
        UIBlockingProgressHUD.dismiss()
    }
}
