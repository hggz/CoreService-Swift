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
