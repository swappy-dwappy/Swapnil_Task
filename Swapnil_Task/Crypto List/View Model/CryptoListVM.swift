//
//  CryptoListVM.swift
//  Swapnil_Task
//
//  Created by Sonkar, Swapnil on 12/01/25.
//

import Combine
import Foundation

class CryptoListVM {
    private(set) var allCryptoCoins: [CryptoCoin] = []
    private(set) var filteredCryptoCoins: [CryptoCoin] = []
    private(set) var searchedCryptoCoins: [CryptoCoin] = []
    var filterButtons: FilterButtons = FilterButtons()

    private var cyrptoCoinsServiceType: CryptoCoinsServiceType
    private var output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
        
    init(cyrptoCoinsServiceType: CryptoCoinsServiceType = CryptoCoinsService()) {
        self.cyrptoCoinsServiceType = cyrptoCoinsServiceType
    }
}

//MARK: FilterButtons
extension CryptoListVM {
    struct FilterButtons {
        var activeCoins = false
        var inactiveCoins = false
        var onlyTokens = false
        var onlyCoins = false
        var newCoins = false
        
        mutating func setState(isActiveCoins: Bool?, isInactiveCoins: Bool?, isOnlyTokens: Bool?,  isOnlyCoins: Bool?, isNewCoins: Bool?) {
            if let isActiveCoins {
                activeCoins = isActiveCoins
            }
            if let isInactiveCoins {
                inactiveCoins = isInactiveCoins
            }
            if let isOnlyTokens {
                onlyTokens = isOnlyTokens
            }
            if let isOnlyCoins {
                onlyCoins = isOnlyCoins
            }
            if let isNewCoins {
                newCoins = isNewCoins
            }
        }
        
        mutating func reset() {
            activeCoins = false
            inactiveCoins = false
            onlyTokens = false
            onlyCoins = false
            newCoins = false
        }
    }
}

//MARK: State
extension CryptoListVM {
    enum Input {
        case viewDidAppear
        case pullToRefresh
        case filterSearch(searchText: String)
        case applyFilters(isActiveCoins: Bool?, isInactiveCoins: Bool?, isOnlyTokens: Bool?,  isOnlyCoins: Bool?, isNewCoins: Bool?)
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
                self?.handleGetCryptoCoins(serviceType: self!.cyrptoCoinsServiceType)
                
            case .pullToRefresh:
                self?.handleGetCryptoCoins(serviceType: CryptoCoinsService())
                
            case .filterSearch(let searchText):
                self?.search(by: searchText)
                
            case .applyFilters(let isActiveCoins, let isInactiveCoins, let isOnlyTokens, let isOnlyCoins, let isNewCoins):
                self?.applyFilters(isActiveCoins: isActiveCoins, isInactiveCoins: isInactiveCoins, isOnlyTokens: isOnlyTokens, isOnlyCoins: isOnlyCoins, isNewCoins: isNewCoins)
            }
        }
        .store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
}

extension CryptoListVM {
    
    private func handleGetCryptoCoins(serviceType: CryptoCoinsServiceType) {
        Task {
            switch await serviceType.getCoins() {
            case .success(let coins):
                reset(with: coins)
                output.send(.fetchCoinsSuceeded)
                
            case .failure(let error):
                reset(with: [])
                output.send(.fetchCoinsFailed(error: error))
            }
        }
    }
    
    fileprivate func reset(with coins: [CryptoCoin]) {
        self.allCryptoCoins = coins
        self.filteredCryptoCoins = coins
        self.searchedCryptoCoins = coins
        filterButtons.reset()
    }
    
    private func search(by query: String) {
        if query.isEmpty {
            searchedCryptoCoins = filteredCryptoCoins
        } else {
            searchedCryptoCoins = filteredCryptoCoins.filter { coin in
                coin.name.lowercased().contains(query.lowercased()) ||
                coin.symbol.lowercased().contains(query.lowercased())
            }
        }
        
        output.send(.filteredSearch)
    }
    
    private func applyFilters(isActiveCoins: Bool?, isInactiveCoins: Bool?, isOnlyTokens: Bool?,  isOnlyCoins: Bool?, isNewCoins: Bool?) {
        
        filterButtons.setState(isActiveCoins: isActiveCoins, isInactiveCoins: isInactiveCoins, isOnlyTokens: isOnlyTokens, isOnlyCoins: isOnlyCoins, isNewCoins: isNewCoins)
        
        filteredCryptoCoins = allCryptoCoins
        if filterButtons.activeCoins {
            filteredCryptoCoins = filteredCryptoCoins.filter { cryptoCoin in
                cryptoCoin.isActive == true && cryptoCoin.type == .coin
            }
        }
        if filterButtons.inactiveCoins {
            filteredCryptoCoins = filteredCryptoCoins.filter { cryptoCoin in
                cryptoCoin.isActive == false && cryptoCoin.type == .coin
            }
        }
        if filterButtons.onlyTokens {
            filteredCryptoCoins = filteredCryptoCoins.filter { cryptoCoin in
                cryptoCoin.type == .token
            }
        }
        if filterButtons.onlyCoins {
            filteredCryptoCoins = filteredCryptoCoins.filter { cryptoCoin in
                cryptoCoin.type == .coin
            }
        }
        if filterButtons.newCoins {
            filteredCryptoCoins = filteredCryptoCoins.filter { cryptoCoin in
                cryptoCoin.isNew
            }
        }
        
        searchedCryptoCoins = filteredCryptoCoins

        output.send(.appliedFilters)
    }
}

// Unit Test
extension CryptoListVM {
    struct TestHooks {
        let viewModel: CryptoListVM
        
        var allCryptoCoins: [CryptoCoin] {
            viewModel.allCryptoCoins
        }
        
        var filteredCryptoCoins: [CryptoCoin] {
            viewModel.filteredCryptoCoins
        }
        
        var searchedCryptoCoins: [CryptoCoin] {
            viewModel.searchedCryptoCoins
        }
        
        var filterButtons: FilterButtons {
            viewModel.filterButtons
        }
        
        func reset(with coins: [CryptoCoin]) {
            viewModel.reset(with: coins)
        }
        
        func applyFilters(isActiveCoins: Bool?, isInactiveCoins: Bool?, isOnlyTokens: Bool?, isOnlyCoins: Bool?, isNewCoins: Bool?) {
            viewModel.applyFilters(isActiveCoins: isActiveCoins, isInactiveCoins: isInactiveCoins, isOnlyTokens: isOnlyTokens, isOnlyCoins: isOnlyCoins, isNewCoins: isNewCoins)
        }
        
        func search(by query: String) {
            viewModel.search(by: query)
        }
    }
    
    var testHooks: TestHooks {
        TestHooks(viewModel: self)
    }
}
