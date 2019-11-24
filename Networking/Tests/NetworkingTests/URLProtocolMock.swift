//
//  URLProtocolMock.swift
//  
//
//  Created by Kunal Shrivastava on 11/23/19.
//

import Foundation

class URLProtocolMock: URLProtocol {
    static var testURLs = [URL?: (HTTPURLResponse, Data)]()

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let url = request.url {
            if let testData = URLProtocolMock.testURLs[url] {
                
                client?.urlProtocol(self, didReceive: testData.0, cacheStoragePolicy: .notAllowed)
                self.client?.urlProtocol(self, didLoad: testData.1)
            }
        }

        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() { }
}
