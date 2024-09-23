//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Анна Рыкунова on 20.09.2024.
//

import UIKit

public protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    func fetchNextPhotos()
    func changeImageLikeState(row: Int)
    func getCountOfImages() -> Int
    func getLargeImageURL(row: Int) -> String
    func getSizeOfImage(row: Int) -> CGSize
    func getImageId(row: Int) -> String
    func isImageLiked(row: Int) -> Bool
    func getThumbnailImageURL(row: Int) -> String
    func getImageCreatedAt(row: Int) -> Date?
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    private let imagesListService = ImagesListService.shared
    
    func fetchNextPhotos() {
        imagesListService.fetchPhotosNextPage() { result in
            switch result {
            case .success(_):
                debugPrint("[ImagesListViewController fetchNextPhotos] Next pack of images loaded")
            case .failure(let error):
                debugPrint("[ImagesListViewController fetchNextPhotos] Next pack of images loading failed\n \(error)")
            }
        }
    }
    
    func changeImageLikeState(row: Int) {
        let photo = imagesListService.photos[row]
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { result in
            switch result {
            case .success(let body):
                debugPrint("[ImagesListViewController imageListCellDidTapLike] Like/unlike request done")
                DispatchQueue.main.async {
                    if let index = self.imagesListService.photos.firstIndex(where: { $0.id == body.photo.id }) {
                        self.imagesListService.changeLikeState(for: index)
                        let likeState = self.imagesListService.photos[index].isLiked
                        self.view?.setLikeState(for: index, newState: likeState)
                        UIBlockingProgressHUD.dismiss()
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    debugPrint("[ImagesListViewController imageListCellDidTapLike] Like/unlike request failed\n \(error)")
                    UIBlockingProgressHUD.dismiss()
                }
            }
        }
    }
    
    func getCountOfImages() -> Int {
        imagesListService.photos.count
    }
    
    func getLargeImageURL(row: Int) -> String {
        imagesListService.photos[row].largeImageURL
    }
    
    func getSizeOfImage(row: Int) -> CGSize {
        imagesListService.photos[row].size
    }
    
    func getImageId(row: Int) -> String {
        imagesListService.photos[row].id
    }
    
    func isImageLiked(row: Int) -> Bool {
        imagesListService.photos[row].isLiked
    }
    
    func getThumbnailImageURL(row: Int) -> String {
        imagesListService.photos[row].thumbImageURL
    }
    
    func getImageCreatedAt(row: Int) -> Date? {
        imagesListService.photos[row].createdAt
    }
}
