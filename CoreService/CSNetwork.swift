//
//  CSNetwork.swift
//  CoreService
//
//  Created by Hugo Gonzalez on 11/14/16.
//  Copyright © 2016 Cat Bakery. All rights reserved.
//

import UIKit

open class CSNetwork: NSObject {
    open static let main = CSNetwork()
    
    private var baseURLString = ""
    
    public var baseURL: String {
        return baseURLString
    }
    
    open func setupNetwork(urlString: String, port: String = "80") {
        baseURLString = urlString
    }
}
