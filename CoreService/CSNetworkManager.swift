//
//  CSNetwork.swift
//  CoreService
//
//  Created by Hugo Gonzalez on 11/14/16.
//  Copyright © 2016 Cat Bakery. All rights reserved.
//

import Foundation

public enum CSNetworkReturnStatus {
    case success
    case failure
    case nonexistant
}

public enum CSNetworkRestRequest {
    case create
    case read
    case update
    case delete
}

public typealias CSNetworkIdentifier = String
public typealias CSNetwork = [CSNetworkIdentifier: CSNetworkConfig]
public typealias CSNetworkCompletion = (_ returnStatus: CSNetworkReturnStatus) -> Void
public typealias CSRestCompletion = (_ returnStatus: CSNetworkReturnStatus, _ object: CSNetworkObject?) -> Void

open class CSNetworkManager {
    // MARK: - Public Properties
    
    /// Singleton primary instance
    open static let main = CSNetworkManager()
    
    // MARK: - Private Properties
    
    fileprivate var networks: CSNetwork = [:]
    
    // MARK: - Public Functions
    
    open func setupNetwork(networkIdentifier: CSNetworkIdentifier, networkConfig: CSNetworkConfig) {
        networks[networkIdentifier] = networkConfig
    }
    
    open func networkConfig(networkIdentifier: CSNetworkIdentifier) -> CSNetworkConfig? {
        return networks[networkIdentifier]
    }
    
    // REST requests
    open func getObject(networkIdentifier: CSNetworkIdentifier, object: CSNetworkObject, completion: CSRestCompletion) {
        restRequest(requestType: .read, networkIdentifier: networkIdentifier, object: object, parameters: nil, completion: completion)
    }
    
    open func createObject(networkIdentifier: CSNetworkIdentifier, object: CSNetworkObject, parameters: Parameters, completion: CSRestCompletion) {
        restRequest(requestType: .create, networkIdentifier: networkIdentifier, object: object, parameters: parameters, completion: completion)
    }
    
    open func deleteObject(networkIdentifier: CSNetworkIdentifier, object: CSNetworkObject, completion: CSRestCompletion) {
        restRequest(requestType: .delete, networkIdentifier: networkIdentifier, object: object, parameters: nil, completion: completion)
    }
    
    open func updateObject(networkIdentifier: CSNetworkIdentifier, object: CSNetworkObject, parameters: Parameters, completion: CSRestCompletion) {
        restRequest(requestType: .update, networkIdentifier: networkIdentifier, object: object, parameters: parameters, completion: completion)
    }
    
    // Universal Requests
    
    open func postRequest() {
    }
    
    open func getRequest() {
    }
    
    open func downloadRequest() {
    }
    
    // MARK: - Private Functions
    
    fileprivate func restRequest(requestType: CSNetworkRestRequest, networkIdentifier: CSNetworkIdentifier, object: CSNetworkObject, parameters: Parameters?, completion: CSRestCompletion) {
        let networkConfig = networks[networkIdentifier]
        guard networkConfig != nil else {
            completion(.nonexistant, nil)
            return
        }
    }
    
}
