//
//  MenuController.swift
//  PersistentDataDemo
//
//  Created by Jorge Benavides on 23/03/23.
//

import UIKit
import Storage

class MenuController: UITableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            push(UserDefaultsViewController())
        case 1:
            push(KeychainViewController())
        case 2:
            push(FileManagerViewController())
        case 3:
            push(CoreDataViewController())
        default:
            break
        }
    }

    private func push(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension StorageKey {
    static let userName = StorageKey(rawValue: "kUserName")
    static let userAge = StorageKey(rawValue: "kUserAge")
    static let userBalance = StorageKey(rawValue: "kUserBalance")
    static let userModel = StorageKey(rawValue: "kUserModel")
}
