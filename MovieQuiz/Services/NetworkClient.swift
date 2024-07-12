//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Valery Zvonarev on 10.07.2024.
//

import Foundation

struct NetworkClient {
    
    private enum NetworkError: Error {
        case codeError
    }
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        /// создаем запрос из url
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
        /// Check if error received
            if let error = error {
//                print("fetch error")
                handler(.failure(error))
                return
            }
            
            /// check if success response code received
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
                return
            }
            
            /// returning data
            guard let data = data else { return }
            handler(.success(data))
        }
        task.resume()
    }
}
