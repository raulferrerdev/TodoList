//
//  AddTaskController.swift
//  TodoList
//
//  Created by RaulF on 17/03/2020.
//  Copyright © 2020 ImTech. All rights reserved.
//

import UIKit
import CloudKit

protocol TasksDelegate: class {
    func addedTask(_ task: CKRecord?, error: FetchError)
}

class AddTaskController: UIViewController {
    
    private let textField = UITextField(frame: .zero)
    private let addButton = UIButton(frame: .zero)
    
    private var manager: CloudKitManager!
    
    weak var delegate: TasksDelegate?
    
    init(manager: CloudKitManager) {
        super.init(nibName: nil, bundle: nil)
        
        self.manager = manager
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        configureTextField()
        configureAddButton()
        layoutUI()
    }
    
    
    private func configureTextField() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Add a task"
        textField.borderStyle = UITextField.BorderStyle.line
        textField.textColor = .systemGray2
        textField.font = .systemFont(ofSize: 16)
        textField.contentVerticalAlignment = .top
    }
    
    
    private func configureAddButton() {
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setTitle("Add task", for: .normal)
        addButton.setTitleColor(.systemTeal, for: .normal)
        addButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        addButton.addTarget(self, action: #selector(addTask), for: .touchUpInside)
    }
    
    
    private func layoutUI() {
        view.addSubview(textField)
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            textField.heightAnchor.constraint(equalToConstant: 300),
            
            addButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 40),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 200),
            addButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    @objc private func addTask() {
        guard let task = textField.text, !task.isEmpty else {
            delegate?.addedTask(nil, error: .addingError)
            self.navigationController?.popViewController(animated: false)
            return
        }
        
        manager.addTask(task, completionHandler: { (record, error) in
            self.delegate?.addedTask(record, error: .none)
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: false)
            }
            return
        })
    }
}
