//
//  EndPointType.swift
//  Swapnil_Task
//
//  Created by Sonkar, Swapnil on 11/01/25.
//

import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var token: String? { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}

extension EndPointType {
    var token: String? {
        return nil
    }
}
