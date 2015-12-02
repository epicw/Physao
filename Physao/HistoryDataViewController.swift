//
//  HistoryDataViewController.swift
//  Physao
//
//  Created by Weiqi Wei on 15/11/17.
//  Copyright © 2015年 Physaologists. All rights reserved.
//

import UIKit
import Charts

var monthInfo:[Int: Int] = [1:31, 2:28, 3:31, 4:30, 5:31, 6:30, 7:31, 8:31, 9:30, 10:31, 11:30, 12:31]

class HistoryDataViewController: UIViewController {
    
    @IBOutlet weak var lineChart: LineChartView!

    @IBOutlet weak var ChooseType: UISegmentedControl!
    
    @IBOutlet weak var ChooseTime: UISegmentedControl!
    
    var days:[String] = []
    var weeks:[String] = []
    var months:[String] = []
    var dateArray:[String] = []
    var fvc:[Double] = []
    var fev1:[Double] = []
    var fvcForDays:[Double] = []
    var fev1ForDays:[Double] = []
    var fvcForWeeks:[Double] = []
    var fev1ForWeeks:[Double] = []
    var fvcForMonths:[Double] = []
    var fev1ForMonths:[Double] = []
    
    var HK_FVC:[PhysaoDataPoint] = [PhysaoDataPoint]()
    var HK_FEV1:[PhysaoDataPoint] = [PhysaoDataPoint]()
    var HK_PEFR:[PhysaoDataPoint] = [PhysaoDataPoint]()
    var HK_Ratio:[PhysaoDataPoint] = [PhysaoDataPoint]()
    
    var HK_dateArray:[NSDate] = [NSDate]()
    var HK_fvcArray:[Double] = [Double]()
    var HK_fev1Array:[Double] = [Double]()
    var HK_pefrArray:[Double] = [Double]()
    var HK_ratioArray:[Double] = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        ChooseType.selectedSegmentIndex = 0
        
        let date = self.getCurrentDate()
        let year = date[date.startIndex.advancedBy(6)...date.startIndex.advancedBy(9)]
        let r: Int = Int(year)! / 4
        if r * 4 == Int(year)!{
            monthInfo[2] = 29
        }
        
        (dateArray, fvc, fev1) = UserInfoManager.getInstance().getAllDate()
        (HK_FVC, HK_FEV1, HK_PEFR, HK_Ratio) = UserInfoManager.getHKData()
        
        (HK_dateArray, HK_fvcArray) = PhysaoDataPoint.splitList(HK_FVC)
        HK_fev1Array = PhysaoDataPoint.extractVals(HK_FEV1)
        HK_pefrArray = PhysaoDataPoint.extractVals(HK_PEFR)
        HK_Ratio = PhysaoQuery.buildRatioList(HK_FEV1, list2: HK_FVC)
        HK_ratioArray = PhysaoDataPoint.extractVals(HK_Ratio)
        
        print(fvc.count)
        print(dateArray.count)
        //setChart(stringArrayFromDateArray(HK_dateArray), values: HK_fvcArray)
       
        //setChart(self.discardYearInfo(dateArray), values: fvc)
        
        let historyDate = UserInfoManager.getInstance().getUserHistoryData("Weiqi Wei")
        
        //var (dates, fvc_Y, fev1_Y) = self.findTargetDataSet(historyDate, mode: 0)
        
        //dates = self.discardYearInfo(dates)
        //setChart(dates, values: fvc_Y)
        //printStringArray(dates, doubleArray1: fvc_Y, doubleArray2: fev1_Y)

        (days, fvcForDays, fev1ForDays) = self.findTargetDataSet(historyDate, mode: 0)
        printStringArray(days, doubleArray1: fvcForDays, doubleArray2: fev1ForDays)
        
        (weeks, fvcForWeeks, fev1ForWeeks) = self.findTargetDataSet(historyDate, mode: 1)
        printStringArray(weeks, doubleArray1: fvcForWeeks, doubleArray2: fev1ForWeeks)

        (months, fvcForMonths, fev1ForMonths) = self.findTargetDataSet(historyDate, mode: 2)
        printStringArray(months, doubleArray1: fvcForMonths, doubleArray2: fev1ForMonths)

        setChart(self.discardYearInfo(days), values: fvcForDays, mode: 0)
    }
    
    func stringArrayFromDateArray(dates:[NSDate]) -> [String] {
        var stringList:[String] = [String]()
        
        for date in dates {
            let formatter = NSDateFormatter()
            let dateFormat = NSDateFormatter.dateFormatFromTemplate("MMddyyyy", options: 0, locale: NSLocale(localeIdentifier: "en-US"))
            //gbDateFormat now contains an optional string "dd/MM/yyyy"
            formatter.dateFormat = dateFormat
            let dateString = formatter.stringFromDate(date)
            stringList.append(dateString)
        }
        
        return stringList
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ChangeGraph(sender: AnyObject) {
        if(sender.selectedSegmentIndex == 0 && ChooseTime.selectedSegmentIndex == 0){
            setChart(self.discardYearInfo(days), values: fvcForDays, mode: 0)
        }
        
        else if(sender.selectedSegmentIndex == 0 && ChooseTime.selectedSegmentIndex == 1){
            setChart(self.discardYearInfo(weeks), values: fvcForWeeks, mode: 1)
        }
            
        else if(sender.selectedSegmentIndex == 0 && ChooseTime.selectedSegmentIndex == 2){
            setChart(self.discardYearInfo(months), values: fvcForMonths, mode: 2)
        }
        
        else if(sender.selectedSegmentIndex == 1 && ChooseTime.selectedSegmentIndex == 0){
            setChart(self.discardYearInfo(days), values: fev1ForDays, mode: 0)
        }
        
        else if(sender.selectedSegmentIndex == 1 && ChooseTime.selectedSegmentIndex == 1){
            setChart(self.discardYearInfo(weeks), values: fev1ForWeeks, mode: 1)
        }
        
        else if(sender.selectedSegmentIndex == 1 && ChooseTime.selectedSegmentIndex == 2){
            setChart(self.discardYearInfo(months), values: fev1ForMonths, mode: 2)
        }
    }
    
    @IBAction func ChangeMode(sender: AnyObject) {
        if(sender.selectedSegmentIndex == 0 && ChooseType.selectedSegmentIndex == 0){
            setChart(self.discardYearInfo(days), values: fvcForDays, mode: 0)
        }
        
        else if(sender.selectedSegmentIndex == 0 && ChooseType.selectedSegmentIndex == 1){
            setChart(self.discardYearInfo(days), values: fev1ForDays, mode: 0)
        }
        
        else if(sender.selectedSegmentIndex == 1 && ChooseType.selectedSegmentIndex == 0){
            setChart(self.discardYearInfo(weeks), values: fvcForWeeks, mode: 1)
            //print(fvcForWeeks[fvcForWeeks.count - 1])
        }
        
        else if(sender.selectedSegmentIndex == 1 && ChooseType.selectedSegmentIndex == 1){
            setChart(self.discardYearInfo(weeks), values: fev1ForWeeks, mode: 1)
        }
        
        else if(sender.selectedSegmentIndex == 2 && ChooseType.selectedSegmentIndex == 0){
            setChart(self.discardYearInfo(months), values: fvcForMonths, mode: 2)
            //print(fvcForMonths[fvcForMonths.count - 1])
        }
        
        else if(sender.selectedSegmentIndex == 2 && ChooseType.selectedSegmentIndex == 1){
            setChart(self.discardYearInfo(months), values: fev1ForMonths, mode: 2)
        }
    }
    
    func setChart(dataPoints: [String], values: [Double], mode: Int) {
        lineChart.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        let chartDataSet = LineChartDataSet(yVals: dataEntries, label: "amount of air")
        chartDataSet.drawCubicEnabled = true
        chartDataSet.lineWidth = 2
        
        if mode == 0{
            chartDataSet.drawCirclesEnabled = true
            chartDataSet.drawValuesEnabled = true
        }
        else if mode == 1 || mode == 2{
            chartDataSet.drawCirclesEnabled = false
            chartDataSet.drawValuesEnabled = false
        }
        let chartData = LineChartData(xVals: dataPoints, dataSet: chartDataSet)
        lineChart.rightAxis.enabled = false
        lineChart.descriptionText = ""
        lineChart.data = chartData
        lineChart.xAxis.labelPosition = .Bottom
        
    }
    
    
    /*func setBarChart(dataPoints: [String], values: [Double]) {
        barChartView.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Units Sold")
        let chartData = BarChartData(xVals: months, dataSet: chartDataSet)
        barChartView.data = chartData
    }*/
    
    func getCurrentDate() -> String{
        let date = NSDate()
        let formatter = NSDateFormatter()
        let dateFormat = NSDateFormatter.dateFormatFromTemplate("MMddyyyy", options: 0, locale: NSLocale(localeIdentifier: "en-US"))
        //gbDateFormat now contains an optional string "dd/MM/yyyy"
        formatter.dateFormat = dateFormat
        let dateString = formatter.stringFromDate(date)
        return dateString
    }
    
    func getDay(date: String) -> Int{
        //let day = date[date.startIndex.advancedBy(3)...date.startIndex.advancedBy(4)]
        var i = 0
        var count = 0
        var day: String = ""
        while i < date.characters.count{
            if count == 1{
                if String(date[date.startIndex.advancedBy(i)]) != "/"{
                    day += String(date[date.startIndex.advancedBy(i)])
                }
            }
            if String(date[date.startIndex.advancedBy(i)]) == "/"{
                count++;
            }
            if count == 2{
                break
            }
            i++
        }
        return Int(day)!
    }
    
    func getMonth(date: String) -> Int{
        //let month = date[date.startIndex...date.startIndex.advancedBy(1)]
        var i = 0
        var month: String = ""
        while i < date.characters.count{
            month += String(date[date.startIndex.advancedBy(i)])
            i++
            if String(date[date.startIndex.advancedBy(i)]) == "/"{
                break
            }
        }
        return Int(month)!
    }
    
    func getYear(date: String) -> Int{
        let year = date[date.startIndex.advancedBy(6)...date.startIndex.advancedBy(9)]
        return Int(year)!
    }
    
    func findTargetDataSet(historyData:[String: userData], mode: Int) -> ([String], [Double], [Double]){
        var resultYFVC:[Double] = []
        var resultYFEV1:[Double] = []
        var dates:[String] = []
        if mode == 0{
            dates = self.findDateSet(0)
            
        }
        else if mode == 1{
            dates = self.findDateSet(1)
        }
        else if mode == 2{
            dates = self.findDateSet(2)
        }
        for date in dates{
            if historyData[date] != nil{
                resultYFVC.append(Double((historyData[date]?.FVC)!)!)
                resultYFEV1.append(Double((historyData[date]?.FEV1)!)!)
            }
            else{
                resultYFVC.append(Double(0))
                resultYFEV1.append(Double(0))
            }
        }
        return (dates, resultYFVC, resultYFEV1)
    }
    
    func findDateSet(mode: Int) -> [String]{
        let date = self.getCurrentDate()
        let Month = self.getMonth(date)
        let Day = self.getDay(date)
        let Year = self.getYear(date)
        var result:[String] = []
        if mode == 0{                //search last 7 days
            let startDay = Day - 7 + 1
            result = self.searchLastDays(startDay, month: Month, day: Day, year: Year)
        }
        else if mode == 1{          //search last 3 weeks
            let startDay = Day - 21 + 1
            result = self.searchLastDays(startDay, month: Month, day: Day, year: Year)
        }
        else if mode == 2{          //search last 3 months
            var lastMonth = Month - 1
            var firstMonth = Month - 2
            let lastYear = Year - 1
            let thirdResult = searchMonth(Month, startDay: 1, endDay: Day, year: Year)
            var firstResult: [String] = []
            var secondResult: [String] = []
            if lastMonth == 0{
                lastMonth = 12
                firstMonth = 11
                
                firstResult = searchMonth(firstMonth, startDay: 1, endDay: monthInfo[firstMonth]!, year: lastYear)
                secondResult = searchMonth(lastMonth, startDay: 1, endDay: monthInfo[lastMonth]!, year: lastYear)
            }
            else if lastMonth == 1{
                firstMonth = 12
                firstResult = searchMonth(firstMonth, startDay: 1, endDay: monthInfo[firstMonth]!, year: lastYear)
                secondResult = searchMonth(lastMonth, startDay: 1, endDay: monthInfo[lastMonth]!, year: Year)
            }
            else{
                firstResult = searchMonth(firstMonth, startDay: 1, endDay: monthInfo[firstMonth]!, year: Year)
                secondResult = searchMonth(lastMonth, startDay: 1, endDay: monthInfo[lastMonth]!, year: Year)
            }
            result = firstResult + secondResult + thirdResult
        }
        return result
    }

    func searchMonth(month: Int, startDay: Int, endDay: Int, year: Int) -> [String]{
        var i = startDay
        var result:[String] = []
        while i <= endDay{
            let searchDay = String(month) + "/" + String(i) + "/" + String(year)
            result.append(searchDay)
            i++
        }
        return result
    }
    
    func searchLastDays(var startDay: Int, month: Int, day: Int, year: Int) -> [String]{
        var result:[String] = []
        if startDay > 0{
            while startDay <= day{
                let searchDate = String(month) + "/" + String(startDay) + "/" + String(year)
                result.append(searchDate)
                startDay++
            }
        }
        else{
            var lastMonth = month - 1
            var lastYear = year
            if lastMonth == 0{
                lastMonth = 12
                lastYear = year - 1
            }
            var beginDay = monthInfo[lastMonth]! + startDay
            while beginDay <= monthInfo[lastMonth]{
                let searchDay = String(lastMonth) + "/" + String(beginDay) + "/" + String(lastYear)
                result.append(searchDay)
                beginDay++
            }
            var i = 1
            while i <= day{
                let searchDay = String(month) + "/" + String(i) + "/" + String(year)
                result.append(searchDay)
                i++
            }
        }
        return result
    }
    
    func printStringArray(strArray: [String], doubleArray1: [Double], doubleArray2: [Double]){
        var i = 0
        while i < strArray.count{
            let str1 = String(doubleArray1[i])
            let str2 = String(doubleArray2[i])
            let str = strArray[i] + ", " + str1 + ", " + str2
            print(str)
            i++
        }
    }
    
    func discardYearInfo(dates:[String]) -> [String]{
        var result: [String] = []
        for date in dates{
            let day = String(self.getDay(date))
            let month = String(self.getMonth(date))
            result.append(month + "/" + day)
        }
        return result
    }
}
