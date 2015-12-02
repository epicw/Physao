//
//  PhysaoQuery.swift
//  Physao
//
//  Created by Emmanuel Shiferaw on 11/4/15.
//  Copyright © 2015 Physaologists. All rights reserved.
//

import UIKit
import HealthKit


//MARK: Constants



class PhysaoQuery: NSObject {
    
    //MARK: Instance variables
    var startDate:NSDate
    var endDate:NSDate
    var type:PhysaoSampleType
    
    init(start:NSDate, end:NSDate, typeToReturn: PhysaoSampleType) {
        
        self.startDate = start
        self.endDate = end
        self.type = typeToReturn
        
    }
    
    func execute(store: HKHealthStore, onComplete: ([PhysaoDataPoint], NSError!) -> Void) -> Void {
        
        // Sample type for query
        let typeTuple = selectType()
        let sampleType = typeTuple.0
        let unit = typeTuple.1
        
        
        // Sort desriptor for query, to get results in descending order of date.
        let sorter = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false);
        
        let callBack = { (sampleQuery:HKSampleQuery, results:[HKSample]?, err:NSError? ) -> Void in
            
            if err != nil {
                // TODO: Add GUI error handling, throw exc.
                print("Error querying.")
                return;
            }
            
            let allSamples:[HKQuantitySample] = results as! [HKQuantitySample]
            var allValues:[PhysaoDataPoint] = [PhysaoDataPoint]()
            for quantitySample in allSamples {
                
                let currentValue:Double = quantitySample.quantity.doubleValueForUnit(unit)
                let currentTime:NSDate = quantitySample.startDate
                
                let dataPoint:PhysaoDataPoint = PhysaoDataPoint(time: currentTime, type: self.type, value: currentValue)
                allValues.append(dataPoint)
                
            }
            
            onComplete(allValues, err)
            
        }
        
        let predicate = HKQuery.predicateForSamplesWithStartDate(self.startDate, endDate: self.endDate, options: .None)
        
        
        // TODO: Remove unnecessary limit if possible
        let limit = 1000
        
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: limit, sortDescriptors: [sorter], resultsHandler: callBack)
        
        store.executeQuery(query)
        
    }
    
    
    func selectType() -> (HKQuantityType, HKUnit) {
        var sampleType:HKQuantityType
        var unit:HKUnit
        
        switch self.type {
        case PhysaoSampleType.FVC:
            sampleType = FVC_IDENTIFIER
            unit = li // Liters
        case PhysaoSampleType.FEV1:
            sampleType = FEV1_IDENTIFIER
            unit = li // Liters
        case PhysaoSampleType.PEFR:
            sampleType = PEFR_IDENTIFIER
            unit = lpm // Liters per minute
        default:
            sampleType = FVC_IDENTIFIER
            unit = li // Liters
        }
        
        return (sampleType, unit)
    }
    
    // Both lists should be of the same length, and their source should be from a PhysaoQuery.execute() call
    // First input is numerator of 'ratio' (FEV1)
    // Second input is denominator of 'ratio' (FVC)
    class func buildRatioList(list1:[PhysaoDataPoint], list2:[PhysaoDataPoint]) -> [PhysaoDataPoint] {
        
        var ratioList:[PhysaoDataPoint] = [PhysaoDataPoint]()
        
        for var index = 0; index < list1.count; ++index {
            
            let commonTime:NSDate = list1[index].time; // Has to be the same for equivalent element in both lists
            let firstVal:Double = list1[index].sampleValue;
            let secondVal:Double = list2[index].sampleValue;
            
            let ratioVal:Double = firstVal / secondVal;
            
            let ratioPoint:PhysaoDataPoint = PhysaoDataPoint(time: commonTime, type: PhysaoSampleType.Ratio, value: ratioVal)
            
            ratioList.append(ratioPoint)
            
        }
        
        
        return ratioList
    }
    
    
}