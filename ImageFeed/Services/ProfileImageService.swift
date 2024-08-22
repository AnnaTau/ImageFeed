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
            task?.cancel()
        }
        
        guard let request = getProfileRequest(username: username)
        else {
            handler(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.data(for: request) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let responseBody = try decoder.decode(UserResult.self, from: data)
                    self.avatarURL = responseBody.profile_image
                    handler(.success(responseBody.profile_image))
                    NotificationCenter.default
                        .post(
                            name: ProfileImageService.didChangeNotification,
                            object: self,
                            userInfo: ["URL": responseBody.profile_image])
                } catch {
                    handler(.failure(DecoderError.decodingError(error)))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
    
    func getProfileRequest(username: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/users/\(username)") else {
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

struct UserResult: Codable {
    let profile_image: String
}
