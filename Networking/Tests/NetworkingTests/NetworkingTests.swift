import XCTest
@testable import Networking

final class NetworkingTests: XCTestCase {
    
    static var allTests = [
        ("testSendRequest_dataIsNotEmpty", testSendRequest_dataIsNotEmpty),
        ("testSendRequest_dataIsEmpty", testSendRequest_dataIsEmpty),
        ("testSendRequest_httpError", testSendRequest_httpError)
    ]
    
    var sut: Networker!
    override func setUp() {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        
        sut = Networker()
        sut.urlSession = URLSession(configuration: config)
    }
    
    func testSendRequest_dataIsNotEmpty() {
        let request = getRequest(urlString: "URLReturnsSomeData")
        let testData = Data("TestData".utf8)
        let httpResponse = HTTPURLResponse(url: request.url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        
        URLProtocolMock.testURLs = [request.url: (httpResponse, testData)]
        
        let exp = expectation(description: "Waiting for async response")
        sut.send(request: request) { (result) in
            switch result {
            case .success(let receivedData):
                XCTAssertTrue(receivedData == testData)
            case .failure:
                XCTFail("Expected valid data but instead got an error")
            }
            
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testSendRequest_dataIsEmpty() {
        let request = getRequest(urlString: "URLReturnsSomeData")
        let testData = Data("".utf8)
        let httpResponse = HTTPURLResponse(url: request.url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        
        URLProtocolMock.testURLs = [request.url: (httpResponse, testData)]
        
        let exp = expectation(description: "Waiting for async response")
        sut.send(request: request) { (result) in
            switch result {
            case .success:
                XCTFail("Expected noData error but instead got success response")
            case .failure(let error):
                XCTAssertTrue(error == .noData)
            }
            
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 40, handler: nil)
    }
    
    func testSendRequest_httpError() {
        let request = getRequest(urlString: "URLReturnsSomeData")
        let testData = Data("".utf8)
        let httpResponse = HTTPURLResponse(url: request.url, statusCode: 100, httpVersion: nil, headerFields: nil)!
        
        URLProtocolMock.testURLs = [request.url: (httpResponse, testData)]
        
        let exp = expectation(description: "Waiting for async response")
        sut.send(request: request) { (result) in
            switch result {
            case .success:
                XCTFail("Expected noData error but instead got success response")
            case .failure(let error):
                XCTAssertTrue(error == .invalidResponse)
            }
            
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 40, handler: nil)
    }
    
    func getRequest(urlString: String) -> HTTPRequest {
        let url = URL(string: urlString)!
        return HTTPRequest(url: url)
    }
}
