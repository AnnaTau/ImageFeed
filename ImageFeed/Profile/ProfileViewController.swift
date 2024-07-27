//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Анна Рыкунова on 18.07.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    // MARK: - Private Properties
    private let avatarImage: UIImageView = UIImageView()
    private let exitButton: UIButton = UIButton()
    private let nameLabel: UILabel = configLabel(text: "Екатерина Новикова",
                                         font: UIFont.systemFont(ofSize: 23, weight: .semibold),
                                         color: UIColor.ypWhite)
    private let loginNameLabel: UILabel = configLabel(text: "@ekaterina_nov",
                                              font: UIFont.systemFont(ofSize: 13),
                                              color: UIColor.ypGrey)
    private let descriptionLabel: UILabel = configLabel(text: "Hello, World!",
                                                font: UIFont.systemFont(ofSize: 13),
                                                color: UIColor.ypWhite)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        let imageAvatar = UIImage(named: "avatar")
        avatarImage.image = imageAvatar
        
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        let imageButton = UIImage(named: "logout_button")
        exitButton.setImage(imageButton, for: .normal)
        
        addAllSubviews()
        
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
    
    // MARK: - Private functions
    private static func configLabel(text: String, font: UIFont, color: UIColor) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = font
        label.textColor = color
        return label
    }
    
    private func addAllSubviews() {
        view.addSubview(avatarImage)
        view.addSubview(nameLabel)
        view.addSubview(loginNameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(exitButton)
    }
}
