//
//  CoinEndPoint.swift
//  Swapnil_Task
//
//  Created by Sonkar, Swapnil on 11/01/25.
//

import Foundation

enum CoinApi {
    case getCoins
}

extension CoinApi: EndPointType {
    
    var environmentBaseURL: String {
        switch NetworkManager.environment {
        case .qa: return "https://37656be98b8f42ae8348e4da3ee3193f.api.mockbin.i"
        case .staging: return "https://37656be98b8f42ae8348e4da3ee3193f.api.mockbin.io"
        case .production: return "https://37656be98b8f42ae8348e4da3ee3193f.api.mockbin.io"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else {
            fatalError("Base URL could not be configured.")
        }
        
        return url
    }
    
    var path: String {
        switch self {
        case .getCoins: return ""
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getCoins:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getCoins:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .getCoins:
            return nil
        }
    }
}
