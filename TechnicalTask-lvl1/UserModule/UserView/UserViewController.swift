//

import UIKit
import SnapKit
import Combine

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
    
    // MARK: - Parameters
    
    private var viewModel: UserViewModelProtocol
    private var cancellables: Set<AnyCancellable> = []
    
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
        customView.textField.textColor = .red
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
    
    // MARK: - Initialization
    
    init(viewModel: UserViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.binding()
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
        self.viewModel.saveUserInfoButtonTapped()
    }
    
    func handleSaveUserInfoButtonTapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - Binding

private extension UserViewController {
    func binding() {
        self.bindInput()
        self.bindOutput()
    }
    
    func bindInput() {
        self.viewModel.anySaveUserInfoButtonTappedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.handleSaveUserInfoButtonTapped()
            }
            .store(in: &self.cancellables)

        self.userNameInputView.textField.publisher()
            .merge(
                with: self.userEmailInputView.textField.publisher(),
                self.cityNameInputView.textField.publisher(),
                self.streetNameInputView.textField.publisher()
            )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] textField in
            guard let self, let text = textField.text else { return }
            
            switch textField {
            case self.userNameInputView.textField:
                self.viewModel.userNameUpdated(text)
            case self.userEmailInputView.textField:
                self.viewModel.userEmailUpdated(text)
            case self.cityNameInputView.textField:
                self.viewModel.cityNameUpdated(text)
            case self.streetNameInputView.textField:
                self.viewModel.streetNameUpdated(text)
            default: break
            }
        }
        .store(in: &self.cancellables)
    }
    
    func bindOutput() {
        self.viewModel.anyEmailTextFieldColorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] textColor in
                guard let self else { return }
                self.userEmailInputView.textField.textColor = textColor
            }
            .store(in: &self.cancellables)
    }
}
