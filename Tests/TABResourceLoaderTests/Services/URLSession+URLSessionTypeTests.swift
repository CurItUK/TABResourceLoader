//
//  URLSession+URLSessionTypeTests.swift
//  TABResourceLoaderTests
//
//  Created by Priya Marwaha on 22/12/17.
//  Copyright © 2017 Luciano Marisi. All rights reserved.
//

import XCTest
import TABResourceLoader

class URLSessionTests: XCTestCase {
    
  func testCancelAllRequests() {
    let config = URLSessionConfiguration.default
    let urlSession = URLSession(configuration: config)
    let url = URL(string: "https://www.test.com")!
    let wait = expectation(description: "URLSession cancels request")
    let dataTask = urlSession.dataTask(with: url) { (data, response, error) in
      guard let error = error else {
        XCTFail("Did not receive expected cancellation error")
        return
      }
      if error._code == NSURLErrorCancelled && error._domain == NSURLErrorDomain {
      	wait.fulfill()
      }
    }
    dataTask.resume()
    urlSession.cancelAllRequests()
    waitForExpectations(timeout: 1)
  }
}
