//
//  UsersListTableViewCell.swift
//  TechnicalTask-lvl1
//
//  Created by Сергей Матвеенко on 25.11.24.
//

import UIKit
import SnapKit

final class UsersListTableViewCell: UITableViewCell {
    
    // MARK: - Sizes
    
    private enum Sizes {
        static let headerFontSize: CGFloat = 20.0
        static let regularFontSize: CGFloat = 15.0
        static let stackViewsOffset: CGFloat = 15.0
        static let stackViewsSpacing: CGFloat = 10.0
        static let underlyingViewHeightInset: CGFloat = 2
        static let underlyingViewCornerRadius: CGFloat = 15.0
        static let userEmailWidthCoeff: ConstraintMultiplierTarget = 0.4
        static let userDetailsWidthCoeff: ConstraintMultiplierTarget = 1.8
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
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.text = UsersListCellStrings.addressLabelTitle
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
        stackView.spacing = Sizes.stackViewsSpacing
        return stackView
    }()
    
    private lazy var underlyingView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.layer.cornerRadius = Sizes.underlyingViewCornerRadius
        view.layer.borderWidth = 2
        return view
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
        self.contentView.addSubview(self.underlyingView)
        self.underlyingView.addSubview(self.userDetailsStackView)
        self.underlyingView.addSubview(self.userAddressStackView)
    }
    
    // MARK: - Set constraints
    
    func setConstraints() {
        self.underlyingView.frame = self.contentView.bounds.insetBy(dx: 0, dy: Sizes.underlyingViewHeightInset)
        
        self.userDetailsStackView.snp.makeConstraints {
            $0.left.top.bottom.height.equalToSuperview().inset(UsersListEdgeInsets.cellStackView)
            $0.width.equalToSuperview().dividedBy(Sizes.userDetailsWidthCoeff)
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
        
        self.contentView.alpha = 0
        
        if user.isAnimatingNeeded {
            UIView.animate(withDuration: 1) {
                self.contentView.alpha = 1
            }
        } else {
            self.contentView.alpha = 1
        }
    }
}
