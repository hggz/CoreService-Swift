//
//  CoreServiceTests.swift
//  CoreServiceTests
//
//  Created by hugogonzalez on 11/12/16.
//  Copyright © 2016 Cat Bakery. All rights reserved.
//

import XCTest
@testable import CoreService

class CoreServiceTests: XCTestCase {
    
    let testURLString = "https://meme.com"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        XCTAssert(CSNetwork.main.baseURL == "")
        CSNetwork.main.setupNetwork(urlString: testURLString)
        XCTAssert(CSNetwork.main.baseURL == testURLString)
    }
    
}
