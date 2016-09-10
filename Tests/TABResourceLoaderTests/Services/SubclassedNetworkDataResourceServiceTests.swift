//
//  SubclassedNetworkDataResourceServiceTests.swift
//  TABResourceLoaderTests
//
//  Created by Luciano Marisi on 10/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import XCTest
@testable import TABResourceLoader

private let commonKey = "common"

final class SubclassedNetworkDataResourceService<Resource: NetworkResourceType & DataResourceType: NetworkDataResourceService<Resource> {

  // Needed because of https://bugs.swift.org/browse/SR-416
  required init() {
    super.init()
  }

  override init(session: URLSessionType) {
    super.init(session: session)
  }

  override func additionalHeaderFields() -> [String: String] {
    return [commonKey: "subclass"]
  }
}


class SubclassedNetworkJSONResourceServiceTests: XCTestCase {

  var testService: SubclassedNetworkDataResourceService
  
  var mockSession: MockURLSession!
  var mockResource: MockNetworkJSONResource!
  let mockURL = URL(string: "http://test.com")!

  override func setUp() {
    super.setUp()
    mockSession = MockURLSession()
    testService = SubclassedNetworkDataResourceService(session: mockSession)
  }

  func test_subclassHTTPHeaderFields_areOverridenByResourceHTTPHeaderFields() {
    let resourceHTTPHeaderFields = [commonKey: "resource"]
    mockResource = MockNetworkJSONResource(url: mockURL, HTTPHeaderFields: resourceHTTPHeaderFields)
    testService.fetch(resource: mockResource) { _ in }
    XCTAssertEqual(mockSession.capturedRequest!.allHTTPHeaderFields!, resourceHTTPHeaderFields)
  }

  func test_finalRequestInclude_subclassHTTPHeaderFields_and_resourceHTTPHeaderFields() {
    let resourceHTTPHeaderFields = ["resource_key" : "resource"]
    mockResource = MockNetworkJSONResource(url: mockURL, HTTPHeaderFields: resourceHTTPHeaderFields)
    testService.fetch(resource: mockResource) { _ in }
    let expectedHeaderFields = [commonKey: "subclass", "resource_key" : "resource"]
    XCTAssertEqual(mockSession.capturedRequest!.allHTTPHeaderFields!, expectedHeaderFields)
  }

}

