//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Анна Рыкунова on 18.07.2024.
//

import UIKit
import Kingfisher

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func setProfileInfo(name: String?, login: String, bio: String?)
    func updateAvatar(url: URL?)
}

final class ProfileViewController: UIViewController {
    var presenter: ProfilePresenterProtocol?
    
    // MARK: - Labels
    let nameLabel: UILabel = configLabel(font: UIFont.systemFont(ofSize: 23, weight: .semibold),
                                         color: .ypWhite)
    let loginNameLabel: UILabel = configLabel(font: UIFont.systemFont(ofSize: 13),
                                              color: .ypGrey)
    let descriptionLabel: UILabel = configLabel(font: UIFont.systemFont(ofSize: 13),
                                                color: .ypWhite)
    
    // MARK: - Private Properties
    
    private var profileImageServiceObserver: NSObjectProtocol?
    private let avatarImage: UIImageView = UIImageView()
    private let exitButton: UIButton = UIButton()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar(url: presenter?.avatarURL())
            }
        
        updateAvatar(url: presenter?.avatarURL())
        presenter?.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        let imageButton = UIImage(named: "logout_button")
        exitButton.setImage(imageButton, for: .normal)
        exitButton.addTarget(self, action: #selector(tapLogoutButton), for: UIControl.Event.touchUpInside)
        exitButton.accessibilityIdentifier = "logoutButton"
        
        addAllSubviews()
        addConstraints()
    }
    
    // MARK: - Private functions for config view
    
    private static func configLabel(font: UIFont, color: UIColor) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = font
        label.textColor = color
        return label
    }
    
    private func addAllSubviews() {
        [avatarImage,
         nameLabel,
         loginNameLabel,
         descriptionLabel,
         exitButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            avatarImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatarImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatarImage.widthAnchor.constraint(equalToConstant: 70),
            avatarImage.heightAnchor.constraint(equalTo: avatarImage.widthAnchor, multiplier: 1.0),
            nameLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            loginNameLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: loginNameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: loginNameLabel.trailingAnchor),
            exitButton.widthAnchor.constraint(equalToConstant: 44),
            exitButton.heightAnchor.constraint(equalToConstant: 44),
            exitButton.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor),
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: - Action for logout button
    
    @objc private func tapLogoutButton() {
        let alert = UIAlertController(title: "Пока, пока!",
                                      message: "Уверены что хотите выйти?",
                                      preferredStyle: .alert)
        let yes = UIAlertAction(title: "Да", style: .default) { [self] _ in
            self.presenter?.logout()
            guard let window = UIApplication.shared.windows.first else {
                assertionFailure("Invalid window configuration")
                return
            }
            window.rootViewController = SplashViewController()
            window.makeKeyAndVisible()
        }
        let no = UIAlertAction(title: "Нет", style: .default) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(yes)
        alert.addAction(no)
        yes.accessibilityIdentifier = "yesAlertButton"
        no.accessibilityIdentifier = "noAlertButton"
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - ProfileViewControllerProtocol

extension ProfileViewController: ProfileViewControllerProtocol {
    func setProfileInfo(name: String?, login: String, bio: String?) {
        nameLabel.text = name
        loginNameLabel.text = login
        descriptionLabel.text = bio
    }
    
    func updateAvatar(url: URL?) {
        guard let url else {
            debugPrint("[ProfileViewController updateAvatar] No avatar url")
            return
        }
        let processor = RoundCornerImageProcessor(cornerRadius: 80)
        avatarImage.backgroundColor = .ypBlack
        avatarImage.tintColor = .ypBlack
        avatarImage.kf.indicatorType = IndicatorType.activity
        avatarImage.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholder"),
            options: [
                .processor(processor),
                .cacheSerializer(FormatIndicatedCacheSerializer.png)
            ]
        ) { _ in debugPrint("Avatar installed") }
    }
}
