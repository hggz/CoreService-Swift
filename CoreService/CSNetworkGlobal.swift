//
//  CSNetworkGlobal.swift
//  CoreService
//
//  Created by Hugo Gonzalez on 12/17/16.
//  Copyright © 2016 Cat Bakery. All rights reserved.
//

import Foundation
import CoreData

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
        if !propertyIsArray(property, object: reflection.subjectType as! NSObject.Type) {
            let value = deserializedValueFromHashValue(hashValue: objectHash[property])
            networkObject.setValue(value, forKey: property)
        }
    }
}

public func serializeManageObject(networkObject: CSNetworkObject, managedObject: NSManagedObject) { 
    let reflection = Mirror(reflecting: networkObject)
    for child in reflection.children {
        let property = child.label!
        let value = child.value
        managedObject.setValue(value, forKey: property)
    }
}
    
public func getTypeOf(property: objc_property_t) -> Any {
    guard let attributesAsNSString: NSString = NSString(utf8String: property_getAttributes(property)) else { return Any.self }
    let attributes = attributesAsNSString as String
    let slices = attributes.components(separatedBy: "\"")
    guard slices.count > 1 else { return String(attributes) }
    let objectClassName = slices[1]
    let objectClass = NSClassFromString(objectClassName) as! NSObject.Type
    return objectClass
}

public func getNameOf(property: objc_property_t) -> String? {
    guard let name: NSString = NSString(utf8String: property_getName(property)) else { return nil }
    return name as String
}

fileprivate func propertyIsArray(_ property: String, object: NSObject.Type) -> Bool {
    var count = UInt32()
    let properties = class_copyPropertyList(object as NSObject.Type, &count)
    var types: [String: String] = [:]
    for i in 0..<Int(count) {
        let property: objc_property_t = properties![i]!
        let name = getNameOf(property: property)
        let type = getTypeOf(property: property)
        types[name!] = "\(type)"
    }
    free(properties)
    
    return (types[property]?.contains("NSArray"))!
}

private func deserializedValueFromHashValue(hashValue: Any?) -> Any {
    var value = ""
    if hashValue != nil {
        if hashValue is [Any] {
            return [] // handle array
        } else if hashValue is [String: Any] {
            return [:] // handle dictionary
        } else {
            value = "\(hashValue!)"
        }
    }
    return value
}
