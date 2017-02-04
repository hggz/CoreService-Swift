//
//  CSNetworkGlobal.swift
//  CoreService
//
//  Created by Hugo Gonzalez on 12/17/16.
//  Copyright © 2016 Cat Bakery. All rights reserved.
//

import Foundation

public func pathForNetworkConfig(config: CSNetworkConfig, path: String) -> CSNetworkPath {
    return "\(config.baseUrl)/\(path)"
}

public func httpHeaderfromNetworkHeader(networkHeader: CSNetworkHeader) -> HTTPHeaders {
    var header: HTTPHeaders = [:]
    for (key, value) in networkHeader {
        header[key.rawValue] = value
    }
    return header
}

public func pathForNetworkObject(method: HTTPMethod, object: CSNetworkObject) -> String {
    return method == .post ? object.path : object.resourcePath()
}

public func deserializeReturnObjectIntoNetworkObject(networkObject: CSNetworkObject, returnObject: CSNetworkReturnObject) {
    let reflection = Mirror(reflecting: networkObject)
    var objectHash = returnObject.objectHash
    // If we can't find an item, we'll look inside collection of objects and choose the last one. Revisit this later.
    if objectHash.count < 1 && returnObject.objects.count > 0 {
        objectHash = returnObject.objects[returnObject.objects.count - 1].objectHash
    }
    for child in reflection.children {
        let property = child.label!
        let value = deserializedValueFromHashValue(hashValue: objectHash[property])
        networkObject.setValue(value, forKey: property)
    }
}

private func deserializedValueFromHashValue(hashValue: Any?) -> Any {
    var value = ""
    if hashValue != nil {
        if hashValue is [Any] {
            return nil // handle array
        } else if hashValue is [String: Any] {
            return nil // handle dictionary
        } else {
            value = "\(hashValue!)"
        }
    }
    return value
}
