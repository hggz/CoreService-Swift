//
//  CSNetworkObject.swift
//  CoreService
//
//  Created by Hugo Gonzalez on 11/15/16.
//  Copyright © 2016 Cat Bakery. All rights reserved.
//

import Foundation

public typealias ResourceIdentifier = String

public class CSNetworkObject: NSObject {
    /// Root object location on server, minus base Url. IE: users or api/users. Should only be overwritten, not reflected.
    public var path: String = ""
    
    /// Identifier to use when referring to this object. This is the primary key for the object on a server. IE: 12 or johnny_appleseed69. Will default to id or to classId unless overwritten. If overwritten, it'll take that value.
    public var resourceID: ResourceIdentifier = ""
}

extension CSNetworkObject: URLConvertible {
    public func asURL() throws -> URL {
        return try resourcePath().asURL()
    }
}

extension CSNetworkObject {
    /// Provides full url string path to resource on server.
    ///
    /// - returns: full url string path to resource on server.
    public func resourcePath() -> String {
        return "\(path)/\(resourceID)"
    }
    
    /// Converts snake case string to camel case.
    ///
    /// - parameter string: string to evaluate.
    ///
    /// - returns: snake case representation of string.
    fileprivate func camelCaseString(string: String) -> String {
        let components = string.components(separatedBy: "_")
        if components.count == 1 {
            return string.lowercased()
        }
        var camelCaseString = ""
        for i in 0..<components.count {
            let chunk = components[i]
            if i == 0 {
                camelCaseString.append(chunk.lowercased())
            } else {
                camelCaseString.append(chunk.capitalized)
            }
        }
        return camelCaseString
    }
    
}
