//
//  CSRouter.swift
//  CoreService
//
//  Created by Hugo Gonzalez on 11/15/16.
//  Copyright © 2016 Cat Bakery. All rights reserved.
//

import Foundation

enum CSRestRouter: URLRequestConvertible {
    case createNetworkObject(networkObject: CSNetworkObject, parameters: Parameters)
    case readNetworkObject(networkObject: CSNetworkObject)
    case updateNetworkObject(networkObject: CSNetworkObject, parameters: Parameters)
    case destroyNetworkObject(networkObject: CSNetworkObject)
    
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
    
    var path: String {
        switch self {
        case .createNetworkObject(let networkObject, _):
            return networkObject.path
        case .readNetworkObject(let networkObject):
            return networkObject.resourcePath()
        case .updateNetworkObject(let networkObject, _):
            return networkObject.resourcePath()
        case .destroyNetworkObject(let networkObject):
            return networkObject.resourcePath()
        }
    }
    
    // MARK: URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        let url = try CSNetwork.main.baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .createNetworkObject(_, let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .updateNetworkObject(_, let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        default:
            break
        }
        
        return urlRequest
    }
}
