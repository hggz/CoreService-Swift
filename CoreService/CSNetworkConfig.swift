//
//  CSNetworkConfig.swift
//  CoreService
//
//  Created by Hugo Gonzalez on 11/21/16.
//  Copyright © 2016 Cat Bakery. All rights reserved.
//

import Foundation

public struct CSNetworkConfig {
    /// Headers to use for request
    var headers: HTTPHeaders
    
    /// Network port
    var port: String
    
    /// Base url endpoint for all requests.
    var baseUrl: String
    
    var isOauth: Bool {
        return headers["Authorization"] != nil
    }
}
