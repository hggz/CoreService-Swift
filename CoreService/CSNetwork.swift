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
    
    public var baseURL: String = ""
    
    open func setupNetwork(baseUrlString: String) {
        baseURL = baseUrlString
    }
}
