//
//  PhysaoDataPoint.swift
//  Physao
//
//  Created by Emmanuel Shiferaw on 11/25/15.
//  Copyright © 2015 Physaologists. All rights reserved.
//

// Simple wrapper for data included in single point.


import UIKit

enum PhysaoSampleType {
    
    case FVC
    case FEV1
    case PEFR
    case Ratio
    
}

class PhysaoDataPoint: NSObject {
    
    var time:NSDate
    var type:PhysaoSampleType
    var sampleValue:Double
    
    init(time: NSDate, type: PhysaoSampleType, value: Double) {
        
        self.time = time
        self.type = type
        self.sampleValue = value
        
    }
    
    
    class func splitList(toSplit:[PhysaoDataPoint]) -> (times: [NSDate], values: [Double]){
        var valsToReturn = [Double]()
        var timesToReturn = [NSDate]()
        
        for dataPoint in toSplit {
            valsToReturn.append(dataPoint.sampleValue)
            timesToReturn.append(dataPoint.time)
        }
        
        return (timesToReturn, valsToReturn)
        
    }
    
    class func extractVals(all: [PhysaoDataPoint]) -> [Double] {
        var valsToReturn = [Double]()
        for dataPoint in all {
            valsToReturn.append(dataPoint.sampleValue)
        }
        
        return valsToReturn
    }
    
    
    
}