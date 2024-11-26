//

import UIKit
import SnapKit

final class UserViewController: UIViewController {
    
    // MARK: - Sizes
    
    private enum Sizes {
        static let userInfoStackOffset: CGFloat = 30.0
        static let userInfoStackSpacing: CGFloat = 10.0
        static let labelFontSize: CGFloat = 20.0
        static let buttonFontSize: CGFloat = 30.0
        static let buttonOffset: CGFloat = 30.0
        static let buttonCornerRadius: CGFloat = 15.0
        static let buttonBorderWidth: CGFloat = 2.0
        static let userInfoStackHeightCoeff: ConstraintMultiplierTarget = 0.6
        static let buttonHeightCoeff: ConstraintMultiplierTarget = 0.08
        static let buttonWidthCoeff: ConstraintMultiplierTarget = 0.5
    }
    
    // MARK: - GUI
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = UserScreenStrings.infoLabelTitle
        label.font = .systemFont(ofSize: Sizes.labelFontSize, weight: .bold)
        return label
    }()
    
    private lazy var userNameInputView: CustomTextFieldWithTitle = {
        let customView = CustomTextFieldWithTitle(title: UserScreenStrings.userNameInputViewTitle)
        return customView
    }()
    
    private lazy var userEmailInputView: CustomTextFieldWithTitle = {
        let customView = CustomTextFieldWithTitle(title: UserScreenStrings.userEmailInputViewTitle)
        return customView
    }()
    
    private lazy var cityNameInputView: CustomTextFieldWithTitle = {
        let customView = CustomTextFieldWithTitle(title: UserScreenStrings.cityNameInputViewTitle)
        return customView
    }()
    
    private lazy var streetNameInputView: CustomTextFieldWithTitle = {
        let customView = CustomTextFieldWithTitle(title: UserScreenStrings.streetNameInputViewTitle)
        return customView
    }()
    
    private lazy var userInfoStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                self.infoLabel,
                self.userNameInputView,
                self.userEmailInputView,
                self.cityNameInputView,
                self.streetNameInputView
            ]
        )
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = Sizes.userInfoStackSpacing
        return stackView
    }()
    
    private lazy var saveUserInfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(UserScreenStrings.saveButtonTitle, for: .normal)
        button.backgroundColor = .lightGray
        button.tintColor = .black
        button.titleLabel?.font = .systemFont(ofSize: Sizes.buttonFontSize, weight: .bold)
        button.clipsToBounds = true
        button.layer.cornerRadius = Sizes.buttonCornerRadius
        button.layer.borderWidth = Sizes.buttonBorderWidth
        button.addTarget(self, action: #selector(self.saveUserInfoButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setConstraints()
    }
}

// MARK: - Layout

private extension UserViewController {
    
    // MARK: - UI setup

    func setupLayout() {
        self.setupView()
        self.setupNavigationBar()
        self.addSubviews()
    }
    
    func setupView() {
        self.view.backgroundColor = Colors.mainBackgroundColor.color
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = UsersListStrings.navTitle
    }
    
    // MARK: - Add subviews
    
    func addSubviews() {
        self.view.addSubview(self.userInfoStackView)
        self.view.addSubview(self.saveUserInfoButton)
    }
    
    // MARK: - Constraints
    
    func setConstraints() {
        self.userInfoStackView.snp.makeConstraints {
            $0.top.equalTo(self.navigationController?.navigationBar.snp.bottom ?? self.view.snp.top).offset(Sizes.userInfoStackOffset)
            $0.left.right.equalToSuperview().inset(UserEdgeInsets.userInfoStackView)
            $0.height.equalToSuperview().multipliedBy(Sizes.userInfoStackHeightCoeff)
        }
        
        self.saveUserInfoButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.userInfoStackView.snp.bottom).offset(Sizes.buttonOffset)
            $0.height.equalToSuperview().multipliedBy(Sizes.buttonHeightCoeff)
            $0.width.equalToSuperview().multipliedBy(Sizes.buttonWidthCoeff)
        }
    }
}

// MARK: - Actions and handlers

private extension UserViewController {
    @objc func saveUserInfoButtonTapped() {
        print("saveUserInfoButtonTapped")
    }
}
