//
//  UsersListTableViewCell.swift
//  TechnicalTask-lvl1
//
//  Created by Сергей Матвеенко on 25.11.24.
//

import UIKit

final class UsersListTableViewCell: UITableViewCell {
    
    // MARK: - Sizes
    
    private enum Sizes {
        static let headerFontSize: CGFloat = 20
        static let regularFontSize: CGFloat = 15
        static let stackViewsOffset: CGFloat = 15
    }
    
    // MARK: - GUI

    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Sizes.headerFontSize, weight: .heavy)
        return label
    }()
    
    private lazy var userEmailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Sizes.regularFontSize)
        return label
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.text = "Address:"
        label.font = .systemFont(ofSize: Sizes.regularFontSize, weight: .bold)
        return label
    }()
    
    private lazy var cityNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Sizes.regularFontSize)
        return label
    }()
    
    private lazy var streetNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Sizes.regularFontSize)
        return label
    }()
    
    private lazy var userDetailsStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                self.userNameLabel,
                self.userEmailLabel,
            ]
        )
        
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private lazy var userAddressStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                self.addressLabel,
                self.cityNameLabel,
                self.streetNameLabel
            ]
        )
        
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.userNameLabel.text = nil
        self.userEmailLabel.text = nil
        self.cityNameLabel.text = nil
        self.streetNameLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setupLayout()
    }
}

// MARK: - Layout

private extension UsersListTableViewCell {
    func setupLayout() {
        self.backgroundColor = .clear
        
        self.addSubViews()
        self.setConstraints()
    }
    
    // MARK: - Add subviews

    func addSubViews() {
        self.contentView.addSubview(self.userDetailsStackView)
        self.contentView.addSubview(self.userAddressStackView)
    }
    
    // MARK: - Set constraints
    
    func setConstraints() {
        self.userEmailLabel.snp.makeConstraints {
            if let neededWidth = self.userEmailLabel.text?.widthForText() {
                $0.width.equalTo(neededWidth)
            } else {
                $0.width.equalToSuperview().dividedBy(2.5)
            }
        }
        
        self.userDetailsStackView.snp.makeConstraints {
            $0.left.top.bottom.height.equalToSuperview().inset(UsersListEdgeInsets.cellStackView)
            $0.width.equalTo(self.userEmailLabel.snp.width)
        }
        
        self.userAddressStackView.snp.makeConstraints {
            $0.right.top.bottom.height.equalToSuperview().inset(UsersListEdgeInsets.cellStackView)
            $0.left.equalTo(self.userDetailsStackView.snp.right).offset(Sizes.stackViewsOffset)
        }
    }
}

// MARK: - Set cell display data

extension UsersListTableViewCell {
    func setCellDisplayData(_ user: UsersListDiplayModel) {
        self.userNameLabel.text = user.username
        self.userEmailLabel.text = user.email
        self.cityNameLabel.text = user.city
        self.streetNameLabel.text = user.street
    }
}
