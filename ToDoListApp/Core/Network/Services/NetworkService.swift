//
//  NetworkService.swift
//  ToDoListApp
//
//  Created by Evan Brother on 03.02.2026.
//

internal import Foundation

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
    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
        
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    // MARK: - Public Method (ТОЛЬКО ОДИН!)
    func fetchInitialTodoItems(completion: @escaping (Result<[LightTodoItem], Error>) -> Void) {
        self.backgroundQueue.async { [weak self] in
            guard let self = self else { return }
            
            guard let url = URL(string: "https://dummyjson.com/todos") else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "Network", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
                }
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.timeoutInterval = 30
            
            let task = self.session.dataTask(with: request) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    DispatchQueue.main.async {
                        completion(.failure(NSError(domain: "Network", code: -2, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                    }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(.failure(NSError(domain: "Network", code: -3, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
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
                        completion(.failure(error))
                    }
                }
            }
            
            task.resume()
        }
    }
}

