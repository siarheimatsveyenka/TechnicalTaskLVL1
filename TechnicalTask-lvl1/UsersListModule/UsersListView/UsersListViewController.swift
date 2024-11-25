//
//  UsersListViewController.swift
//  TechnicalTask-lvl1
//
//  Created by Сергей Матвеенко on 25.11.24.
//

import UIKit

final class UsersListViewController: UIViewController {
    
    // MARK: - Parameters
    
    private var viewModel: UsersListViewModelProtocol
    
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

        self.view.backgroundColor = Asset.Colors.mainBackgroundColor.color
    }
}
