//
//  CryptoCoin.swift
//  Swapnil_Task
//
//  Created by Sonkar, Swapnil on 12/01/25.
//

import Foundation

enum CoinType: String, Codable {
    case token
    case coin
}

struct CryptoCoin: Codable, Equatable {
    let name: String
    let symbol: String
    let type: CoinType
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
