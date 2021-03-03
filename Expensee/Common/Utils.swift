//
//  Utils.swift
//  Expensee
//
//  Created by temp on 02/03/21.
//

import Foundation


class Utils: NSObject {
    
    static let shared = Utils()
    
    
    func convertDateToString(date : Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-YYYY HH:mm"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date)
    }
}
