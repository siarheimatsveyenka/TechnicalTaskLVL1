//
//  UsersListViewController.swift
//  TechnicalTask-lvl1
//
//  Created by Сергей Матвеенко on 25.11.24.
//

import UIKit
import SnapKit
import Combine

final class UsersListViewController: UIViewController {
    
    // MARK: - Sizes
    
    private enum Sizes {
        static let cellTextOffset: CGFloat = 10.0
    }
    
    // MARK: - Parameters
    
    private var viewModel: UsersListViewModelProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - GUI
    
    private lazy var startingLoaderView: UIActivityIndicatorView = {
        let spinnerView = UIActivityIndicatorView(style: .medium)
        spinnerView.color = .red
        spinnerView.center = self.view.center
        spinnerView.hidesWhenStopped = true
        return spinnerView
    }()
    
    private lazy var usersListTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.register(cellClasses: UsersListTableViewCell.self)
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    // MARK: - Initialization
    
    init(viewModel: UsersListViewModelProtocol) {
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
        self.viewModel.readyToDisplay()
    }
}

// MARK: - Layout

private extension UsersListViewController {
    
    // MARK: - UI setup
    
    func setupLayout() {
        self.setupView()
        self.setupNavigationBar()
        self.addSubviews()
        self.setConstraints()
    }
    
    func setupView() {
        self.view.backgroundColor = Colors.mainBackgroundColor.color
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = UsersListStrings.navTitle
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(self.addButtonTapped)
        )
    }
    
    // MARK: - Add subviews

    func addSubviews() {
        self.view.addSubview(self.usersListTableView)
        self.view.addSubview(self.startingLoaderView)
    }
    
    // MARK: - Constraints
    
    func setConstraints() {
        self.usersListTableView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UsersListEdgeInsets.usersList)
        }
    }
}

// MARK: - Binding

private extension UsersListViewController {
    func binding() {
        self.bindInput()
        self.bindOutput()
    }
    
    func bindInput() {
        self.viewModel.anyAddButtonTappedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.handleAddButtonTapped()
            }
            .store(in: &self.cancellables)
    }
    
    func bindOutput() {
        self.viewModel.anyLoaderIsActivePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isOn in
                guard let self else { return }
                self.handleLoaderAnimating(for: isOn)
            }
            .store(in: &self.cancellables)
    }
}

// MARK: - Actions and handlers

private extension UsersListViewController {
    @objc func addButtonTapped() {
        self.viewModel.addButtonTapped()
    }
    
    func handleAddButtonTapped() {
        let userViewModel = UserViewModel()
        let userViewController = UserViewController(viewModel: userViewModel)
        
        userViewModel.userInfoClosure = { [weak self] userInfo in
            guard let self else { return }
            self.viewModel.handleAddedManuallyUserInfo(userInfo)
        }
        
        self.navigationController?.pushViewController(userViewController, animated: true)
    }
    
    func handleLoaderAnimating(for isOn: Bool) {
        isOn
        ? self.startingLoaderView.startAnimating()
        : self.startingLoaderView.stopAnimating()
    }
    
    
}

// MARK: - UITableViewDataSource

extension UsersListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        UsersListStrings.tableViewTitle
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.displayData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: UsersListTableViewCell = tableView.dequeueReusableCell(for: indexPath) else { return UITableViewCell() }
        let user = self.viewModel.displayData[indexPath.row]
        cell.setCellDisplayData(user)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.usersListTableView.beginUpdates()
            self.viewModel.displayData.remove(at: indexPath.row)
            self.usersListTableView.deleteRows(at: [indexPath], with: .fade)
            self.usersListTableView.endUpdates()
        }
    }
}

// MARK: - UITableViewDelegate

extension UsersListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let userData = self.viewModel.displayData[indexPath.row]
        let addressHeaderTextHeight: CGFloat = UsersListCellStrings.addressLabelTitle.heightForText(isBold: true) + (Sizes.cellTextOffset * 2)
        let cityNameTextHeight: CGFloat = userData.city.heightForText() + Sizes.cellTextOffset
        let streetNameTextHeight: CGFloat = userData.street.heightForText() + Sizes.cellTextOffset
        let totalHeight = addressHeaderTextHeight + cityNameTextHeight + streetNameTextHeight
        return totalHeight
    }
}
