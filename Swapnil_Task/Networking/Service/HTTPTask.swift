//
//  HTTPTask.swift
//  Swapnil_Task
//
//  Created by Sonkar, Swapnil on 11/01/25.
//

import Foundation

typealias HTTPHeaders = [String: String]

enum HTTPTask {
    
    case request
    
    case requestParameters(parameterEncoding: ParameterEncoding,
                           urlParameters: Parameters?,
                           bodyParameters: Parameters?)
    
    case requestParametersAndHeaders(parameterEncoding: ParameterEncoding,
                                     urlParameters: Parameters?,
                                     bodyParameters: Parameters?,
                                     additionalHeaders: HTTPHeaders?)
    }
