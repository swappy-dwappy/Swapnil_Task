//
//  CryptoListVC.swift
//  Swapnil_Task
//
//  Created by Sonkar, Swapnil on 11/01/25.
//

import Combine
import UIKit

class CryptoListVC: UIViewController {

    private let viewModel = CryptoListVM()
    var input: PassthroughSubject<CryptoListVM.Input, Never> = .init()
    var cancellables = Set<AnyCancellable>()
    
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        input.send(.viewDidAppear)
    }

    private func setupUI() {
        title = "COIN"
        view.backgroundColor = .white

        // Setup TableView
        tableView.register(CryptoCoinTVCell.self, forCellReuseIdentifier: CryptoCoinTVCell.reuseIdentifier)
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        // Setup Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Coins"
        navigationItem.searchController = searchController
        definesPresentationContext = true

        // Add Filter Button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(showFilterOptions))
    }

    @objc private func showFilterOptions() {
        let alert = UIAlertController(title: "Filters", message: nil, preferredStyle: .actionSheet)

        // Filter by Active
        alert.addAction(UIAlertAction(title: "Active Coins", style: .default, handler: { _ in
            self.input.send(.applyFilters(isActive: true, type: nil, isNew: nil))
        }))

        // Filter by Type (Example: "token")
        alert.addAction(UIAlertAction(title: "Type: Token", style: .default, handler: { _ in
            self.input.send(.applyFilters(isActive: nil, type: .token, isNew: nil))
        }))

        // Filter by New
        alert.addAction(UIAlertAction(title: "New Coins", style: .default, handler: { _ in
            self.input.send(.applyFilters(isActive: nil, type: nil, isNew: true))
        }))

        alert.addAction(UIAlertAction(title: "Clear Filters", style: .cancel, handler: { _ in
            self.input.send(.applyFilters(isActive: nil, type: nil, isNew: nil))
        }))

        present(alert, animated: true, completion: nil)
    }
}

//MARK: Binding
extension CryptoListVC {
    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                switch output {
                case .fetchCoinsFailed(let error):
                    // Throw Alert with error.localizedDescription
                    print(error.localizedDescription)
                    break
                    
                case .fetchCoinsSuceeded, .filteredSearch, .appliedFilters:
                    self?.tableView.reloadData()
                }
            }
            .store(in: &cancellables)
    }
}

//MARK: UITableView
extension CryptoListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredCryptoCoins.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CryptoCoinTVCell.reuseIdentifier, for: indexPath) as? CryptoCoinTVCell else {
            return UITableViewCell()
        }
        let cryptoCoin = viewModel.filteredCryptoCoins[indexPath.row]
        cell.configure(with: cryptoCoin)
        return cell
    }
}

//MARK: Search
extension CryptoListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else { return }
        input.send(.filterSearch(searchText: query))
    }
}

