//
//  CSNetworkConfig.swift
//  CoreService
//
//  Created by Hugo Gonzalez on 11/21/16.
//  Copyright © 2016 Cat Bakery. All rights reserved.
//

import Foundation

public enum CSNetworkConfigKey: String {
    case Authorization = "Authorization"
    case Accept = "Accept"
    case ContentType = "Content-Type"
}

public typealias CSNetworkHeader = [CSNetworkConfigKey: String]

public struct CSNetworkConfig {
    
    /// Headers to use for request
    public var headers: CSNetworkHeader
    
    /// Network port
    public var port: String
    
    /// Base url endpoint for all requests.
    public var baseUrl: String
    
    // Client ID of application
    public var clientId: String
    
    // Current access token of network
    public var accessToken: String?
    
    // Current refresh token of network
    public var refreshToken: String?
    
    
    var isOauth: Bool {
        return headers[.Authorization] != nil
    }
    
    init(headers: CSNetworkHeader, port: String, baseUrl: String, clientId: String) {
        self.headers = headers
        self.port = port
        self.baseUrl = baseUrl
        self.clientId = clientId
    }
    
    func path(path: String) -> CSNetworkPath {
        return "\(baseUrl)/\(path)"
    }
}
