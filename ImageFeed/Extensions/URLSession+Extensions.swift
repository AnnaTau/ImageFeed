//
//  URLSession+Extensions.swift
//  ImageFeed
//
//  Created by Анна Рыкунова on 05.08.2024.
//

import UIKit

enum NetworkError: Error, LocalizedError {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    
    var errorDescription: String? {
        switch self {
        case .httpStatusCode(let code):
            return "HTTP Status Code Error - code \(code)"
        case .urlRequestError(let error):
            return "Request Error - \(error.localizedDescription)"
        case .urlSessionError:
            return "URL Session Error"
        }
    }
}

extension URLSession {
    func data(for request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request) { data, response, error in
            if
                let data = data,
                let response = response,
                let statusCode = (response as? HTTPURLResponse)?.statusCode
            {
                if 200..<300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data))
                } else {
                    debugPrint("[URLSession data] Request failed with statusCode \(statusCode)")
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                debugPrint("[URLSession data] Request failed with error\n \(error)")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                debugPrint("[URLSession data] Request failed with error\n \(String(describing: error))")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        }
        return task
    }
    
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        let task = data(for: request) { (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let responseBody = try decoder.decode(T.self, from: data)
                    completion(.success(responseBody))
                } catch {
                    debugPrint("""
                        [URLSession objectTask] 
                        Ошибка декодирования: \(error.localizedDescription),
                        Данные: \(String(data: data, encoding: .utf8) ?? "")
                    """)
                    completion(.failure(DecoderError.decodingError(error)))
                }
            case .failure(let error):
                debugPrint("[URLSession objectTask] Request failed with error\n \(String(describing: error))")
                completion(.failure(error))
            }
        }
        return task
    }
}
