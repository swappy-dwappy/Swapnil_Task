//
//  RouterType.swift
//  Swapnil_Task
//
//  Created by Sonkar, Swapnil on 11/01/25.
//

import Foundation

protocol RouterType: AnyObject {
    
    var urlSession: URLSession { get set }
    func request(route: EndPointType) async throws -> (Data, URLResponse)
}
