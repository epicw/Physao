//
//  PhysaoSample.swift
//  Physao
//
//  Created by Emmanuel Shiferaw on 11/4/15.
//  Copyright © 2015 Physaologists. All rights reserved.
//

import UIKit
import HealthKit


//MARK: Constants
//liter unit
let li:HKUnit = HKUnit.literUnit()


//liter/minute unit
let lpm:HKUnit = li.unitDividedByUnit(HKUnit.minuteUnit())

//type identifiers for metrics
let FVC_IDENTIFIER = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierForcedVitalCapacity)!
let FEV1_IDENTIFIER = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierForcedExpiratoryVolume1)!
let PEFR_IDENTIFIER = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierPeakExpiratoryFlowRate)!
let All_Types:Set<HKQuantityType> = [FVC_IDENTIFIER, FEV1_IDENTIFIER, PEFR_IDENTIFIER]

// Class that enapsulates singular spirometer test (6 second or 2 second)
class PhysaoSample: NSObject {
    
    //MARK: Instance variables
    
    // Times of beginning and end of sample.
    var startDate:NSDate
    var endDate:NSDate
    
    // Samples
    var FVCSample:HKSample
    var FEV1Sample:HKSample
    var PEFRSample:HKSample
    
    var FVCRaw:Double
    var FEV1Raw:Double
    var PEFRRaw:Double
    
    init(time: NSDate, FVCValue: Double, FEV1Value: Double, PEFRValue:Double) {
        
        self.startDate = time
        self.endDate = time
        
        self.FVCRaw = FVCValue
        self.FEV1Raw = FEV1Value
        self.PEFRRaw = PEFRValue
        
        let FVCQuantity:HKQuantity = HKQuantity(unit: li, doubleValue: FVCValue)
        let FEV1Quantity:HKQuantity = HKQuantity(unit: li, doubleValue: FEV1Value)
        let PEFRQuantity:HKQuantity = HKQuantity(unit: lpm, doubleValue: PEFRValue)
        
        
        self.FVCSample = HKQuantitySample(type: FVC_IDENTIFIER, quantity: FVCQuantity, startDate: self.startDate, endDate: self.endDate)
        self.FEV1Sample = HKQuantitySample(type: FEV1_IDENTIFIER, quantity: FEV1Quantity, startDate: self.startDate, endDate: self.endDate)
        self.PEFRSample = HKQuantitySample(type: PEFR_IDENTIFIER, quantity: PEFRQuantity, startDate: self.startDate, endDate: self.endDate)
    }
    
    func save(store:HKHealthStore) {
        
        let callBack = { ( success: Bool, err: NSError?) -> Void in
            if (err != nil) {
                // TODO: GUI Error handling here? Throw excpt.
                print("Error saving Physao Sample: \(err!.localizedDescription)")
            } else {
                print("Physao sample saved.")
            }
        }
        
        store.saveObject(self.FVCSample, withCompletion: callBack)
        store.saveObject(self.FEV1Sample, withCompletion: callBack);
        store.saveObject(self.PEFRSample, withCompletion: callBack);
        
    }
    
    
}