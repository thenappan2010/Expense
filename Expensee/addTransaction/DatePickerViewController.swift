//
//  DatePickerViewController.swift
//  Expensee
//
//  Created by temp on 27/02/21.
//

import UIKit

class DatePickerViewController: UIViewController {
    
    @IBOutlet weak var datepicker: UIDatePicker!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var applyBtn: UIButton!
    
    
    var seletedDate : Date?
    var dateCallBack : ((Date)->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        datepicker.timeZone = TimeZone.current
        datepicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)

    }
    
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        seletedDate = sender.date
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func applyAction(_ sender: Any) {
        dateCallBack?(seletedDate ?? Date())
        self.dismiss(animated: true, completion: nil)
    }
    

}
