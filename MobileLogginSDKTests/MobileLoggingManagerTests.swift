//
//  MobileLoggingManagerTests.swift
//  MobileLogginSDKTests
//
//  Created by Inna Chystiakova on 08/09/2024.
//

import XCTest
@testable import MobileLogginSDK

final class MobileLoggingManagerTests: XCTestCase {
    
    // MARK: - Mocks
    class MockRequestFactory: RequestFactory {
        var mockRequest: PostRequest?
        var mockError: HTTPClientError?

        func createPostRequest(with body: [PostRequestKeys: String]) -> (request: Requestable?, error: HTTPClientError?) {
            return (mockRequest, mockError)
        }
    }
    
    class MockHTTPClient: HTTPClient {
        var mockResult: HTTPClientResult = .success
        
        func post(with url: URLRequest, completion: @escaping (MobileLogginSDK.HTTPClientResult) -> Void) {
            completion(mockResult)
        }
    }
    
    // MARK: -Tests
    func testPostSuccess() {
        let mockURL = URL(string: "https://mockurl.com")!
        let body = try! JSONHelper.encodeToJSON([PostRequestKeys.myString: "Test message"])
        let mockRequest = PostRequest(with: mockURL, body: body)
        let mockClient = MockHTTPClient()
        
        let mockRequestFactory = MockRequestFactory()
        mockRequestFactory.mockRequest = mockRequest
        
        let manager = MobileLoggingManager(requestFactory: mockRequestFactory, httpClient: mockClient)
        
        let expectation = self.expectation(description: "Completion handler invoked")
        
        manager.post(body: [.myString: "Test message"]) { result in
            switch result {
            case .success:
                XCTAssertTrue(true)
            case .failure(let error):
                XCTFail("Expected success but got failure with error: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testPostRequestCreationFailure() {
        let mockRequestFactory = MockRequestFactory()
        mockRequestFactory.mockError = .invalidJSONEncode
        
        let manager = MobileLoggingManager(requestFactory: mockRequestFactory)
        
        let expectation = self.expectation(description: "Completion handler invoked")
        
        manager.post(body: [.myString: "Test message"]) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error, HTTPClientError.invalidJSONEncode.getErrorDescription())
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testPostRequestFailure() {
        let mockRequestFactory = MockRequestFactory()
        mockRequestFactory.mockError = .invalidResponse
        
        let manager = MobileLoggingManager(requestFactory: mockRequestFactory)
                
        let expectation = self.expectation(description: "Completion handler invoked")
        
        manager.post(body: [.myString: "Test message"]) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error, HTTPClientError.invalidResponse.getErrorDescription())
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testPostMessageIfValidSuccess() {
        let mockURL = URL(string: "https://mockurl.com")!
        let body = try! JSONHelper.encodeToJSON([PostRequestKeys.myString: "Valid message"])
        let mockRequest = PostRequest(with: mockURL, body: body)
        let mockClient = MockHTTPClient()

        let mockRequestFactory = MockRequestFactory()
        mockRequestFactory.mockRequest = mockRequest
        
        let manager = MobileLoggingManager(requestFactory: mockRequestFactory, httpClient: mockClient)
                
        let expectation = self.expectation(description: "Completion handler invoked")
        
        manager.postMessageOfValidLength(string: "Valid message", completion: { result in
            switch result {
            case .success:
                XCTAssertTrue(true)
            case .failure(let error):
                XCTFail("Expected success but got failure with error: \(error)")
            }
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testPostMessageIfValidFailureDueToLength() {
        let manager = MobileLoggingManager()
        
        let expectation = self.expectation(description: "Completion handler invoked")
        
        manager.postMessageOfValidLength(string: "", minLen: 1, maxLen: 1000) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error, HTTPClientError.invalidMessageLength.getErrorDescription())
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testPostMessageIfValidFormatSuccess() {
        let mockURL = URL(string: "https://mockurl.com")!
        let body = try! JSONHelper.encodeToJSON([PostRequestKeys.myString: "Valid message"])
        let mockRequest = PostRequest(with: mockURL, body: body)
        let mockClient = MockHTTPClient()
        
        let mockRequestFactory = MockRequestFactory()
        mockRequestFactory.mockRequest = mockRequest
        
        let manager = MobileLoggingManager(requestFactory: mockRequestFactory, httpClient: mockClient)
        
        let expectation = self.expectation(description: "Completion handler invoked")
        
        manager.postMessageIfValidFormat(string: "Valid message", regex: ".*") { result in
            switch result {
            case .success:
                XCTAssertTrue(true)
            case .failure(let error):
                XCTFail("Expected success but got failure with error: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testPostMessageIfValidFormatFailure() {
        let manager = MobileLoggingManager()
        
        let expectation = self.expectation(description: "Completion handler invoked")
        
        manager.postMessageIfValidFormat(string: "Invalid message", regex: "^\\d+$") { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error, HTTPClientError.invalidMessageFormat.getErrorDescription())
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testGeneratePostRequestCurlCommandSuccess() {
        let mockURL = URL(string: "https://mockurl.com")!
        let body = try! JSONHelper.encodeToJSON([PostRequestKeys.myString: "Test message"])
        let mockRequest = PostRequest(with: mockURL, body: body)
        
        let mockRequestFactory = MockRequestFactory()
        mockRequestFactory.mockRequest = mockRequest
        
        let manager = MobileLoggingManager(requestFactory: mockRequestFactory)
        
        let expectation = self.expectation(description: "Completion handler invoked")
        
        manager.generatePostRequestCurlCommand(for: "Test message") { result in
            switch result {
            case .success(let curlCommand):
                XCTAssertEqual(curlCommand, "curl --location 'https://mockurl.com'\\ --header 'Content-Type: application/json'\\ --data '{\"myString\":\"Test message\"}'")
            case .failure(let error):
                XCTFail("Expected success but got failure with error: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testGeneratePostRequestCurlCommandFailure() {
        let mockRequestFactory = MockRequestFactory()
        mockRequestFactory.mockError = .invalidJSONEncode
        
        let manager = MobileLoggingManager(requestFactory: mockRequestFactory)
        
        let expectation = self.expectation(description: "Completion handler invoked")
        
        manager.generatePostRequestCurlCommand(for: "Test message") { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error, HTTPClientError.invalidJSONEncode.getErrorDescription())
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testConvertDictionarySuccess() {
        let manager = MobileLoggingManager()
        let dictionary = ["myString": "Test message"]
        
        let converted = manager.convert(dictionary: dictionary)
        
        XCTAssertEqual(converted[.myString], "Test message")
    }
    
    func testConvertDictionaryWithInvalidKey() {
        let manager = MobileLoggingManager()
        let dictionary = ["invalidKey": "Test message"]
        
        let converted = manager.convert(dictionary: dictionary)
        
        XCTAssertTrue(converted.isEmpty)
    }
}
