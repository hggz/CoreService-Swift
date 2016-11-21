//
//  CSNetworkConfig.swift
//  CoreService
//
//  Created by Hugo Gonzalez on 11/21/16.
//  Copyright © 2016 Cat Bakery. All rights reserved.
//

import Foundation

public struct CSNetworkConfig {
    var headers: HTTPHeaders
    var port: String
    
    /// Base url endpoint for all requests.
    var baseUrl: String
}
