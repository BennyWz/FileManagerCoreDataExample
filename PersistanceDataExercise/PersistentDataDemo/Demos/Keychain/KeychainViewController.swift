//
//  KeychainViewController.swift
//  PersistentDataDemo
//
//  Created by Jorge Benavides on 23/03/23.
//

import UIKit
import Storage

class KeychainViewController: FormViewController {

    var user: User?

    // TODO: 3. Create an initialize that receives an object managing the storage operations
    let storageManager: StorageManagerProtocol

    init(storageManager: StorageManagerProtocol = StorageManager(storage: Keychain.standard)) {
        self.storageManager = storageManager
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Keychain"
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .trash, target: self, action: #selector(trashButtonPressed))
    }

    // TODO: 4.1 Use the instance `storageManager` to do 'storage' operations
    @objc func trashButtonPressed() {
        storageManager.purge()
    }

    // TODO: 4.2 Use the instance `storageManager` to do 'storage' operations
    override func writeData() {
        user = writeFormView.getData

        storageManager.store(user, forKey: .userModel)
    }

    // TODO: 4.3 Use the instance `storageManager` to do 'storage' operations
    override func readData() {
        user = storageManager.retrieve(forKey: .userModel)

        readFormView.setData(user)
    }

}
