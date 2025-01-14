//
//  Router.swift
//  Swapnil_Task
//
//  Created by Sonkar, Swapnil on 11/01/25.
//

import Foundation

class Router: RouterType {
    
    var urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func request(route: EndPointType) async throws -> (Data, URLResponse) {
        let request = try buildRequest(from: route)
        return try await urlSession.data(for: request)
    }
}

extension Router {
    
    fileprivate func buildRequest(from route: EndPointType) throws -> URLRequest {
        
        let url = route.baseURL.appending(path: route.path)

        var urlRequest = URLRequest(url: url,
                                    cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                    timeoutInterval: 10.0)
        
        urlRequest.httpMethod = route.httpMethod.rawValue
        switch route.task {
        case .request:
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            if let token = route.token {
                let authToken: HTTPHeaders = ["Bearer \(token)": "Authorization"]
                addAdditionalHeaders(authToken, urlRequest: &urlRequest)
            }
            
        case let .requestParameters(parameterEncoding,
                                    urlParameters,
                                    bodyParameters):
            
            if let token = route.token {
                let authHeader: HTTPHeaders = ["Bearer \(token)": "Authorization"]
                addAdditionalHeaders(authHeader, urlRequest: &urlRequest)
            }
            try configureParameters(urlRequest: &urlRequest, parameterEncoding: parameterEncoding, urlParameters: urlParameters, bodyParameters: bodyParameters)
            
        case let .requestParametersAndHeaders(parameterEncoding,
                                              urlParameters,
                                              bodyParameters,
                                              additionalHeaders):
            
            var additionalHeaders = additionalHeaders ?? HTTPHeaders()
            if let token = route.token {
                additionalHeaders["Authorization"] = "Bearer \(token)"
            }
            addAdditionalHeaders(additionalHeaders, urlRequest: &urlRequest)
            try configureParameters(urlRequest: &urlRequest, parameterEncoding: parameterEncoding, urlParameters: urlParameters, bodyParameters: bodyParameters)
        }
        
        return urlRequest
    }
    
    fileprivate func configureParameters(urlRequest: inout URLRequest,
                                    parameterEncoding: ParameterEncoding,
                                    urlParameters: Parameters?,
                                    bodyParameters: Parameters?) throws {
        
        try parameterEncoding.encode(urlRequest: &urlRequest, 
                                     urlParameters: urlParameters,
                                     bodyParameters: bodyParameters)
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, urlRequest: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        let _ = headers.map {
            urlRequest.setValue($0.key, forHTTPHeaderField: $0.value)
        }
    }
}
