//
//  CSNetworkReturnObject.swift
//  CoreService
//
//  Created by Hugo Gonzalez on 12/17/16.
//  Copyright © 2016 Cat Bakery. All rights reserved.
//

import Foundation

public typealias CSNetworkHash = [String: Any]

public struct CSNetworkReturnObject {
    public var data: Data
    public var objectHash: CSNetworkHash
    public var objects: [CSNetworkReturnObject]
    
    public init(data: Data?, objectHash: CSNetworkHash, objects: [CSNetworkReturnObject]) {
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
    
    public init (data: Data?) {
        guard data != nil else {
            self.objects = []
            self.data = Data()
            self.objectHash = [:]
            return
        }
        self.data = data!
        self.objectHash = [:]
        self.objects = []
            do {
            let json = try JSONSerialization.jsonObject(with: self.data, options: []) as Any
                if json is CSNetworkHash {
                    self.objectHash = json as! CSNetworkHash
                    self.objects = []
                    self.data = Data()
                } else if json is [Any] {
                    let arrayOfJson = json as! [[String: Any]]
                    var objects: [CSNetworkReturnObject] = []
                        for object in arrayOfJson {
                            do {
                                let networkObject = CSNetworkReturnObject(objectHash: object)
                                objects.append(networkObject)
                            } catch {
                                assert(false, "Unable to process network object: \(object)")
                            }
                        }
                    self.objects = objects
                    self.data = data!
                }
            } catch {
                self.objectHash = [:]
            }
    }
    
    public init (objectHash: CSNetworkHash) {
        self.objectHash = objectHash
        self.data = NSKeyedArchiver.archivedData(withRootObject: self.objectHash as Any)
        self.objects = []
    }
    
    public init (objects: [CSNetworkReturnObject]) {
        self.data = Data()
        self.objectHash = [:]
        self.objects = objects
    }
}
