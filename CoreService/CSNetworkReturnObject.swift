//
//  CSNetworkReturnObject.swift
//  CoreService
//
//  Created by Hugo Gonzalez on 12/17/16.
//  Copyright © 2016 Cat Bakery. All rights reserved.
//

import Foundation

public typealias CSNetworkHash = [String: Any]
public typealias CSNetworkReturnObjects = [CSNetworkReturnObject]

public struct CSNetworkReturnObject {
    public var data: Data
    public var objectHash: CSNetworkHash
    public var objects: [CSNetworkReturnObjects]
    
    init(data: Data?, objectHash: CSNetworkHash, objects: [CSNetworkReturnObjects]) {
        guard data != nil else {
            self.objects = []
            self.data = Data()
            self.objectHash = [:]
            return
        }
        self.data = data!
        self.objectHash = objectHash
        self.objects = objects
    }
    
    init (data: Data?) {
        guard data != nil else {
            self.objects = []
            self.data = Data()
            self.objectHash = [:]
            return
        }
        self.data = data!
        self.objects = []
            do {
            self.objectHash = try JSONSerialization.jsonObject(with: self.data, options: []) as! CSNetworkHash
            } catch {
                self.objectHash = [:]
            }
    }
    
    init (objectHash: CSNetworkHash) {
        self.objectHash = objectHash
        self.data = NSKeyedArchiver.archivedData(withRootObject: self.objectHash as Any)
        self.objects = []
    }
    
    init (objects: [CSNetworkReturnObjects]) {
        self.data = Data()
        self.objectHash = [:]
        self.objects = objects
    }
}
