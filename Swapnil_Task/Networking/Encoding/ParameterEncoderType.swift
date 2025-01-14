//
//  ParameterEncoderType.swift
//  Swapnil_Task
//
//  Created by Sonkar, Swapnil on 11/01/25.
//

import Foundation

typealias Parameters = [String: Any]

protocol ParameterEncoderType {
    func encode(urlRequest: inout URLRequest, parameters: Parameters) throws
}
