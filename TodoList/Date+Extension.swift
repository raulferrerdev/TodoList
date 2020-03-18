//
//  Date+Extension.swift
//  TodoList
//
//  Created by RaulF on 16/03/2020.
//  Copyright © 2020 ImTech. All rights reserved.
//

import Foundation


extension Date {
    func convertToMonthYearDayFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd,yyyy"
        
        return dateFormatter.string(from: self)
    }
}
