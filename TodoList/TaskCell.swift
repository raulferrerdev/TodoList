//
//  TaskCell.swift
//  TodoList
//
//  Created by RaulF on 15/03/2020.
//  Copyright © 2020 ImTech. All rights reserved.
//

import UIKit
import CloudKit

protocol TaskCheckDelegate: class {
    func updateTask(_ record: CKRecord)
}

class TaskCell: UITableViewCell {

    static let reuseID = "TaskCell"
    
    private var record: CKRecord?
    private var taskTitleLabel = UILabel(frame: .zero)
    private var createdAtLabel = UILabel(frame: .zero)
    private var checkedButton = UIButton(frame: .zero)
    private var isChecked: Bool = false
    
    private let uncheckedIcon = UIImage(systemName: "circle")!
    
    private let checkedIcon = UIImage(systemName: "checkmark.circle")!
    weak var delegate: TaskCheckDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func prepareForReuse() {
        self.record = nil
        self.isChecked = false
    }

    
    private func configure() {
        selectionStyle = .none
        
        configureTitleLabel()
        configureCreatedAtLabel()
        configureCheckedButton()
        layoutUI()
    }
    
    
    func set(record: CKRecord) {
        self.record = record
        
        taskTitleLabel.text = record.object(forKey: "title") as? String ?? ""
        if let createdDate = record.object(forKey: "createdAt") as? Date {
            createdAtLabel.text = createdDate.convertToMonthYearDayFormat()
        } else {
            createdAtLabel.text = ""
        }
        
        if let checked = record.object(forKey: "checked") as? Int64 {
            self.isChecked = checked == 0 ? false : true
            checkedButton.setBackgroundImage(self.isChecked ? checkedIcon : uncheckedIcon, for: .normal)
        } else {
            self.isChecked = false
            checkedButton.setBackgroundImage(uncheckedIcon, for: .normal)
        }
    }
    
    
    private func configureTitleLabel() {
        taskTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        taskTitleLabel.font = .systemFont(ofSize: 16)
        taskTitleLabel.textColor = .systemGray2
        taskTitleLabel.textAlignment = .left
        taskTitleLabel.numberOfLines = 3
        taskTitleLabel.lineBreakMode = .byTruncatingTail
    }
    
    
    private func configureCreatedAtLabel() {
        createdAtLabel.translatesAutoresizingMaskIntoConstraints = false
        createdAtLabel.font = .systemFont(ofSize: 12)
        createdAtLabel.textColor = .systemGray3
        createdAtLabel.textAlignment = .left
        createdAtLabel.numberOfLines = 1
    }
    
    
    private func configureCheckedButton() {
        checkedButton.translatesAutoresizingMaskIntoConstraints = false
        checkedButton.setBackgroundImage(uncheckedIcon, for: .normal)
        checkedButton.tintColor = .systemGray
        checkedButton.addTarget(self, action: #selector(toggleChecked), for: .touchUpInside)
    }
    
    
    private func layoutUI() {
        contentView.addSubview(taskTitleLabel)
        contentView.addSubview(createdAtLabel)
        contentView.addSubview(checkedButton)
        
        NSLayoutConstraint.activate([
            checkedButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkedButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            checkedButton.heightAnchor.constraint(equalToConstant: 20),
            checkedButton.widthAnchor.constraint(equalToConstant: 20),
            
            taskTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            taskTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            taskTitleLabel.trailingAnchor.constraint(equalTo: checkedButton.leadingAnchor, constant: -10),
            taskTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),

            createdAtLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            createdAtLabel.trailingAnchor.constraint(equalTo: checkedButton.leadingAnchor, constant: 10),
            createdAtLabel.topAnchor.constraint(equalTo: taskTitleLabel.bottomAnchor, constant: 5)
        ])
        
        taskTitleLabel.setContentHuggingPriority(.required, for: .vertical)
    }
    
    
    @objc private func toggleChecked() {
        guard let record = record else { return }
        isChecked.toggle()
        checkedButton.setBackgroundImage(isChecked ? checkedIcon : uncheckedIcon, for: .normal)
        checkedButton.tintColor = isChecked ? .systemGreen : .systemGray
        let value = Int64(isChecked ? 1 : 0)
        record.setObject(value as __CKRecordObjCValue, forKey: "checked")
        delegate?.updateTask(record)
    }
}
