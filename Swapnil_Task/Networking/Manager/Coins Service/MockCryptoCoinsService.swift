//
//  MockCryptoCoinsService.swift
//  Swapnil_Task
//
//  Created by Sonkar, Swapnil on 11/01/25.
//

import Foundation

final class MockCryptoCoinsService: CryptoCoinsServiceType {
    static let mockCoins: [CryptoCoin] = [
        CryptoCoin(name: "Bitcoin", symbol: "BTC", type: .coin, isActive: true, isNew: false),
        CryptoCoin(name: "Ethereum", symbol: "ETH", type: .coin, isActive: true, isNew: false),
        CryptoCoin(name: "Dogecoin", symbol: "DOGE", type: .token, isActive: false, isNew: true)
    ]
    
    private let shouldFail: Bool
    
    init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
    }
    
    func getCoins() async -> Result<[CryptoCoin], Error> {
        try? await Task.sleep(nanoseconds: 200_000)
        if shouldFail {
            return .failure(NSError(domain: "TestError", code: 1, userInfo: nil))
        }
        return .success(MockCryptoCoinsService.mockCoins)
    }
}
