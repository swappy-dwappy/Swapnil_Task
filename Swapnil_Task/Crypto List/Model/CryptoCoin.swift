//
//  CryptoCoin.swift
//  Swapnil_Task
//
//  Created by Sonkar, Swapnil on 12/01/25.
//

import Foundation

struct CryptoCoin: Codable {
    let name: String
    let symbol: String
    let type: String
    let isActive: Bool
    let isNew: Bool

    enum CodingKeys: String, CodingKey {
        case name
        case symbol
        case type
        case isActive = "is_active"
        case isNew = "is_new"
    }
}
