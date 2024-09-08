//
//  Photo.swift
//  ImageFeed
//
//  Created by Анна Рыкунова on 05.09.2024.
//

import Foundation

// MARK: - UI Model
struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

// MARK: - Data Model
struct PhotoResult: Codable {
    let id: String
    let createdAt: String
    let description: String?
    let altDescription: String?
    let likedByUser: Bool
    let width: Int
    let height: Int
    let urls: UrlsResult
}

struct UrlsResult: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
