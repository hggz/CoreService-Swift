//
//  CSNetworkObject.swift
//  CoreService
//
//  Created by Hugo Gonzalez on 11/15/16.
//  Copyright © 2016 Cat Bakery. All rights reserved.
//

import Foundation

public typealias ResourceIdentifier = String

public class CSNetworkObject {
    /// Root object location on server, minus base Url. IE: users or api/users
    public var path: String = ""
    /// Identifier to use when referring to this object. This is the primary key for the object on a server. IE: 12 or johnny_appleseed69
    public var resourceID: ResourceIdentifier = ""
    
    /// Provides full url string path to resource on server.
    ///
    /// - returns: full url string path to resource on server.
    public func resourcePath() -> String {
        return "\(path)/\(resourceID)"
    }
    
    /// Formats path to make sure its structured appropriately
    private func formatPath() {
        
    }
}

extension CSNetworkObject: URLConvertible {
    public func asURL() throws -> URL {
        return try resourcePath().asURL()
    }
}
