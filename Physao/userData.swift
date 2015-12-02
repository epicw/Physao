//
//  userData.swift
//  Physao
//
//  Created by Weiqi Wei on 15/11/30.
//  Copyright © 2015年 Physaologists. All rights reserved.
//

class userData {
    var userName: String
    var saveDate: String
    var FVC: String
    var FEV1: String
    
    init(){
        self.userName = ""
        self.saveDate = ""
        self.FVC = ""
        self.FEV1 = ""
    }
    
    init(name: String, date: String, fvc: String, fev1: String){
        self.userName = name
        self.saveDate = date
        self.FVC = fvc
        self.FEV1 = fev1
    }
}
