//
//  ViewController.swift
//  TodoList
//
//  Created by RaulF on 14/03/2020.
//  Copyright © 2020 ImTech. All rights reserved.
//

import UIKit
import CloudKit

class ViewController: UIViewController {
    
    private var tableView: TasksTableViewController!
    private let manager = CloudKitManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Tasks"

        configureTableView()
        configureAddButton()
        layoutUI()
        fetchRecords()
    }
    
    
    private func configureTableView() {
        tableView = TasksTableViewController(manager: manager)
    }
    
    
    private func configureAddButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
        navigationItem.rightBarButtonItems = [addButton]
    }
    
    
    @objc private func addTask() {
        let controller = AddTaskController(manager: manager)
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: false)
    }
    
    
    private func layoutUI() {
        view.addSubview(tableView.view)
        
        NSLayoutConstraint.activate([
            tableView.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.view.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    
    private func fetchRecords() {
        manager.fetchTasks(completion: { (records, error) in
            guard error == .none, let records = records else {
                // Deal with error
                return
            }
            
            DispatchQueue.main.async {
                self.tableView.set(tasks: records)
            }
        })
    }
}


extension ViewController: TasksDelegate {
    func addedTask(_ task: CKRecord?, error: FetchError) {
        guard error == .none, let task = task else {
            // Deal with error
            return
        }
        DispatchQueue.main.async {
            self.tableView.add(task: task)
        }
    }
}

