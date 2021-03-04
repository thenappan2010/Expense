//
//  Categorys.swift
//  Expensee
//
//  Created by temp on 26/02/21.
//

import Foundation


struct category {
    
    static let food = "Food"
    static let shopping = "Shopping"
    static let transport = "Transport"
    static let home = "Home"
    static let entertainment = "Entertainmet"
    static let groceries = "Groceries"
    static let ottPlatform = "Ott Platform"
    static let gifts = "Gifts"
    static let rent = "Rent"
    static let family = "Family"
    static let dress = "Dress"
    static let electricity = "Electricity"
    
    
    static let dict = [category.entertainment :categoryIcon.entertainment,
                       category.dress : categoryIcon.cloth,
                       category.electricity:categoryIcon.electricity,
                       category.food : categoryIcon.food,
                       category.shopping : categoryIcon.shopping,
                       category.transport : categoryIcon.travel,
                       category.groceries : categoryIcon.groceries,
                       category.gifts : categoryIcon.gift,
                       category.rent : categoryIcon.mortgage,
                       category.ottPlatform : categoryIcon.movie,
                ]
    
    
    static func getAllCategorys() -> [String] {
        
        let arr:[String] = [category.food,
                            category.shopping,
                            category.transport,
                            category.entertainment,
                            category.groceries,
                            category.ottPlatform,
                            category.gifts,
                            category.rent,
                            category.electricity,
                            category.dress]
        return arr
    }
    
    
    static func getImageForCategory(category : String) -> String?
    {
       return dict[category]
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
    
    case monthIncome
    case monthExpense
    
    case all
    case month
    
}
