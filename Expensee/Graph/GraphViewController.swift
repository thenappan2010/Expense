//
//  GraphViewController.swift
//  Expensee
//
//  Created by temp on 03/03/21.
//

import UIKit
import Charts

class GraphViewController: UIViewController {

    @IBOutlet weak var piechart: PieChartView!
    
    var dict : [String:Int32] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var dataEntries: [ChartDataEntry] = []
        let byValue = {
            (elem1:(key: String, val: Int32), elem2:(key: String, val: Int32))->Bool in
            if elem1.val > elem2.val {
                return true
            } else {
                return false
            }
        }
        let sortedDict = dict.sorted(by: byValue)
        
        
        for (category,amount) in sortedDict.prefix(3)
        {
            print("category \(String(describing: category))   : amount \(amount)")
            let dataEntry = PieChartDataEntry(value: Double(amount), label:category, data: category as AnyObject)
            dataEntries.append(dataEntry)
            
        }
        
        let others = sortedDict.suffix(from: 3)
        
        let dict2 = Dictionary(uniqueKeysWithValues: others.map{ ($0.key, $0.value) })
        let val = dict2.values.reduce(0, +)
        
        let dataEntry = PieChartDataEntry(value: Double(val), label:"Others", data: "Others" as AnyObject)
        dataEntries.append(dataEntry)
        
        
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        pieChartDataSet.xValuePosition = .outsideSlice
        pieChartDataSet.yValuePosition = .outsideSlice
        
       
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1.0
        piechart.data?.setValueFormatter(formatter as! IValueFormatter)
        
        pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataEntries.count)
        let pieChartData = PieChartData(dataSet: pieChartDataSet)

        piechart.data = pieChartData
        piechart.drawEntryLabelsEnabled = false
        
       
    }
    
    func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
      var colors: [UIColor] = []
      for _ in 0..<numbersOfColor {
        let red = Double(arc4random_uniform(256))
        let green = Double(arc4random_uniform(256))
        let blue = Double(arc4random_uniform(256))
        let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
        colors.append(color)
      }
      return colors
    }
    
}
