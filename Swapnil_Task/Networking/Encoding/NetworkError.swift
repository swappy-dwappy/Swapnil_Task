//
//  NetworkError.swift
//  Swapnil_Task
//
//  Created by Sonkar, Swapnil on 11/01/25.
//

import Foundation

enum NetworkError: LocalizedError {
    case parametersNil
    case encodingFailed
    case missingURL
    
    var errorDescription: String? {
        switch self {
        case .parametersNil:
            return "Parameters were nil."
        case .encodingFailed:
            return "Parameter encoding failed."
        case .missingURL:
            return "URL is nil."
        }
    }
}
