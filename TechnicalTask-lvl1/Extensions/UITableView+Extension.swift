//
//  UITableView+Extension.swift
//  TechnicalTask-lvl1
//
//  Created by Сергей Матвеенко on 25.11.24.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T? {
        guard let cell = dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else {
            assertionFailure("unable to dequeue cell with identifier \(T.identifier)")
            return nil
        }

        return cell
    }

    func registerWithXib(cellClasses: UITableViewCell.Type...) {
        cellClasses.forEach {
            let nib = UINib(nibName: $0.identifier, bundle: nil)
            register(nib, forCellReuseIdentifier: $0.identifier)
        }
    }

    func register(cellClasses: UITableViewCell.Type...) {
        cellClasses.forEach {
            register($0.self, forCellReuseIdentifier: $0.identifier)
        }
    }
}
