//
//  Categorys.swift
//  Expensee
//
//  Created by temp on 26/02/21.
//

import Foundation


struct category {
    
    static let food = "FOOD"
    static let shopping = "SHOPPING"
    static let transport = "TRANSPORT"
    static let home = "HOME"
    static let entertainment = "ENTERTAINMENT"
    static let groceries = "GROCERIES"
    static let ottPlatform = "OTTPLATFORM"
    static let gifts = "GIFTS"
    static let rent = "RENT"
    static let family = "FAMILY"
    
    
    func getAllCategorys() -> [String] {
        
        let arr:[String] = [category.food,
                            category.shopping,
                            category.transport,
                            category.home,
                            category.entertainment,
                            category.groceries,
                            category.ottPlatform,
                            category.gifts,
                            category.rent,
                            category.family]
        return arr
    }
    
}


struct TransactionType {
    static let income = "INCOME"
    static let expense = "EXPENSE"
}



enum transactionDisplayType
{
    case onlyIncome
    case onlyExpense
    case all
}
