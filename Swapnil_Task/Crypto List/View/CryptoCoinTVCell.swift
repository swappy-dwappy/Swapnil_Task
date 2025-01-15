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
    private let typeImageView = UIImageView()
    private let typeIsNewImageView = UIImageView(image: .new)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.selectionStyle = .none
        nameLabel.textColor = .gray
        nameLabel.font = .systemFont(ofSize: 16)
        symbolLabel.font = .boldSystemFont(ofSize: 16)
        typeImageView.contentMode = .scaleAspectFit
        typeIsNewImageView.contentMode = .scaleAspectFit
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(symbolLabel)
        contentView.addSubview(typeIsNewImageView)
        contentView.addSubview(typeImageView)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        symbolLabel.translatesAutoresizingMaskIntoConstraints = false
        typeImageView.translatesAutoresizingMaskIntoConstraints = false
        typeIsNewImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            symbolLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            symbolLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            symbolLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
            
            typeIsNewImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            typeIsNewImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            typeIsNewImageView.widthAnchor.constraint(equalToConstant: 32),
            typeIsNewImageView.heightAnchor.constraint(equalToConstant: 32),
            
            typeImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            typeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            typeImageView.widthAnchor.constraint(equalToConstant: 32),
            typeImageView.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    func configure(with cryptoCoin: CryptoCoin) {
        nameLabel.text = cryptoCoin.name
        symbolLabel.text = cryptoCoin.symbol
        typeIsNewImageView.isHidden = !cryptoCoin.isNew
        setTypeImageView(cryptoCoin)
    }
    
    private func setTypeImageView(_ cryptoCoin: CryptoCoin) {
        if cryptoCoin.type == .coin, cryptoCoin.isActive {
            typeImageView.image = .activeCoin
        } else if cryptoCoin.type == .token, cryptoCoin.isActive {
            typeImageView.image = .activeToken
        } else if cryptoCoin.isActive == false {
            typeImageView.image = .inactive
        }
    }
}
