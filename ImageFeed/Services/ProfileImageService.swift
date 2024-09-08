//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Анна Рыкунова on 20.08.2024.
//

import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    private let oAuth2Storage = OAuth2TokenStorageService.shared
    private (set) var avatarURL: String?
    private var task: URLSessionTask?
    
    private init() {}
    
    func fetchProfileImageURL(username: String, _ handler: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil {
            return
        }
        
        guard let request = getProfileRequest(username: username)
        else {
            debugPrint("[ProfileImageService fetchProfileImageURL] Invalid request")
            handler(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self else { return }
            switch result {
            case .success(let body):
                self.avatarURL = body.profileImage.large
                handler(.success(body.profileImage.large))
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": body.profileImage])
            case .failure(let error):
                debugPrint("[ProfileImageService fetchProfileImageURL] Invalid request/n \(error)")
                handler(.failure(error))
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    func getProfileRequest(username: String) -> URLRequest? {
        guard let url = URL(string: "\(Constants.Profile.usersURLString)\(username)") else {
            preconditionFailure("Unable to construct profile request")
        }
        var request = URLRequest(url: url)
        guard let token = oAuth2Storage.token else {
            preconditionFailure("Token is nil")
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
