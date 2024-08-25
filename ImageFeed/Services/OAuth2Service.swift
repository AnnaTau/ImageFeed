//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Анна Рыкунова on 05.08.2024.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private init() {}
    
    func fetchOAuthToken(code: String, completion: @escaping(_ result: Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil {
            if lastCode != code {
                task?.cancel()
            } else {
                print("Invalid request")
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        } else {
            if lastCode == code {
                print("Invalid request")
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        }
        
        lastCode = code
        guard let request = getTokenURLRequest(code: code)
        else {
            print("Invalid request")
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self else { return }
            switch result {
            case .success(let body):
                completion(.success(body.accessToken))
            case .failure(let error):
                print("Invalid request/n \(error)")
                completion(.failure(error))
            }
            self.task = nil
            self.lastCode = nil
        }
        self.task = task
        task.resume()
    }
    
    private func getTokenURLRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: Constants.Token.baseURLString)
        else {
            print("baseURLString is nil")
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.API.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.API.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.API.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: Constants.Token.grantType)
        ]
        guard let url = urlComponents.url 
        else {
            print("url is nil")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
}

enum DecoderError: Error, LocalizedError {
    case decodingError(Error)
    
    var errorDescription: String? {
        switch self {
        case .decodingError(let error):
            return "Decoding error - \(error)"
        }
    }
}

enum AuthServiceError: Error {
    case invalidRequest
}
