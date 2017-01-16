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
    
    fileprivate var debugEnabled: Bool = false
    
    fileprivate var networks: CSNetwork = [:]
    
    // MARK: - TODO
    fileprivate var requestsToRetry: [URLRequest] = []
    
    // MARK: - Public Functions
    
    open func debug(isEnabled: Bool) {
        debugEnabled = isEnabled
    }
    
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
            let method: HTTPMethod = .get
            let path = pathForNetworkObject(method: method, object: object)
            try networkRequest(networkIdentifier: networkIdentifier, path: path, requestType: method, parameters: nil, completion: { (returnStatus, responseObject, error) in
                if returnStatus == .success {
                    deserializeReturnObjectIntoNetworkObject(networkObject: object, returnObject: responseObject!)
                    completion(.success, object, nil)
                } else {
                    completion(.failure, nil, error)
                }
            })
        } catch {
            
        }
    }
    
    open func createObject(networkIdentifier: CSNetworkIdentifier, object: CSNetworkObject, parameters: Parameters?, completion: @escaping CSRestCompletion) {
        do {
            let method: HTTPMethod = .post
            let path = pathForNetworkObject(method: method, object: object)
            try networkRequest(networkIdentifier: networkIdentifier, path: path, requestType: method, parameters: parameters, completion: { (returnStatus, responseObject, error) in
                if returnStatus == .success {
                    let retrievedObject = CSNetworkObject()
                    completion(.success, retrievedObject, nil)
                } else {
                    completion(.failure, nil, error)
                }
            })
        } catch {
            
        }
    }
    
    open func deleteObject(networkIdentifier: CSNetworkIdentifier, object: CSNetworkObject, completion: @escaping CSRestCompletion) {
        do {
            let method: HTTPMethod = .delete
            let path = pathForNetworkObject(method: method, object: object)
            try networkRequest(networkIdentifier: networkIdentifier, path: path, requestType: method, parameters: nil, completion: { (returnStatus, responseObject, error) in
                if returnStatus == .success {
                    completion(.success, nil, nil)
                } else {
                    completion(.failure, nil, error)
                }
            })
        } catch {
        }
    }
    
    open func updateObject(networkIdentifier: CSNetworkIdentifier, object: CSNetworkObject, parameters: Parameters?, completion: @escaping CSRestCompletion) {
        do {
            let method: HTTPMethod = .put
            let path = pathForNetworkObject(method: method, object: object)
            try networkRequest(networkIdentifier: networkIdentifier, path: path, requestType: method, parameters: parameters, completion: { (returnStatus, responseObject, error) in
                if returnStatus == .success {
                    deserializeReturnObjectIntoNetworkObject(networkObject: object, returnObject: responseObject!)
                    completion(.success, object, nil)
                } else {
                    completion(.failure, nil, error)
                }
            })
        } catch {
        }
    }
    
    // Universal Requests
    
    open func postRequest(networkIdentifier: CSNetworkIdentifier, path: CSNetworkPath, parameters: Parameters?, completion: @escaping CSNetworkCompletion) {
        do {
        try networkRequest(networkIdentifier: networkIdentifier, path: path, requestType: .post, parameters: parameters, completion: completion)
        } catch {
            completion(.failure, nil, nil)
        }
    }
    
    open func getRequest(networkIdentifier: CSNetworkIdentifier, path: CSNetworkPath, parameters: Parameters?, completion: @escaping CSNetworkCompletion) {
        do {
        try networkRequest(networkIdentifier: networkIdentifier, path: path, requestType: .get, parameters: parameters, completion: completion)
        } catch {
            completion(.failure, nil, nil)
        }
    }
    
    // MARK: - TODO
    open func downloadRequest() {
    }
    
    // MARK: - Private Functions
    
    fileprivate func networkRequest(networkIdentifier: CSNetworkIdentifier, path: CSNetworkPath, requestType: HTTPMethod, parameters: Parameters?, completion: @escaping CSNetworkCompletion) throws {
        // load config
        let config = networkConfig(networkIdentifier: networkIdentifier)
        guard config != nil else {
            completion(.nonexistant, nil, nil)
            return
        }
        
        let contentType = config!.headers[.ContentType]
        let headers = httpHeaderfromNetworkHeader(networkHeader: config!.headers)
        
        
        log (logString: "Making a request to \(path)\nRequest type:\(requestType)\nHeaders: \(headers)\nParameters: \(parameters)")
        request(NSURL(string: path) as! URL, method: requestType, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<501)
            .validate(contentType: [contentType!, "text/html"])
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    let returnObject = CSNetworkReturnObject(data: response.data)
                    self.log(logString: "Successful Response:\n\(returnObject)")
                    completion(.success, returnObject, nil)
                case .failure:
                    self.log(logString: "Response Failure:\n\(response.result.error)")
                    completion(.failure, nil, response.result.error)
                }
        }
    }
    
    fileprivate func log(logString: String) {
        if debugEnabled {
            print (logString)
        }
    }
}
