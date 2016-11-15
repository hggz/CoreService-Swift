//
//  CSNetwork.swift
//  CoreService
//
//  Created by Hugo Gonzalez on 11/14/16.
//  Copyright © 2016 Cat Bakery. All rights reserved.
//

import UIKit

enum Router: URLRequestConvertible {
    case createNetworkObject(parameters: Parameters)
    case readNetworkObject(networkObject: CSNetworkObject)
    case updateNetworkObject(networkObject: CSNetworkObject, parameters: Parameters)
    case destroyNetworkObject(networkObject: CSNetworkObject)
    
    static let baseURLString = "https://example.com"
    
    var method: HTTPMethod {
        switch self {
        case .createNetworkObject:
            return .post
        case .readNetworkObject:
            return .get
        case .updateNetworkObject:
            return .put
        case .destroyNetworkObject:
            return .delete
        }
    }
    
    // TODO: parse url from CSNetworkObject. Maybe give them a path param?
    var path: String {
        switch self {
        case .createNetworkObject:
            return "/users"
        case .readNetworkObject(let networkObject):
            return "/users/\(networkObject)"
        case .updateNetworkObject(let networkObject, _):
            return "/users/\(networkObject)"
        case .destroyNetworkObject(let networkObject):
            return "/users/\(networkObject)"
        }
    }
    
    // MARK: URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        let url = try Router.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .createNetworkObject(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .updateNetworkObject(_, let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        default:
            break
        }
        
        return urlRequest
    }
}

open class CSNetwork: NSObject {
    open static let main = CSNetwork()
}
