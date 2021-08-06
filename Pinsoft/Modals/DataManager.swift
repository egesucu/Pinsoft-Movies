//
//  DataManager.swift
//  Pinsoft
//
//  Created by Ege Sucu on 4.08.2021.
//

import Foundation

class DataManager {
    
    static let shared = DataManager()
    private let session : URLSession
    
    var baseURL = "https://www.omdbapi.com/"
    let apikey = "apikey=fb538778"
    
    init() {
        
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
        
    }
    
    func getMovieArray(_ string: String, completion: @escaping (Result<MovieList,NetworkError>) -> (Void)) {
        
        let fullUrl = baseURL+"?s=\(string)&\(apikey)"
        
        guard let url = URL(string: fullUrl) else {
            return completion(.failure(.invalidURL))
        }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                return completion(.failure(.invalidURL))
            }
            
            guard let data = data else {
                return completion(.failure(.invalidData))
            }
            
            let decoder = JSONDecoder()
            
            do {
                let data = try decoder.decode(MovieList.self, from: data)
                
                if let error = data.error {
                    self.handleErrors(error: error, completion: completion)
                } else {
                    return completion(.success(data))
                }
            } catch {
                return completion(.failure(.parseError))
            }
        }
        
        task.resume()
    
    }
    
    
    func getMovie(with id: String, completion: @escaping (Result<Movie,NetworkError>) -> (Void)) {
        
        let fullUrl = baseURL+"?i=\(id)&\(apikey)"
        
        guard let url = URL(string: fullUrl) else {
            return completion(.failure(.invalidURL))
        }

        
        let task = session.dataTask(with: url) { (data, response, error) in
            
            if let _ = error {
                return completion(.failure(.invalidURL))
            }
            
            guard let data = data else {
                return completion(.failure(.invalidData))
            }
            
            let decoder = JSONDecoder()
            
            do {
                let data = try decoder.decode(Movie.self, from: data)
                
                if let error = data.error {
                    self.handleErrors(error: error, completion: completion)
                } else {
                    return completion(.success(data))
                }
            } catch{
                return completion(.failure(.parseError))
            }
        }
        task.resume()
    
    }
    
//    Handle known errors that may come from JSON, else print other errors.
    func handleErrors<T>(error: String,completion: @escaping (Result<T,NetworkError>) -> (Void)){
        switch error {
        case FetchError.notFound.rawValue:
            return completion(.failure(.unknownError(FetchError.notFound.rawValue)))
        case FetchError.tooManyResults.rawValue:
            return completion(.failure(.unknownError(FetchError.tooManyResults.rawValue)))
        default:
            return completion(.failure(.unknownError(error)))
        }
        
    }
    
   
    
    
}
