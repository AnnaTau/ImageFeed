//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Анна Рыкунова on 13.08.2024.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.animationType = .circleArcDotSpin
        ProgressHUD.colorAnimation = .ypBlack
        ProgressHUD.animate()
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
