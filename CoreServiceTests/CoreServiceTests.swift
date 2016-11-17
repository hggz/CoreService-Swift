//
//  CoreServiceTests.swift
//  CoreServiceTests
//
//  Created by hugogonzalez on 11/12/16.
//  Copyright © 2016 Cat Bakery. All rights reserved.
//

import XCTest
@testable import CoreService

class TestModel: CSNetworkObject {
    var numberOfMemes: Int = 69
    
    override var path: String {
        get { return "meme" }
        set { super.path = newValue }
    }
}

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
    
    func testReflection() {
        let objc = TestModel()
        let refl = Mirror(reflecting: objc)
        let superclassMirror = refl.superclassMirror!
        print ("Number of super children: \(superclassMirror.children.count)")
        for child in superclassMirror.children {
            print ("Property: '\(child.label!)' Value: '\(child.value)'")
//            objc.setValue("2pac", forKey: child.label!)
            objc.setValuesForKeys([child.label!: "2pac"])
        }
        
        print ("Number of children: \(refl.children.count)")
        for child in refl.children {
            print ("Property: '\(child.label!)' Value: '\(child.value)'")
        }
        
        print ("Resource path: \(objc.resourcePath())")
        XCTAssert(objc.resourceID == "2pac")
    }
    
}
