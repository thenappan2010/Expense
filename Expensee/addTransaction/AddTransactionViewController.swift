//
//  AddTransactionViewController.swift
//  Expensee
//
//  Created by temp on 26/02/21.
//

import UIKit



class AddTransactionViewController: UIViewController {

    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var categoryNameTF: UITextField!
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var dateBtn: UIButton!
    
    
    var selectedDate : Date?
    var saveCallBack : ((String,String,String,Date)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        amountTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        categoryNameTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        validateSaveButton()
        // Do any additional setup after loading the view.
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        validateSaveButton()

    }

    @IBAction func dateSelection(_ sender: UIButton) {
        
        let controller = DatePickerViewController.load(storyboard: "Main", identifier: "DatePickerViewController")
        controller.dateCallBack = { (date) in
            self.selectedDate = date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MMM-YYYY HH:mm"
            self.dateBtn.setTitle(dateFormatter.string(from: date), for: .normal)
            
        }
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func saveAction(_ sender: UIButton) {
        
        saveCallBack?(self.categoryNameTF.text ?? "",self.amountTF.text ?? "",(segment.selectedSegmentIndex == 1 ? TransactionType.income  :TransactionType.expense),selectedDate ?? Date())
        self.dismiss(animated: true, completion: nil)
    }
    
    func validateSaveButton()
    {
        let categoryCondition = categoryNameTF.text?.isEmpty == false
        let amountCondition = amountTF.text?.isEmpty == false && (Int32(amountTF.text!) != nil)
        
        saveBtn.isEnabled = (categoryCondition && amountCondition)
        
        
    }
    
}
