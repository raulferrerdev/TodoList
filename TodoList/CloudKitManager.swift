//
//  CloudKitManager.swift
//  TodoList
//
//  Created by RaulF on 16/03/2020.
//  Copyright © 2020 ImTech. All rights reserved.
//

import Foundation
import CloudKit

enum FetchError {
    case addingError, fetchingError, deletingError, noRecords, none
}

struct CloudKitManager {
    
    private let RecordType = "Task"
    
    func fetchTasks(completion: @escaping ([CKRecord]?, FetchError) -> Void) {
        let container = CKContainer(identifier: "iCloud.com.vicensvives.todolist").publicCloudDatabase
        let query = CKQuery(recordType: RecordType, predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        container.perform(query, inZoneWith: CKRecordZone.default().zoneID, completionHandler: { (records, error) -> Void in
            self.processQueryResponseWith(records: records, error: error as NSError?, completion: { fetchedRecords, fetchError in
                completion(fetchedRecords, fetchError)
            })
        })
    }
    
    
    private func processQueryResponseWith(records: [CKRecord]?, error: NSError?, completion: @escaping ([CKRecord]?, FetchError) -> Void) {
        guard error == nil else {
            completion(nil, .fetchingError)
            return
        }
        
        guard let records = records, records.count > 0 else {
            completion(nil, .noRecords)
            return
        }
        
        completion(records, .none)
    }
    
    
    func deleteRecord(record: CKRecord, completionHandler: @escaping (FetchError) -> Void) {
        let publicDatabase = CKContainer(identifier: "iCloud.com.vicensvives.todolist").publicCloudDatabase
        publicDatabase.delete(withRecordID: record.recordID) { (recordID, error) -> Void in
            guard let _ = error else {
                completionHandler(.none)
                return
            }
            
            completionHandler(.deletingError)
        }
    }
    
    
    func addTask(_ task: String, completionHandler: @escaping (CKRecord?, FetchError) -> Void) {
        let publicDatabase = CKContainer(identifier: "iCloud.com.vicensvives.todolist").publicCloudDatabase
        let record = CKRecord(recordType: RecordType)
        
        record.setObject(task as __CKRecordObjCValue, forKey: "title")
        record.setObject(Date() as __CKRecordObjCValue, forKey: "createdAt")
        record.setObject(0 as __CKRecordObjCValue, forKey: "checked")
        
        publicDatabase.save(record, completionHandler: { (record, error) in
            guard let _ = error else {
                completionHandler(record, .none)
                return
            }
            
            completionHandler(nil, .addingError)
        })
    }
    
    
    func updateTask(_ task: CKRecord, completionHandler: @escaping (CKRecord?, FetchError) -> Void) {
        let publicDatabase = CKContainer(identifier: "iCloud.com.vicensvives.todolist").publicCloudDatabase
        
        publicDatabase.save(task, completionHandler: { (record, error) in
            guard let _ = error else {
                completionHandler(record, .none)
                return
            }
            
            completionHandler(nil, .addingError)
        })
    }
}
