//
//  HistoryDataViewController.swift
//  Physao
//
//  Created by Weiqi Wei on 15/11/17.
//  Copyright © 2015年 Physaologists. All rights reserved.
//

import UIKit

class HistoryDataViewController: UIViewController {
    
    @IBOutlet weak var lineChart: LineChartView!
    
    @IBOutlet weak var ChooseType: UISegmentedControl!
    
    
    var months:[String]!
    var dateArray:[String] = []
    var fvc:[Double] = []
    var fev1:[Double] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        ChooseType.selectedSegmentIndex = 0
        //months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        //let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
        
        //setChart(months, values: unitsSold)
        
        let date = NSDate()
        let formatter = NSDateFormatter()
        let dateFormat = NSDateFormatter.dateFormatFromTemplate("MMddyyyy", options: 0, locale: NSLocale(localeIdentifier: "en-US"))
        //gbDateFormat now contains an optional string "dd/MM/yyyy"
        formatter.dateFormat = dateFormat
        let dateString = formatter.stringFromDate(date)
        
        print(dateString)
        
        (dateArray, fvc, fev1) = UserInfoManager.getInstance().getAllDate()
        
        print(fvc.count)
        print(dateArray.count)
        setChart(dateArray, values: fvc)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ChangeGraph(sender: AnyObject) {
        if(sender.selectedSegmentIndex == 0){
            setChart(dateArray, values: fvc)
        }
        else if(sender.selectedSegmentIndex == 1){
            setChart(dateArray, values: fev1)
        }
        
    }
    

    func setChart(dataPoints: [String], values: [Double]) {
        lineChart.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(yVals: dataEntries, label: "amount of air")
        let chartData = LineChartData(xVals: dataPoints, dataSet: chartDataSet)
        lineChart.rightAxis.enabled = false
        lineChart.descriptionText = ""
        lineChart.data = chartData
        lineChart.xAxis.labelPosition = .Bottom
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
