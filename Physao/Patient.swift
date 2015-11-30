//
//  Patient.swift
//  Physao
//
//  Created by Weiqi Wei on 15/11/29.
//  Copyright © 2015年 Physaologists. All rights reserved.
//



class Patient: NSObject {
    var patientName: String
    var totoalTimes: String
    var untilDate: String
    
    override init() {
        self.patientName = ""
        self.totoalTimes = ""
        self.untilDate = ""
    }
    
    init(name: String, times: String, date: String) {
        self.patientName = name
        self.totoalTimes = times
        self.untilDate = date
    }
}