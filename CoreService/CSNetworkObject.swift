//
//  CSNetworkObject.swift
//  CoreService
//
//  Created by Hugo Gonzalez on 11/15/16.
//  Copyright © 2016 Cat Bakery. All rights reserved.
//

import UIKit

class CSNetworkObject: NSObject {

}

extension CSNetworkObject: URLConvertible {
    func asURL() throws -> URL {
        let urlString = ""
        return try urlString.asURL()
    }
}
