//
//  UserDefaultsViewController.swift
//  PersistentDataDemo
//
//  Created by Jorge Benavides on 24/03/23.
//

import UIKit
import Storage

class UserDefaultsViewController: FormViewController {
    
    var user: User?

    // TODO: 2. Create an initialize that receives an object for storage operations
    let storageObject: StorageProtocol

    init(storageObject: StorageProtocol = UserDefaults.standard) {
        self.storageObject = storageObject
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        title = "User Defaults"
        view.backgroundColor = .white

        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .trash, target: self, action: #selector(trashButtonPressed))
    }

    @objc func trashButtonPressed() {
        do {
            try storageObject.purge()
        } catch {
            print("Can not remove keys")
        }
    }

    // TODO: 3.1 Use the instance `storageObject` of the storage protocol to do 'write' operations
    override func writeData() {
        user = writeFormView.getData

        do {
            try storageObject.set(user?.name, forKey: .userName)
            try storageObject.set(user?.age, forKey: .userAge)
            try storageObject.set(user?.balance, forKey: .userBalance)

            try storageObject.store(user, forKey: .userModel)
        } catch {
            print("Can not store:", error)
        }
    }

    // TODO: 3.2 Use the instance `storageObject` of the storage protocol to do 'read' operations
    override func readData() {
        do {
            user?.name = try storageObject.get(forKey: .userName)
            user?.age = try storageObject.get(forKey: .userAge)
            user?.balance = try storageObject.get(forKey: .userBalance)

            user = try storageObject.retrieve(forKey: .userModel)
        } catch {
            print("Can not store:", error)
        }

        readFormView.setData(user)
    }
}
