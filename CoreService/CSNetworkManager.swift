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
    case invalid
    case nonexistant
}

fileprivate enum CSNetworkRestRequest {
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
    open func getObject(networkIdentifier: CSNetworkIdentifier, object: CSNetworkObject, completion: @escaping CSRestCompletion) throws {
        try restRequest(requestType: .read, networkIdentifier: networkIdentifier, object: object, parameters: nil, completion: completion)
    }
    
    open func createObject(networkIdentifier: CSNetworkIdentifier, object: CSNetworkObject, parameters: Parameters, completion: @escaping CSRestCompletion) throws {
        try restRequest(requestType: .create, networkIdentifier: networkIdentifier, object: object, parameters: parameters, completion: completion)
    }
    
    open func deleteObject(networkIdentifier: CSNetworkIdentifier, object: CSNetworkObject, completion: @escaping CSRestCompletion) throws {
        try restRequest(requestType: .delete, networkIdentifier: networkIdentifier, object: object, parameters: nil, completion: completion)
    }
    
    open func updateObject(networkIdentifier: CSNetworkIdentifier, object: CSNetworkObject, parameters: Parameters, completion: @escaping CSRestCompletion) throws {
        try restRequest(requestType: .update, networkIdentifier: networkIdentifier, object: object, parameters: parameters, completion: completion)
    }
    
    // Universal Requests
    
    open func postRequest() {
    }
    
    open func getRequest() {
    }
    
    open func downloadRequest() {
    }
    
    // MARK: - Private Functions
    
    fileprivate func restRequest(requestType: CSNetworkRestRequest, networkIdentifier: CSNetworkIdentifier, object: CSNetworkObject, parameters: Parameters?, completion: @escaping CSRestCompletion) throws {
        // check config
        let config = networkConfig(networkIdentifier: networkIdentifier)
        guard config != nil else { 
            completion(.nonexistant, nil)
            return
        }
        
        // setup request
        let request = try restUrlRequest(type: requestType, config: config!, object: object, parameters: parameters)
        guard request != nil else { 
            completion(.invalid, nil)
            return
        }
        
        // setup adapter and retrier
        let refresher = CSOAuthRefresher(request: request!)
        
        // perform request
        let sessionManager = SessionManager()
        sessionManager.adapter = refresher
        sessionManager.retrier = refresher
        sessionManager.request(request!).validate().response { (DefaultDataResponse) in
            completion(.success, object) // should be new object. not current object
        }
    }
    
    fileprivate func restUrlRequest(type: CSNetworkRestRequest, config: CSNetworkConfig, object: CSNetworkObject, parameters: Parameters?) throws -> URLRequest? {
        if parameters != nil {
            switch type {
            case .create:
                return try CSRestRouter.createNetworkObject(networkConfig: config, networkObject: object, parameters: parameters!).asURLRequest()
            case .update:
                return try CSRestRouter.updateNetworkObject(networkConfig: config, networkObject: object, parameters: parameters!).asURLRequest()
            default:
                return nil
            }
        } else { 
            switch type {
            case .read:
                return try CSRestRouter.readNetworkObject(networkConfig: config, networkObject: object).asURLRequest()
            case .delete:
                return try CSRestRouter.destroyNetworkObject(networkConfig: config, networkObject: object).asURLRequest()
            default:
                return nil
            }
        }
    }
    
}
