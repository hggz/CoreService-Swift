//
//  CSOAuthRefresher.swift
//  CoreService
//
//  Created by Hugo Gonzalez on 11/21/16.
//  Copyright © 2016 Cat Bakery. All rights reserved.
//

import Foundation

class CSOAuthRefresher: RequestAdapter, RequestRetrier {
    var requestInstance: URLRequest
    
    public init(request: URLRequest) {
        requestInstance = request
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        return requestInstance
    }
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        
    }
}
