//
//  ViewController.swift
//  Expensee
//
//  Created by temp on 23/02/21.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            let controller = DisplayTransactionListViewController.load(storyboard: "Main", identifier: "DisplayTransactionListViewController")
            self.present(controller, animated: true, completion: nil)
        }
    }
}



extension UIViewController
{
    class func load(storyboard: String,identifier : String) -> Self
    {
        return instantiateFromStoryboardHelper(storyboard,identifier)
    }

    fileprivate class func instantiateFromStoryboardHelper<T>(_ name: String,_ identifier : String) -> T
    {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: identifier) as! T
        return controller
    }
}
