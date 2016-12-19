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

/// *NOTE* BE SURE TO NAME YOUR NETWORK TASKS IN THE PROPER ORDER YOU WANT THEM EXECUTED. IE: test1, test2, test3
class CoreServiceTests: XCTestCase {
    
    let testURLString = "https://meme.com"
    var networkConfig: CSNetworkConfig?
    var networkIdentifier: CSNetworkIdentifier?
    
    var testTimestamp: String?
    var testUserName: String?
    var testUserFirstName: String?
    var testUserLastName: String?
    var testUserEmail: String?
    var testUserPassword: String?
    
    override func setUp() {
        super.setUp()
        testTimestamp = currentTimestampId()
        testUserName = "test\(testTimestamp!)"
        testUserEmail = "test\(testTimestamp!)@test.com"
        testUserFirstName = "first_test\(testTimestamp!)"
        testUserLastName = "last_test\(testTimestamp!)"
        testUserPassword = "test\(testTimestamp)"
        
        let headers: CSNetworkHeader = [.ContentType: "application/json"]
        networkIdentifier = "belle"
        networkConfig = CSNetworkConfig(headers: headers,
                                                 port: "80",
                                                 baseUrl: "http://ec2-54-68-223-236.us-west-2.compute.amazonaws.com",
                                                 clientId: "RaetH7k4116wem7MHrUCOXDcL5yxdTMTpWvcZc90")
        CSNetworkManager.main.setupNetwork(networkIdentifier: networkIdentifier!, networkConfig: networkConfig!)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
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
    
    func currentTimestampId() -> String {
        let now = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year, .hour, .minute, .second], from: now)
        let nsstring = NSString(format: "%02d%02d%02d%02d%02d%02d" , components.year!, components.month!, components.day!, components.hour!, components.minute!, components.second!)
        return nsstring as String
    }
    
    // MARK: - Registration
    func testServer1() {
        let path = pathForNetworkConfig(config: networkConfig!, path: "api/registration/")
        print ("making request to: \(path)")
        
        let parameters: Parameters = ["username": testUserName!,
                          "email": testUserEmail!,
                          "first_name": testUserFirstName!,
                          "password": testUserPassword!,
                          "last_name": testUserLastName!]
        let exp = expectation(description: #function)
        CSNetworkManager.main.postRequest(networkIdentifier: networkIdentifier!, path: path, parameters: parameters, completion: { (returnStatus, responseObject, error) in
            if returnStatus == .success {
                dump(responseObject)
                XCTAssert(true)
            } else {
                dump(responseObject)
                XCTAssert(false)
            }
            exp.fulfill()
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    // MARK: - Login
    func testServer2() {
        let path = pathForNetworkConfig(config: networkConfig!, path: "auth/login/")
        print ("making request to: \(path)")
        
        let parameters: Parameters = ["username": testUserName!,
                                      "password": testUserPassword!]
        let exp = expectation(description: #function)
        CSNetworkManager.main.postRequest(networkIdentifier: networkIdentifier!, path: path, parameters: parameters, completion: { (returnStatus, responseObject, error) in
            if returnStatus == .success {
                dump(responseObject)
                XCTAssert(true)
            } else {
                dump(responseObject)
                XCTAssert(false)
            }
            exp.fulfill()
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
}
