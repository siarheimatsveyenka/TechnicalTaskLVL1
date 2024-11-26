//
//  CustomTextFieldWithTitle.swift
//  TechnicalTask-lvl1
//
//  Created by Сергей Матвеенко on 26.11.24.
//

import UIKit
import SnapKit

final class CustomTextFieldWithTitle: UIView {
    
    // MARK: - Sizes
    
    private enum Sizes {
        static let tfTopOffset: CGFloat = 10.0
        static let tfBorderWidth: CGFloat = 2.0
        static let tfCornerRadius: CGFloat = 15.0
        static let tfHeightCoeff: ConstraintMultiplierTarget = 0.5
    }
    
    // MARK: - Parameters
    
    private var title: String

    // MARK: - GUI
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = title
        return label
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.layer.borderWidth = Sizes.tfBorderWidth
        textField.clipsToBounds = true
        textField.layer.cornerRadius = Sizes.tfCornerRadius
        return textField
    }()
    
    // MARK: - Initialization
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout

private extension CustomTextFieldWithTitle {
    
    // MARK: - Configure view
    
    func configure() {
        self.addSubviews()
        self.setConstraints()
    }
    
    // MARK: - Add subviews
    
    func addSubviews() {
        self.addSubview(self.label)
        self.addSubview(self.textField)
    }
    
    // MARK: - Set constraints

    func setConstraints() {
        self.label.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
        }
        
        self.textField.snp.makeConstraints {
            $0.top.equalTo(self.label.snp.bottom).offset(Sizes.tfTopOffset)
            $0.left.right.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(Sizes.tfHeightCoeff)
        }
    }
}
