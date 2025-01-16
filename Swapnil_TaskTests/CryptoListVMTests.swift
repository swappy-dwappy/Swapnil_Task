//
//  CryptoListVMTests.swift
//  Swapnil_TaskTests
//
//  Created by Sonkar, Swapnil on 11/01/25.
//

import Foundation

@testable import Swapnil_Task
import XCTest
import Combine

final class CryptoListVMTests: XCTestCase {
    
    var viewModel: CryptoListVM!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        viewModel = CryptoListVM(cyrptoCoinsServiceType: MockCryptoCoinsService())
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testFetchCoinsSuccess() {
        let expectation = XCTestExpectation(description: "Fetch coins succeeded")
        
        viewModel.transform(input: Just(.viewDidAppear).eraseToAnyPublisher())
            .sink { output in
                if case .fetchCoinsSuceeded = output {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(viewModel.testHooks.allCryptoCoins.count, MockCryptoCoinsService.mockCoins.count)
        XCTAssertEqual(viewModel.testHooks.filteredCryptoCoins.count, MockCryptoCoinsService.mockCoins.count)
        XCTAssertEqual(viewModel.testHooks.searchedCryptoCoins.count, MockCryptoCoinsService.mockCoins.count)
    }
    
    func testFetchCoinsFailure() {
        let viewModel = CryptoListVM(cyrptoCoinsServiceType: MockCryptoCoinsService(shouldFail: true))
        let expectation = XCTestExpectation(description: "Fetch coins failed")
        
        viewModel.transform(input: Just(.viewDidAppear).eraseToAnyPublisher())
            .sink { output in
                if case .fetchCoinsFailed = output {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(viewModel.testHooks.allCryptoCoins.count, 0)
    }
    
    func testApplyFilters() {
        let coins = MockCryptoCoinsService.mockCoins
        viewModel.testHooks.reset(with: coins)
        
        viewModel.testHooks.applyFilters(isActiveCoins: true, isInactiveCoins: nil, isOnlyTokens: nil, isOnlyCoins: nil, isNewCoins: nil)
        
        XCTAssertTrue(viewModel.testHooks.filteredCryptoCoins.allSatisfy { $0.isActive })
    }
    
    func testSearch() {
        let coins = MockCryptoCoinsService.mockCoins
        viewModel.testHooks.reset(with: coins)
        
        let searchQuery = coins.first?.name.prefix(3) ?? ""
        viewModel.testHooks.search(by: String(searchQuery))
        
        XCTAssertTrue(viewModel.testHooks.searchedCryptoCoins.allSatisfy { $0.name.contains(searchQuery) })
    }
    
    func testReset() {
        let coins = MockCryptoCoinsService.mockCoins
        viewModel.testHooks.reset(with: coins)
        
        XCTAssertEqual(viewModel.testHooks.allCryptoCoins, coins)
        XCTAssertEqual(viewModel.testHooks.filteredCryptoCoins, coins)
        XCTAssertEqual(viewModel.testHooks.searchedCryptoCoins, coins)
        XCTAssertFalse(viewModel.testHooks.filterButtons.activeCoins)
    }
}


