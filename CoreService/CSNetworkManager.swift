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

public typealias CSNetworkPath = String
public typealias CSNetworkIdentifier = String
public typealias CSNetwork = [CSNetworkIdentifier: CSNetworkConfig]
public typealias CSNetworkCompletion = (_ returnStatus: CSNetworkReturnStatus, _ responseObject: CSNetworkReturnObject?, _ error: Error?) -> Void
public typealias CSRestCompletion = (_ returnStatus: CSNetworkReturnStatus, _ object: CSNetworkObject?, _ error: Error?) -> Void

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
    
    open func updateNetworkHeaders(networkIdentifier: CSNetworkIdentifier, networkHeaders: CSNetworkHeader) {
        var config = networks[networkIdentifier]
        guard config != nil else {
            return
        }
        config!.headers = networkHeaders
        networks[networkIdentifier] = config!
    }
    
    open func networkConfig(networkIdentifier: CSNetworkIdentifier) -> CSNetworkConfig? {
        return networks[networkIdentifier]
    }
    
    // REST requests
    open func getObject(networkIdentifier: CSNetworkIdentifier, object: CSNetworkObject, completion: @escaping CSRestCompletion) {
        do {
        try restRequest(requestType: .read, networkIdentifier: networkIdentifier, object: object, parameters: nil, completion: completion)
        } catch {
            
        }
    }
    
    open func createObject(networkIdentifier: CSNetworkIdentifier, object: CSNetworkObject, parameters: Parameters, completion: @escaping CSRestCompletion) {
        do {
        try restRequest(requestType: .create, networkIdentifier: networkIdentifier, object: object, parameters: parameters, completion: completion)
        } catch {
            
        }
    }
    
    open func deleteObject(networkIdentifier: CSNetworkIdentifier, object: CSNetworkObject, completion: @escaping CSRestCompletion) {
        do {
        try restRequest(requestType: .delete, networkIdentifier: networkIdentifier, object: object, parameters: nil, completion: completion)
        } catch {
        }
    }
    
    open func updateObject(networkIdentifier: CSNetworkIdentifier, object: CSNetworkObject, parameters: Parameters, completion: @escaping CSRestCompletion) {
        do {
        try restRequest(requestType: .update, networkIdentifier: networkIdentifier, object: object, parameters: parameters, completion: completion)
        } catch {
        }
    }
    
    // Universal Requests
    
    open func postRequest(networkIdentifier: CSNetworkIdentifier, path: CSNetworkPath, parameters: Parameters, completion: @escaping CSNetworkCompletion) {
        do {
        try networkRequest(networkIdentifier: networkIdentifier, path: path, requestType: .post, parameters: parameters, completion: completion)
        } catch {
        }
    }
    
    open func getRequest(networkIdentifier: CSNetworkIdentifier, path: CSNetworkPath, parameters: Parameters, completion: @escaping CSNetworkCompletion) {
        do {
        try networkRequest(networkIdentifier: networkIdentifier, path: path, requestType: .get, parameters: parameters, completion: completion)
        } catch {
            
        }
    }
    
    open func downloadRequest() {
    }
    
    // MARK: - Private Functions
    
    fileprivate func networkRequest(networkIdentifier: CSNetworkIdentifier, path: CSNetworkPath, requestType: HTTPMethod, parameters: Parameters, completion: @escaping CSNetworkCompletion) throws {
        // load config
        let config = networkConfig(networkIdentifier: networkIdentifier)
        guard config != nil else {
            completion(.nonexistant, nil, nil)
            return
        }
        
        let contentType = config!.headers[.ContentType]
        let headers = httpHeaderfromNetworkHeader(networkHeader: config!.headers)
        
        request(NSURL(string: path) as! URL, method: requestType, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<401)
            .validate(contentType: [contentType!])
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    let returnObject = CSNetworkReturnObject(data: response.data)
                    completion(.success, returnObject, nil)
                case .failure:
                    completion(.failure, nil, response.result.error)
                }
        }
    }
    
    fileprivate func restRequest(requestType: CSNetworkRestRequest, networkIdentifier: CSNetworkIdentifier, object: CSNetworkObject, parameters: Parameters?, completion: @escaping CSRestCompletion) throws {
        // check config
        let config = networkConfig(networkIdentifier: networkIdentifier)
        guard config != nil else { 
            completion(.nonexistant, nil, nil)
            return
        }
        
        // setup request
        let request = try restUrlRequest(type: requestType, config: config!, object: object, parameters: parameters)
        guard request != nil else { 
            completion(.invalid, nil, nil)
            return
        }
        
        // setup adapter and retrier
        let refresher = CSOAuthRefresher(request: request!, config: config!)
        
        // perform request
        let sessionManager = SessionManager()
        sessionManager.adapter = refresher
        sessionManager.retrier = refresher
        sessionManager.request(request!).validate().response { (response) in
            completion(.success, object, nil) // should be new object. not current object
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
