//
//  FileManagerViewController.swift
//  PersistentDataDemo
//
//  Created by Jorge Benavides on 23/03/23.
//

import UIKit
import Storage

class FileManagerViewController: FormViewController {

    // TODO: Make property wrapper making this property storable
    var user: User?

    let storageManager: StorageManagerProtocol
    init(storageManager: StorageManagerProtocol = StorageManager(storage: FileManager.default)) {
        self.storageManager = storageManager
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "FileManager"
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .trash, target: self, action: #selector(trashButtonPressed))
    }

    @objc func trashButtonPressed() {
        storageManager.purge()
    }

    override func writeData() {
        user = writeFormView.getData

        storageManager.store(user, forKey: .userModel)
    }

    override func readData() {
        user = storageManager.retrieve(forKey: .userModel)

        readFormView.setData(user)
    }

}
