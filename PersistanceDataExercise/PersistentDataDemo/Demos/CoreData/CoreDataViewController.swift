//
//  CoreDataViewController.swift
//  PersistentDataDemo
//
//  Created by Jorge Benavides on 23/03/23.
//

import UIKit
import Storage
import CoreData

class CoreDataViewController: FormViewController {

    // TODO: Make property wrapper making this property storable
    var user: User?

    let storageManager: StorageManagerProtocol
    init(storageManager: StorageManagerProtocol = StorageManager(storage: CoreData.default)) {
        self.storageManager = storageManager
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "CoreData"
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
