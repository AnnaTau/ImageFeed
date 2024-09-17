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
    
    private let logoImage: UIImageView = UIImageView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        view.backgroundColor = .ypBlack
        
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        let imageLogo = UIImage(named: "splash_screen_logo")
        logoImage.image = imageLogo
        
        view.addSubview(logoImage)
        
        NSLayoutConstraint.activate([
            logoImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            logoImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            logoImage.widthAnchor.constraint(equalToConstant: 75),
            logoImage.heightAnchor.constraint(equalToConstant: 77)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let token = oAuth2Storage.token {
            debugPrint(token)
            fetchProfile(token)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            guard
                let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController
            else {
                assertionFailure("Failed init AuthViewController")
                return
            }
            authViewController.delegate = self
            authViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            present(authViewController, animated: true, completion: nil)
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
        
        let options: UIView.AnimationOptions = .transitionCrossDissolve
        let duration: TimeInterval = 0.3
        UIView.transition(with: window, duration: duration, options: options, animations: {}, completion: nil)
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
        UIBlockingProgressHUD.dismiss()
    }
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile { result in
            switch result {
            case .success(let profileResult):
                debugPrint("[SplashViewController fetchProfile] Start loading avatar")
                ProfileImageService.shared.fetchProfileImageURL(username: profileResult.username) { result in
                    switch result {
                    case .success(_):
                        debugPrint("[SplashViewController fetchProfile] Avatar loaded")
                    case .failure(let error):
                        debugPrint("[SplashViewController fetchProfile] Avatar loading failed\n \(error)")
                    }
                }
                self.switchToTabBarController()
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                debugPrint("[SplashViewController fetchProfile] Profile loading failed\n \(error)")
                let alert = UIAlertController(title: "Что-то пошло не так",
                                              message: "Попробовать ещё раз?",
                                              preferredStyle: .alert)
                let action = UIAlertAction(title: "Не надо", style: .default) { _ in
                    alert.dismiss(animated: true)
                }
                let reload = UIAlertAction(title: "Повторить", style: .default) { [self] _ in
                    self.fetchProfile(token)
                }
                alert.addAction(action)
                alert.addAction(reload)
                self.present(alert, animated: true, completion: nil)
            }
        }
        UIBlockingProgressHUD.dismiss()
    }
}
