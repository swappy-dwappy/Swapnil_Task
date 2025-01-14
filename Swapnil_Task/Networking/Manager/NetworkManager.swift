//
//  NetworkManager.swift
//  Swapnil_Task
//
//  Created by Sonkar, Swapnil on 11/01/25.
//

import Foundation
import UIKit

enum NetworkResponse: LocalizedError {
    case success 
    case authenticationError
    case badRequest
    case outdated
    case failed
    case noData
    case unableToDecode
    case custom(errorDescription: String)
    
    var errorDescription: String? {
        switch self {
        case .success:
            return "Success"
        case .authenticationError:
            return "You need to be authenticated first."
        case .badRequest:
            return "Bad request"
        case .outdated:
            return "The url you requested is outdated."
        case .failed:
            return "Network request failed."
        case .noData:
            return "Response returned with no data to decode."
        case .unableToDecode:
            return "We could not decode the response."
        case .custom(let errorDescription):
            return errorDescription
        }
    }
}

enum NetworkEnvironment {
    case qa
    case production
    case staging
}

class NetworkManager {

    static let environment: NetworkEnvironment = .qa
}

extension NetworkManager {
    fileprivate func handleNetworkResponseCode(_ response: URLResponse) throws {
        
        guard let httpUrlResponse = response as? HTTPURLResponse else { throw (NetworkResponse.custom(errorDescription: "Invalid HTTP response")) }
        
        switch httpUrlResponse.statusCode {
        case 200...299: break
        case 401...500: throw NetworkResponse.authenticationError
        case 501...599: throw NetworkResponse.badRequest
        case 600: throw NetworkResponse.outdated
        default: throw NetworkResponse.failed
        }
    }
    
    func getModelFromResponse<T: Decodable>(data: Data, decoder: JSONDecoder = JSONDecoder(), response: URLResponse) -> Result<T, Error> {
        do {
            try handleNetworkResponseCode(response)
            let model = try decoder.decode(T.self, from: data)
            return .success(model)
        } catch {
            return .failure(error)
        }
    }
}
