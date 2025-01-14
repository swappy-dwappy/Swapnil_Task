//
//  CryptoCoinsService.swift
//  Swapnil_Task
//
//  Created by Sonkar, Swapnil on 11/01/25.
//

import Foundation

class CryptoCoinsService: NetworkManager, CryptoCoinsServiceType {
    
    func getCoins() async -> Result<[CryptoCoin], Error> {
        do {
            let (data, response) = try await Router().request(route: CoinApi.getCoins)
            let decoder = JSONDecoder()
            return getModelFromResponse(data: data, decoder: decoder, response: response)
        } catch {
            return .failure(error)
        }
    }
}
