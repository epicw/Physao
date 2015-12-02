//
//  UserInfoManager.swift
//  Physao
//
//  Created by Weiqi Wei on 15/11/19.
//  Copyright © 2015年 Physaologists. All rights reserved.
//

import UIKit
import HealthKit

let sharedInstance = UserInfoManager()
let healthKitSharedInstance = HKHealthStore()



class UserInfoManager: NSObject{
    
    var database: FMDatabase? = nil
    
    class func getInstance()->UserInfoManager{
        if(sharedInstance.database == nil){
            sharedInstance.database = FMDatabase(path: Util.getPath("UserInfo.sqlite"))
        }
        return sharedInstance
    }
    
    func getAllDate()->(dates:[String], FVC:[Double], FEV1:[Double]){
        sharedInstance.database!.open()
        let querySQL = "SELECT * FROM DataTable1"
        var result:[String] = []
        var fvcResult:[Double] = []
        var fev1Result:[Double] = []
        let findDate = sharedInstance.database!.executeQuery(querySQL, withArgumentsInArray: nil)
        if findDate != nil{
            while findDate.next(){
                result.append(findDate!.stringForColumn("date"))
                fvcResult.append((findDate!.stringForColumn("fvc") as NSString).doubleValue)
                fev1Result.append((findDate!.stringForColumn("fev1") as NSString).doubleValue)
            }
        }
        
        printString(result)
        sharedInstance.database!.close()
        return (result, fvcResult, fev1Result)
    }
    
    func getUserHistoryData(userName: String)->([String: userData]){
        sharedInstance.database!.open()
        let querySQL = "SELECT * FROM DataTable1"
        var result:[String: userData] = [:]
        let findResult = sharedInstance.database!.executeQuery(querySQL, withArgumentsInArray: nil)
        if findResult != nil{
            while findResult.next(){
                let testDate = findResult!.stringForColumn("date") as String
                let fvcResult = findResult!.stringForColumn("fvc") as String
                let fev1Result = findResult!.stringForColumn("fev1") as String
                let userInfo = userData(name: userName, date: testDate, fvc: fvcResult
                    , fev1: fev1Result)
                result[testDate] = userInfo
            }
        }
        sharedInstance.database!.close()
        return result
    }
    
    func saveNewFriend(nameFrom: String, nameTo: String, times: String, untilDate: String) -> Bool{
        sharedInstance.database!.open()
        let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO friendsTable (hostName,friendName, times, untilDate) VALUES (?,?,?,?)", withArgumentsInArray: [nameFrom, nameTo, times, untilDate])
        sharedInstance.database!.close()
        
        //getAllFriends(nameFrom)
        
        return isInserted
    }
    
    func getAllFriends(hostName: String) -> [Patient]{
        sharedInstance.database!.open()
        
        let querySQL = "SELECT * FROM friendsTable where hostName = '\(hostName)'"
        let results: FMResultSet? = sharedInstance.database!.executeQuery(querySQL, withArgumentsInArray: nil)
        var friendsname:[String] = []
        var friendsObjects:[Patient] = []
        if(results != nil){
            while results!.next(){
                let friend_name = results!.stringForColumn("friendName")
                let timesPatient = results!.stringForColumn("times")
                let untilDate = results!.stringForColumn("untilDate")
                let patient = Patient(name: friend_name, times: timesPatient, date: untilDate)
                friendsname.append(friend_name)
                friendsObjects.append(patient)
                //print(friend_name)
            }
        }
        sharedInstance.database!.close()
        printString(friendsname)
        return friendsObjects
    }
    
    func addUserInfoData(name: String, password: String) -> Bool{
        sharedInstance.database!.open()
        let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO userTable (UserName,Password) VALUES (?,?)", withArgumentsInArray: [name, password])
        sharedInstance.database!.close()
        return isInserted
    }
    
    func logInFunction(name: String, password: String) -> Bool{
        sharedInstance.database!.open()
        let querySQL = "SELECT password FROM userTable where username = '\(name)'"
        
        let results: FMResultSet? = sharedInstance.database!.executeQuery(querySQL, withArgumentsInArray: nil)
        
        if(results?.next() == true){
            let passwordFromDB = results!.stringForColumn("password")
            if(passwordFromDB == password){
                sharedInstance.database!.close()
                return true;
            }
        }
        sharedInstance.database!.close()
        return false;
    }
    
    func getAllUserInfo(){
        sharedInstance.database!.open()
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM userTable", withArgumentsInArray: nil)
        var userArray: [UserInfo] = []
        if(resultSet != nil){
            while resultSet.next(){
                let user: UserInfo = UserInfo()
                user.userName = resultSet.stringForColumn("username")
                user.password = resultSet.stringForColumn("password")
                userArray.append(user)
            }
        }
        printArray(userArray)
        sharedInstance.database!.close()
    }
    
    func printArray(array: [UserInfo]){
        for item in array{
            print(item.userName + ": " + item.password)
        }
    }
    
    func printString(array: [String]){
        for item in array{
            print(item)
        }
    }
    
    
    class func getHKData() -> (FVC: [PhysaoDataPoint], FEV1: [PhysaoDataPoint], PEFR: [PhysaoDataPoint], Ratio: [PhysaoDataPoint]){
        
        let FVCQuery = PhysaoQuery(start: NSDate.distantPast(), end: NSDate.distantFuture(), typeToReturn: PhysaoSampleType.FVC)
        let FEV1Query = PhysaoQuery(start: NSDate.distantPast(), end: NSDate.distantFuture(), typeToReturn: PhysaoSampleType.FEV1)
        let PEFRQuery = PhysaoQuery(start: NSDate.distantPast(), end: NSDate.distantFuture(), typeToReturn:
            PhysaoSampleType.PEFR)
        
        var FVCResult = [PhysaoDataPoint]()
        var FEV1Result = [PhysaoDataPoint]()
        var PEFRResult = [PhysaoDataPoint]()
        
        let FVCCallback = { (data: [PhysaoDataPoint], error: NSError!) -> Void in
            
            FVCResult = data
            
        }
        
        let FEV1Callback = { (data: [PhysaoDataPoint], error: NSError!) -> Void in
            
            FEV1Result = data
            
        }
        
        let PEFRCallback = { (data: [PhysaoDataPoint], error: NSError!) -> Void in
            
            PEFRResult = data
            
        }
        
        FVCQuery.execute(healthKitSharedInstance, onComplete: FVCCallback)
        FEV1Query.execute(healthKitSharedInstance, onComplete: FEV1Callback)
        PEFRQuery.execute(healthKitSharedInstance, onComplete: PEFRCallback)
        let RatioResult = PhysaoQuery.buildRatioList(FEV1Result, list2: FVCResult)
        
        return (FVCResult, FEV1Result, PEFRResult, RatioResult)
    }
    
}
