//
//  Networking.swift
//
//
//  Created by Kunal Shrivastava on 11/23/19.
//

import Foundation

protocol Networkable {
    associatedtype T: Request
    var urlSession: URLSession { get set }
    func send(request: T,
              completionHandler: @escaping (Result<Data, ServiceError>) -> Void)
    func fetchAndDecode<U: Decodable>(request: T,
    completionHandler: @escaping (Result<U, ServiceError>) -> Void)
}

public class Networker: Networkable {
    internal var urlSession: URLSession = .shared
    
    /**
     This initializer is intentionally left blank because default init of Struct is by default internal and hence has to be made explicitely public if the consumer of the module requires its usage
     */
    public init() {}
    
    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    /**
    Sends out an HTTP request

    - Parameter request: The request that encapsulates details required to perform the http operation
    - Parameter completionHandler: A closure that the caller injects to handle the response of the HTTP request
    */
    public func send(request: HTTPRequest,
              completionHandler: @escaping (Result<Data, ServiceError>) -> Void) {
        
        let urlRequest = URLRequest(request)
        
        urlSession.dataTask(with: urlRequest) { (data, response, error) in
            guard let httpResponseCode = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(httpResponseCode) else {
                completionHandler(.failure(.invalidResponse))
                
                return
            }
            
            if let error = error {
                completionHandler(.failure(.error(error)))
            } else if let data = data {
                guard data.isEmpty == false else {
                    return completionHandler(.failure(.noData))
                }
                
                completionHandler(.success(data))
            }
        }.resume()
    }
    
    public func fetchAndDecode<U: Decodable>(request: HTTPRequest,
                                             completionHandler: @escaping (Result<U, ServiceError>) -> Void) {
        send(request: request) { (result) in
            switch result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let decodedData = try jsonDecoder.decode(U.self, from: data)
                    completionHandler(.success(decodedData))
                } catch {
                    completionHandler(.failure(.dataDecodeError))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
