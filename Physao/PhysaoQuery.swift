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
    var type:String
    
    init(start:NSDate, end:NSDate, typeToReturn: String) {
        
        self.startDate = start
        self.endDate = end
        self.type = typeToReturn
        
    }
    
    func execute() -> [HKQuantitySample] {
        
        // Sort desriptor for query, to get results in descending order of date.
        let sorter = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false);
        
        let callBack = { (sampleQuery:HKSampleQuery, results:[HKSample]?, err:NSError? ) -> Void in
            
            if err != nil {
                
                // TODO: Add GUI error handling, throw exc.
                print("Error querying.")
                return;
            }

        
        }
        
        //TODO: build predicate
        
        //let query = HKSampleQuery(sampleType: <#T##HKSampleType#>, predicate: <#T##NSPredicate?#>, limit: <#T##Int#>, sortDescriptors: [sorter], resultsHandler: callBack)
        
        return [HKQuantitySample]()
    }
    
}
