//
//  CryptoListVC.swift
//  Swapnil_Task
//
//  Created by Sonkar, Swapnil on 11/01/25.
//

import Combine
import UIKit

class CryptoListVC: UIViewController {

    private var viewModel: CryptoListVM!
    var input: PassthroughSubject<CryptoListVM.Input, Never> = .init()
    var cancellables = Set<AnyCancellable>()
    
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    private let filterSheetView = UIView()
    private let refreshControl = UIRefreshControl()
    private var filterButtons = [UIButton]()
    
    init(viewModel: CryptoListVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        input.send(.viewDidAppear)
    }

    private func setupUI() {
        title = "COIN"
        view.backgroundColor = .white

        tableView.register(CryptoCoinTVCell.self, forCellReuseIdentifier: CryptoCoinTVCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Coins"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)

        setupFilterSheet()
    }
    
    @objc private func refreshData() {
        input.send(.pullToRefresh)
    }
    
    private func setupFilterSheet() {
        filterSheetView.backgroundColor = .systemGray3
        filterSheetView.layer.shadowColor = UIColor.black.cgColor
        filterSheetView.layer.shadowOpacity = 0.1
        filterSheetView.layer.shadowOffset = CGSize(width: 0, height: -2)

        view.addSubview(filterSheetView)
        filterSheetView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            filterSheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterSheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterSheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            filterSheetView.heightAnchor.constraint(equalToConstant: 140),
            tableView.bottomAnchor.constraint(equalTo: filterSheetView.topAnchor, constant: 0)
        ])

        // Create filter buttons
        let activeButton = createFilterButton(title: "Active Coins")
        let inactiveButton = createFilterButton(title: "Inactive Coins")
        let tokensButton = createFilterButton(title: "Only Tokens")
        let coinsButton = createFilterButton(title: "Only Coins")
        let newCoinsButton = createFilterButton(title: "New Coins")
        
        filterButtons = [activeButton, inactiveButton, tokensButton, coinsButton, newCoinsButton]
        [activeButton, inactiveButton, tokensButton, coinsButton, newCoinsButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            filterSheetView.addSubview($0)
        }

        let buttonHeight: CGFloat = 40
        let buttonPadding: CGFloat = 16

        // Top row: 2 buttons
        NSLayoutConstraint.activate([
            activeButton.topAnchor.constraint(equalTo: filterSheetView.topAnchor, constant: buttonPadding),
            activeButton.leadingAnchor.constraint(equalTo: filterSheetView.leadingAnchor, constant: buttonPadding),
            activeButton.heightAnchor.constraint(equalToConstant: buttonHeight),

            inactiveButton.topAnchor.constraint(equalTo: activeButton.topAnchor),
            inactiveButton.leadingAnchor.constraint(equalTo: activeButton.trailingAnchor, constant: buttonPadding),
            inactiveButton.heightAnchor.constraint(equalToConstant: buttonHeight),
        ])

        // Second row: 3 buttons
        NSLayoutConstraint.activate([
            tokensButton.topAnchor.constraint(equalTo: activeButton.bottomAnchor, constant: buttonPadding),
            tokensButton.leadingAnchor.constraint(equalTo: filterSheetView.leadingAnchor, constant: buttonPadding),
            tokensButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            coinsButton.topAnchor.constraint(equalTo: tokensButton.topAnchor),
            coinsButton.leadingAnchor.constraint(equalTo: tokensButton.trailingAnchor, constant: buttonPadding),
            coinsButton.heightAnchor.constraint(equalToConstant: buttonHeight),

            newCoinsButton.topAnchor.constraint(equalTo: coinsButton.topAnchor),
            newCoinsButton.leadingAnchor.constraint(equalTo: coinsButton.trailingAnchor, constant: buttonPadding),
            newCoinsButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
    }

    private func createFilterButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        let configuration = UIButton.Configuration.plain()
        button.configuration = configuration
        let padding: CGFloat = 8
        
        button.setTitle(title, for: .normal)
        applyButtonStyle(button: button)
        button.configuration!.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: padding, bottom: 0, trailing: padding)

        button.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    @objc private func filterButtonTapped(_ sender: UIButton) {
        guard let title = sender.title(for: .normal) else { return }
        sender.isSelected.toggle()
        sender.backgroundColor = sender.isSelected ? .black : .systemGray6
        searchController.isActive = false
        
        switch title {
        case "Active Coins":
            self.input.send(.applyFilters(isActiveCoins: !viewModel.filterButtons.activeCoins, isInactiveCoins: nil, isOnlyTokens: nil, isOnlyCoins: nil, isNewCoins: nil))
        case "Inactive Coins":
            self.input.send(.applyFilters(isActiveCoins: nil, isInactiveCoins: !viewModel.filterButtons.inactiveCoins, isOnlyTokens: nil, isOnlyCoins: nil, isNewCoins: nil))
        case "Only Tokens":
            self.input.send(.applyFilters(isActiveCoins: nil, isInactiveCoins: nil, isOnlyTokens: !viewModel.filterButtons.onlyTokens, isOnlyCoins: nil, isNewCoins: nil))
        case "Only Coins":
            self.input.send(.applyFilters(isActiveCoins: nil, isInactiveCoins: nil, isOnlyTokens: nil, isOnlyCoins: !viewModel.filterButtons.onlyCoins, isNewCoins: nil))
        case "New Coins":
            self.input.send(.applyFilters(isActiveCoins: nil, isInactiveCoins: nil, isOnlyTokens: nil, isOnlyCoins: nil, isNewCoins: !viewModel.filterButtons.newCoins))
        default:
            break
        }
    }
    
    private func resetFilterButtons() {
        filterButtons.forEach { button in
            applyButtonStyle(button: button)
        }
    }
    
    private func applyButtonStyle(button: UIButton) {
        button.setTitleColor(.darkGray, for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.backgroundColor = .systemGray6
        button.isSelected = false
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
                    
                case .fetchCoinsSuceeded:
                    self?.tableView.reloadData()
                    self?.refreshControl.endRefreshing()
                    self?.resetFilterButtons()
                    
                case .appliedFilters, .filteredSearch:
                    self?.tableView.reloadData()
                    self?.refreshControl.endRefreshing()
                }
            }
            .store(in: &cancellables)
    }
}

//MARK: UITableView
extension CryptoListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchedCryptoCoins.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CryptoCoinTVCell.reuseIdentifier, for: indexPath) as? CryptoCoinTVCell else {
            return UITableViewCell()
        }
        let cryptoCoin = viewModel.searchedCryptoCoins[indexPath.row]
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

