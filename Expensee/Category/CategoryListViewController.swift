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
    var selectedCategory : String?
    var categoryList = category.getAllCategorys()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoryTableViewCell")
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
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as! CategoryTableViewCell
        cell.categoryName.text =  categoryList[indexPath.item]
        if let imageName = category.getImageForCategory(category: categoryList[indexPath.item])
        {
            cell.categoryImage.image = UIImage(named: imageName)!
        }else
        {
            cell.categoryImage.image = UIImage(systemName: "megaphone.fill")
        }
        if selectedCategory == categoryList[indexPath.item]
        {
            cell.accessoryType = .checkmark
        }else
        {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        categorySelectionCallBack?(categoryList[indexPath.item])
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
