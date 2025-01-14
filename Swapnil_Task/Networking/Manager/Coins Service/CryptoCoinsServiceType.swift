//
//  CryptoCoinsServiceType.swift
//  Swapnil_Task
//
//  Created by Sonkar, Swapnil on 11/01/25.
//

import Foundation

protocol CryptoCoinsServiceType {
    func getCoins() async -> Result<[CryptoCoin], Error>
}
