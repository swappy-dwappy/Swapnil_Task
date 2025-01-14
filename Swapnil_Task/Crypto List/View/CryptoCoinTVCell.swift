//
//  CryptoCoinTVCell.swift
//  Swapnil_Task
//
//  Created by Sonkar, Swapnil on 12/01/25.
//

import UIKit

class CryptoCoinTVCell: UITableViewCell {
    
    static let reuseIdentifier = "CryptoCoinTVCell"
    
    private let nameLabel = UILabel()
    private let symbolLabel = UILabel()
    private let typeLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        nameLabel.font = .boldSystemFont(ofSize: 16)
        symbolLabel.font = .systemFont(ofSize: 14)
        symbolLabel.textColor = .gray
        typeLabel.font = .systemFont(ofSize: 14)
        typeLabel.textColor = .blue
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel, symbolLabel, typeLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        contentView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func configure(with coin: CryptoCoin) {
        nameLabel.text = coin.name
        symbolLabel.text = coin.symbol
        typeLabel.text = coin.type
        contentView.alpha = coin.isActive ? 1.0 : 0.5
    }
}
