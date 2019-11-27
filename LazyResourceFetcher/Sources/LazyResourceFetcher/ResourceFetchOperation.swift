//
//  ResourceFetchOperation.swift
//  
//
//  Created by Kunal Shrivastava on 11/26/19.
//

import Foundation
import Networking

class ResourceFetchOperation: AsynchronousOperation {
    private let networker: Networker
    private let resourceURL: URL
    private let completionHandler: (Data) -> Void
    
    init(networker: Networker = Networker(),
         resourceURL: URL,
         completionHandler: @escaping (Data) -> Void) {
        self.networker = networker
        self.resourceURL = resourceURL
        self.completionHandler = completionHandler
    }
    
    override func main() {
        let request = HTTPRequest(url: resourceURL)
        networker.send(request: request) { [unowned self] (result) in
            switch result {
            case .success(let data):
                self.finish()
                self.completionHandler(data)
            case .failure:
                self.cancel()
            }
        }
    }
}
