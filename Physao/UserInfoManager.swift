//
//  UserInfoManager.swift
//  Physao
//
//  Created by Weiqi Wei on 15/11/19.
//  Copyright © 2015年 Physaologists. All rights reserved.
//

import UIKit

let sharedInstance = UserInfoManager()

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
        //printString(fvcResult)
        //printString(fev1Result)
        sharedInstance.database!.close()
        return (result, fvcResult, fev1Result)
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
}
