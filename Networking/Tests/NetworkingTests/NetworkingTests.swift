import XCTest
@testable import Networking

final class NetworkingTests: XCTestCase {
    
    static var allTests = [
        ("testSendRequest_dataIsNotEmpty", testSendRequest_dataIsNotEmpty),
        ("testSendRequest_dataIsEmpty", testSendRequest_dataIsEmpty),
        ("testSendRequest_httpError", testSendRequest_httpError),
        ("testFetchAndDecode_dataIsDecodable", testFetchAndDecode_dataIsDecodable),
        ("testFetchAndDecode_dataIsNotDecodable", testFetchAndDecode_dataIsNotDecodable)
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
    
    func testFetchAndDecode_dataIsDecodable() {
        let request = getRequest(urlString: "URLReturnsSomeData")
        let testData = MockData.mockData
        let httpResponse = HTTPURLResponse(url: request.url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        
        URLProtocolMock.testURLs = [request.url: (httpResponse, testData)]
        
        let exp = expectation(description: "Waiting for async response")
        sut.fetchAndDecode(request: request) { (result: Result<[Article], ServiceError>) in
            switch result {
            case .success(let items):
                XCTAssertEqual(items.count, 3)
            case .failure:
                XCTFail("Expected correct decoding but ran into an error")
            }
            
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 40, handler: nil)
    }
    
    func testFetchAndDecode_dataIsNotDecodable() {
        let request = getRequest(urlString: "URLReturnsSomeData")
        let testData = Data("DataInIncorrectFormat".utf8)
        let httpResponse = HTTPURLResponse(url: request.url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        
        URLProtocolMock.testURLs = [request.url: (httpResponse, testData)]
        
        let exp = expectation(description: "Waiting for async response")
        sut.fetchAndDecode(request: request) { (result: Result<[Article], ServiceError>) in
            switch result {
            case .success:
                XCTFail("Expected an error but instead got a success while decoding data in incorrect format")
            case .failure(let error):
                XCTAssertTrue(error == .dataDecodeError)
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
