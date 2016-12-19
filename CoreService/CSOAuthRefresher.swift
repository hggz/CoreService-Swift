//
//  CSOAuthRefresher.swift
//  CoreService
//
//  Created by Hugo Gonzalez on 11/21/16.
//  Copyright © 2016 Cat Bakery. All rights reserved.
//

import Foundation

class CSOAuthRefresher: RequestAdapter, RequestRetrier {
    private typealias RefreshCompletion = (_ succeeded: Bool, _ accessToken: String?, _ refreshToken: String?) -> Void
    
    private let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        
        return SessionManager(configuration: configuration)
    }()
    
    private var requestsToRetry: [RequestRetryCompletion] = []
    private var requestInstance: URLRequest
    private var networkConfig: CSNetworkConfig
    
    private var isRefreshing = false
    private let lock = NSLock()
    
    public init(request: URLRequest, config: CSNetworkConfig) {
        requestInstance = request
        networkConfig = config
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        if (urlRequest.url?.absoluteString.hasPrefix(networkConfig.baseUrl))! {
            var req = urlRequest
//            req.setValue(networkConfig.headers[CSNetworkConfigKey.Authorization.rawValue], forHTTPHeaderField:CSNetworkConfigKey.Authorization.rawValue)
            return req
        }
        return urlRequest
    }
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        lock.lock(); defer {
            lock.unlock()
        }
        
        let response = request.task?.response as? HTTPURLResponse
        if response?.statusCode == 401 {
            requestsToRetry.append(completion)
            
            if !isRefreshing {
                refreshTokens { [weak self] succeeded, accessToken, refreshToken in
                    let strongSelf = self
                    guard strongSelf != nil else {
                        return
                    }
                    strongSelf!.lock.lock(); defer {
                        strongSelf!.lock.unlock()
                    }
                    
                    if accessToken != nil {
                        strongSelf!.networkConfig.accessToken = accessToken!
                    }
                    
                    if refreshToken != nil {
                        strongSelf!.networkConfig.refreshToken = refreshToken!
                    }
                    
                    strongSelf!.requestsToRetry.forEach({ $0(succeeded, 0.0) })
                    strongSelf!.requestsToRetry.removeAll()
                }
            }
        } else {
            completion(false, 0.0)
        }
    }
    
    private func refreshTokens(completion: @escaping RefreshCompletion) {
        guard !isRefreshing else {
            return
        }
        
        isRefreshing = true
        
        let networkUrl = "\(networkConfig.baseUrl)/oauth2/token"
        
        // TODO: won't be doing it this way, just django jwt refresh functionality.
        let parameters: [String: Any] = [
            "access_token": networkConfig.accessToken!,
            "refresh_token": networkConfig.refreshToken!,
            "client_id": networkConfig.clientId,
            "grant_type": "refresh_token"
        ]
        
        sessionManager.request(networkUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { [weak self] response in
            let strongSelf = self
            guard strongSelf != nil else {
                return
            }
            
            if
                let json = response.result.value as? [String: Any],
                let accessToken = json["access_token"] as? String,
                let refreshToken = json["refresh_token"] as? String
            {
                completion(true, accessToken, refreshToken)
            } else {
                completion(false, nil, nil)
            }
            strongSelf!.isRefreshing = false
        }
    }
}
