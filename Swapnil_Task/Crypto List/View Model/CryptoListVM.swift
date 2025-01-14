//
//  CryptoListVM.swift
//  Swapnil_Task
//
//  Created by Sonkar, Swapnil on 12/01/25.
//

import Combine
import Foundation

class CryptoListVM {
    private var allCryptoCoins: [CryptoCoin] = []
    private(set) var filteredCryptoCoins: [CryptoCoin] = []

    private var cyrptoCoinsServiceType: CryptoCoinsServiceType
    private var output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
        
    init(cyrptoCoinsServiceType: CryptoCoinsServiceType = CryptoCoinsService()) {
        self.cyrptoCoinsServiceType = cyrptoCoinsServiceType
    }
}

// State
extension CryptoListVM {
    enum Input {
        case viewDidAppear
        case filterSearch(searchText: String)
        case applyFilters(isActive: Bool?, type: CoinType?, isNew: Bool?)
    }
    
    enum Output {
        case fetchCoinsFailed(error: Error)
        case fetchCoinsSuceeded
        case filteredSearch
        case appliedFilters
    }
}

extension CryptoListVM {
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] input in
            switch input {
            case .viewDidAppear:
                self?.handleGetCryptoCoins()
                
            case .filterSearch(let searchText):
                self?.search(by: searchText)
                
            case .applyFilters(let isActive, let type, let isNew):
                self?.applyFilters(isActive: isActive, type: type, isNew: isNew)
            }
        }
        .store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
}

extension CryptoListVM {
    
    private func handleGetCryptoCoins() {
        Task {
            switch await cyrptoCoinsServiceType.getCoins() {
            case .success(let coins):
                self.allCryptoCoins = coins
                self.filteredCryptoCoins = self.allCryptoCoins
                output.send(.fetchCoinsSuceeded)
                
            case .failure(let error):
                output.send(.fetchCoinsFailed(error: error))
            }
        }
    }
    
    private func search(by query: String) {
        if query.isEmpty {
            filteredCryptoCoins = allCryptoCoins
        } else {
            filteredCryptoCoins = allCryptoCoins.filter { coin in
                coin.name.lowercased().contains(query.lowercased()) ||
                coin.symbol.lowercased().contains(query.lowercased())
            }
        }
        
        output.send(.filteredSearch)
    }
    
    private func applyFilters(isActive: Bool?, type: CoinType?, isNew: Bool?) {
        filteredCryptoCoins = allCryptoCoins.filter { coin in
            let matchesActive = isActive == nil || coin.isActive == isActive
            let matchesType = type == nil || coin.type == type
            let matchesNew = isNew == nil || coin.isNew == isNew
            return matchesActive && matchesType && matchesNew
        }
        output.send(.appliedFilters)
    }
}
