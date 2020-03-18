//
//  TasksTableViewController.swift
//  TodoList
//
//  Created by RaulF on 15/03/2020.
//  Copyright © 2020 ImTech. All rights reserved.
//

import UIKit
import CloudKit

class TasksTableViewController: UITableViewController {
    
    private var tasks = [CKRecord]()
    private var manager: CloudKitManager!

    init(manager: CloudKitManager) {
        super.init(style: .plain)
        
        self.manager = manager
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
    }
    
    
    private func configureTableView() {
        tableView.backgroundColor = .white
        tableView.separatorStyle = .singleLine
        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.reuseID)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 72
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.contentInsetAdjustmentBehavior = .never
    }
    
    func set(tasks: [CKRecord]) {
        self.tasks = tasks
        tableView.reloadData()
    }
    
    
    func add(task: CKRecord) {
        self.tasks.insert(task, at: 0)
        tableView.reloadData()
    }
}


// MARK: - Table view data source
extension TasksTableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.reuseID, for: indexPath) as! TaskCell
        cell.set(record: tasks[indexPath.row])
        cell.delegate = self
        
        return cell
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            manager.deleteRecord(record: tasks[indexPath.row], completionHandler: { error in
                guard error == .none else {
                    // Deal with error
                    return
                }
                
                self.tasks.remove(at: indexPath.row)
                
                DispatchQueue.main.async {
                    self.tableView.deleteRows(at: [indexPath], with: .right)
                }
            })
        }
    }
}

extension TasksTableViewController: TaskCheckDelegate {
    func updateTask(_ record: CKRecord) {
        manager.updateTask(record, completionHandler: { (record, error) in
          // Deal with error if there is one
        })
    }
}
