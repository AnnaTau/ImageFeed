//
//  ImagesListCellDelegate.swift
//  ImageFeed
//
//  Created by Анна Рыкунова on 12.09.2024.
//

import Foundation

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
