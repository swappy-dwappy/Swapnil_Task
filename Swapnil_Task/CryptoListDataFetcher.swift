//
//  CryptoListDataFetcher.swift
//  Swapnil_Task
//
//  Created by Sonkar, Swapnil on 16/01/25.
//

import CoreData
import Foundation

class CryptoListDataFetcher: CryptoCoinsServiceType {
    
    func getCoins() async -> Result<[CryptoCoin], any Error> {
        
        await fetchCryptoCoins()
    }
    
    private func fetchCryptoCoins() async -> Result<[CryptoCoin], any Error> {

        let fetchRequest: NSFetchRequest<CryptoCoinEntity> = CryptoCoinEntity.fetchRequest()
        do {
            let coreDataCoins = try PersistenceController.shared.context.fetch(fetchRequest)
            if coreDataCoins.isEmpty {
                return await fetchFromAPI()
            } else {
                let allCoins = coreDataCoins.map { CryptoCoin(name: $0.name!, symbol: $0.symbol!, type: CoinType(rawValue: $0.type!) ?? .coin, isActive: $0.isActive, isNew: $0.isNew) }
                return .success(allCoins)
            }
        } catch {
            print("Error fetching from Core Data: \(error)")
            return await fetchFromAPI()
        }
    }
    
    private func fetchFromAPI() async -> Result<[CryptoCoin], any Error> {
        let result = await CryptoCoinsService().getCoins()
        switch result {
        case .success(let cryptoCoins):
            do {
                try saveCryptoCoinsToCoreData(cryptoCoins)
            } catch {
                print("Error Saving in Core Data: \(error)")
            }
        default:
            break
        }
        
        return result
    }
    
    private func saveCryptoCoinsToCoreData(_ cryptoCoins: [CryptoCoin]) throws {
        let context = PersistenceController.shared.context
        cryptoCoins.forEach { cryptoCoin in
            let entity = CryptoCoinEntity(context: context)
            entity.name = cryptoCoin.name
            entity.symbol = cryptoCoin.symbol
            entity.type = cryptoCoin.type.rawValue
            entity.isActive = cryptoCoin.isActive
            entity.isNew = cryptoCoin.isNew
        }
        PersistenceController.shared.saveContext()
    }
}
