//
//  CSNetwork.swift
//  CoreService
//
//  Created by Hugo Gonzalez on 11/14/16.
//  Copyright © 2016 Cat Bakery. All rights reserved.
//

import Foundation

open class CSNetwork {
    // MARK: - Public Properties
    
    /// Singleton primary instance
    open static let main = CSNetwork()
    
    /// Base url endpoint for all requests. Read-Only.
    open var baseURL: String {
        return baseURLString
    }
    
    // MARK: - Private Properties
    
    fileprivate var baseURLString = ""
    
    // MARK: - Public Functions
    
    open func setupNetwork(urlString: String, port: String = "80") {
        baseURLString = urlString
    }
    
    // REST requests
    open func getObject() {
    }
    
    open func createObject() {
    }
    
    open func deleteObject() {
    }
    
    open func updateObject() {
    }
    
    // Universal Requests
    
    open func postRequest() {
    }
    
    open func getRequest() {
    }
}
