//
//  FriendsListViewController.swift
//  testTableView
//
//  Created by Weiqi Wei on 15/11/26.
//  Copyright © 2015年 Physaologists. All rights reserved.
//

import UIKit
import Parse

class FriendsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTableView: UITableView!
    
    var friendsList:[Patient] = []
    var friendsInfo:[String: Patient] = [:]
    var incomming_name:String = ""
    var confirmArray:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(incomming_name)
        getInvitationResultOnline()
        saveNewUserOnline()
        friendsList += UserInfoManager.getInstance().getAllFriends(incomming_name)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return friendsList.count
    }
    
    // Show all of the friends info in this table view
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = myTableView.dequeueReusableCellWithIdentifier("cell") as! FriendsTableViewCell
        let name = friendsList[indexPath.row].patientName
        cell.nameLabel.text = name
        let patient = friendsList[indexPath.row]
        let str = patient.totoalTimes + " times until " + patient.untilDate
        cell.timeLabel.text = str
        return cell
    }
    
    
    // Prepare to send username to next ViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueToInvitation"{
            let nextViewController = (segue.destinationViewController as! UINavigationController).topViewController as! ShowInvitationViewController
            nextViewController.add_name_to = incomming_name
        }
    }
    
    // Get back from invitationViewController
    @IBAction func unwindFromInvitation(segue: UIStoryboardSegue){
        let source = segue.sourceViewController as! ShowInvitationViewController
        friendsList += source.confirmFriends
        confirmArray = source.confirmList
        let strArray = source.confirmFriends
        if source.confirmFriends.count > 0{
            for item in strArray{
                dispatch_async(dispatch_get_main_queue()){
                    UserInfoManager.getInstance().saveNewFriend(self.incomming_name, nameTo: item.patientName, times: item.totoalTimes, untilDate: item.untilDate)
                    
                }
            }
        }        
        dispatch_async(dispatch_get_main_queue()){
            self.myTableView.reloadData()
        }
        
        getInvitationResultOnline()        // refresh to see whether there are some invitaion which are confirmed by others
    }
    
    // Get invitation results from Parse.com
    func getInvitationResultOnline(){
        let query = PFQuery(className: "InvitationObject")
        query.whereKey("nameFrom", equalTo: incomming_name)
        query.findObjectsInBackgroundWithBlock{
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil{
                print("Successfully get invitation result")
                if let array = objects{
                    for item in array{
                        let name_to = item.objectForKey("nameTo") as! String
                        let hasAdded = item.objectForKey("hasAdded") as! String
                        if hasAdded == "1"{
                            let timesPatient = item.objectForKey("timesTo") as! String
                            let untilDate = item.objectForKey("untilDateTo") as! String
                            let id = item.objectId
                            self.friendsList.append(Patient(name: name_to, times: timesPatient, date: untilDate))
                            print("friendList number" +  String(self.friendsList.count) + name_to)
                            UserInfoManager.getInstance().saveNewFriend(self.incomming_name, nameTo: name_to, times: timesPatient, untilDate: untilDate)
                            let obj = PFObject.init(withoutDataWithClassName: "InvitationObject", objectId: id)
                            obj.deleteEventually()
                        }
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue()){
                self.myTableView.reloadData()
            }
        }
    }
    
    // If this user is a new user, which has not saved his profile online, this function will save his profile to Parse.com
    func saveNewUserOnline(){
        let query = PFQuery(className: "FriendsInfo")
        query.whereKey("name", equalTo: incomming_name)
        query.findObjectsInBackgroundWithBlock{
            (objects:[PFObject]?, error: NSError?) -> Void in
            if error == nil{
                print("sucessfully find in FriendsInfo")
                print(objects!.count)
                if let array = objects{
                    if array.count == 0{
                       let friend = PFObject(className: "FriendsInfo")
                       let acl = PFACL()
                        acl.publicReadAccess = true
                        acl.publicWriteAccess = true
                        friend.ACL = acl
                        friend["name"] = self.incomming_name
                        friend["times"] = "0"
                        friend["untilDate"] = self.getCurrentDate()
                        friend.saveInBackgroundWithBlock{
                            (success:Bool, error: NSError?) -> Void in
                            print("save new person to Parse")
                        }
                    }
                }
            }
        }
    }
    
    // Get current date to string type
    func getCurrentDate()->String{
        let date = NSDate()
        let formatter = NSDateFormatter()
        let dateFormat = NSDateFormatter.dateFormatFromTemplate("MMddyyyy", options: 0, locale: NSLocale(localeIdentifier: "en-US"))
        //gbDateFormat now contains an optional string "dd/MM/yyyy"
        formatter.dateFormat = dateFormat
        let dateString = formatter.stringFromDate(date)
        return dateString
    }
}
