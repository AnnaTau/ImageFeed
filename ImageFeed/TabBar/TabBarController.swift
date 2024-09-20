//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Анна Рыкунова on 30.08.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as? ImagesListViewController
        else {
            preconditionFailure("Could not instantiate ImagesListViewController")
        }
        
        let imagesListPresenter = ImagesListPresenter()
        imagesListPresenter.view = imagesListViewController
        imagesListViewController.presenter = imagesListPresenter
        
        let profileViewController = ProfileViewController()
        let profilePresenter = ProfilePresenter()
        profilePresenter.view = profileViewController
        profileViewController.presenter = profilePresenter
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil
        )
        self.viewControllers = [imagesListViewController, profileViewController]
    }
    
}
