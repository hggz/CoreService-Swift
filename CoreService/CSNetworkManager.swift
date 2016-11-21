//
//  CSNetwork.swift
//  CoreService
//
//  Created by Hugo Gonzalez on 11/14/16.
//  Copyright © 2016 Cat Bakery. All rights reserved.
//

import Foundation

public typealias CSNetwork = [String: CSNetworkConfig]

open class CSNetworkManager {
    // MARK: - Public Properties
    
    /// Singleton primary instance
    open static let main = CSNetworkManager()
    
    // MARK: - Private Properties
    
    fileprivate var networks: CSNetwork = [:]
    
    // MARK: - Public Functions
    
    open func setupNetwork(networkIdentifier: String, networkConfig: CSNetworkConfig) {
        networks[networkIdentifier] = networkConfig
    }
    
    open func networkConfig(networkIdentifier: String) -> CSNetworkConfig? {
        return networks[networkIdentifier]
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
    
    open func downloadRequest() {
    }
}
