//
//  ImageListViewTests.swift
//  ImageFeed
//
//  Created by Анна Рыкунова on 21.09.2024.
//

@testable import ImageFeed
import XCTest

final class ImageListViewTests: XCTestCase {
    func testImageListViewControllerCallsFetchNextPhotosOnDidLoad() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as? ImagesListViewController
        else {
            preconditionFailure("Could not instantiate ImagesListViewController")
        }
        let presenterSpy = ImagesListPresenterSpy()
        imagesListViewController.presenter = presenterSpy
        presenterSpy.view = imagesListViewController
        
        _ = imagesListViewController.view
        XCTAssertTrue(presenterSpy.fetchNextPhotosCalled)
    }
    
    func testControllerFetchNetPhotosOnCountOfImages() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as? ImagesListViewController
        else {
            preconditionFailure("Could not instantiate ImagesListViewController")
        }
        let presenterSpy = ImagesListPresenterSpy()
        imagesListViewController.presenter = presenterSpy
        presenterSpy.view = imagesListViewController
        
        let indexPath1 = IndexPath(row: 8, section: 0)
        imagesListViewController.tableView(UITableView(), willDisplay: UITableViewCell(), forRowAt: indexPath1)
        XCTAssertFalse(presenterSpy.fetchNextPhotosCalled)
        
        let indexPath2 = IndexPath(row: 9, section: 0)
        imagesListViewController.tableView(UITableView(), willDisplay: UITableViewCell(), forRowAt: indexPath2)
        XCTAssertTrue(presenterSpy.fetchNextPhotosCalled)
    }
}

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: ImageFeed.ImagesListViewControllerProtocol?
    var fetchNextPhotosCalled: Bool = false
    
    func fetchNextPhotos() {
        fetchNextPhotosCalled = true
    }
    
    func changeImageLikeState(row: Int) {
        
    }
    
    func getCountOfImages() -> Int {
        return 10
    }
    
    func getLargeImageURL(row: Int) -> String {
        return ""
    }
    
    func getSizeOfImage(row: Int) -> CGSize {
        return .zero
    }
    
    func getImageId(row: Int) -> String {
        return ""
    }
    
    func isImageLiked(row: Int) -> Bool {
        return false
    }
    
    func getThumbnailImageURL(row: Int) -> String {
        return ""
    }
    
    func getImageCreatedAt(row: Int) -> Date? {
        return nil
    }
}

