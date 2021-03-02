//
//  CategoryListViewController.swift
//  Expensee
//
//  Created by temp on 27/02/21.
//

import UIKit

class CategoryListViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    var categorySelectionCallBack : ((String)->Void)?
    var categoryList = category.getAllCategorys()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate = self
        tableview.dataSource = self
       
    }
}


extension CategoryListViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text =  categoryList[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        categorySelectionCallBack?(categoryList[indexPath.item])
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
