//
//  NetworkService.swift
//  ToDoListApp
//
//  Created by Evan Brother on 03.02.2026.
//

import Foundation

final class NetworkService {
    
    // MARK: - Singleton
    static let shared = NetworkService()
    
    // MARK: - Properties
    private let session: URLSession
    private let decoder: JSONDecoder
    
    private let backgroundQueue = DispatchQueue(
        label: "com.example.evanbtlr.apps.todolistapp.network",
        qos: .background,
        attributes: .concurrent
    )
    
    // MARK: - Initialization
    init(session: URLSession? = nil) {
        let configuration = URLSessionConfiguration.default
        
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        configuration.waitsForConnectivity = true
        configuration.allowsCellularAccess = true
        
        self.session = session ?? URLSession(configuration: configuration)
        
        self.decoder = JSONDecoder()
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    // MARK: - Public Method (ТОЛЬКО ОДИН!)
    func fetchInitialTodoItems(completion: @escaping (Result<[LightTodoItem], Error>) -> Void) {
        self.backgroundQueue.async { [weak self] in
            guard let self = self else { return }
            
            guard let url = URL(string: "https://dummyjson.com/todos") else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.invalidURL))
                }
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.timeoutInterval = 30
            
            let task = self.session.dataTask(with: request) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        let nsError = error as NSError
                        
                        switch nsError.code {
                        case NSURLErrorNotConnectedToInternet:
                            completion(.failure(NetworkError.noInternetConnection))
                        case NSURLErrorTimedOut:
                            completion(.failure(NetworkError.timeout))
                        default:
                            completion(.failure(NetworkError.requestFailed(error)))
                        }
                        
                    }
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.invalidResponse))
                    }
                    return
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.statusCode(httpResponse.statusCode)))
                    }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.noData))
                    }
                    return
                }
                
                do {
                    let response = try self.decoder.decode(TodoResponse.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(.success(response.tasks))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.decodingFailed(error)))
                    }
                }
            }
            
            task.resume()
        }
    }
}

// MARK: - Network Errors
enum NetworkError: LocalizedError {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case statusCode(Int)
    case decodingFailed(Error)
    case noInternetConnection
    case timeout
    case noData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return String(localized: .errorNetworkInvalidUrl)
        case .requestFailed(let error):
            return "\(String(localized: .errorNetworkRequestFailed)): \(error.localizedDescription)"
        case .invalidResponse:
            return String(localized: .errorNetworkInvalidResponse)
        case .statusCode(let code):
            return "\(String(localized: .errorNetworkServer)): \(code)"
        case .decodingFailed(let error):
            return "\(String(localized: .errorNetworkDecodeFailed)): \(error.localizedDescription)"
        case .noInternetConnection:
            return String(localized: .errorNetworkConnection)
        case .timeout:
            return String(localized: .errorNetworkTimeout)
        case .noData:
            return String(localized: .errorNetworkData)
        }
    }
}
