//
//  ShowInvitationViewController.swift
//  testTableView
//
//  Created by Weiqi Wei on 15/11/27.
//  Copyright © 2015年 Physaologists. All rights reserved.
//

import UIKit
import Parse

class ShowInvitationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var myTableView: UITableView!
    
    var invitationInfo:[String] = []
    var invitationFriends:[String: Patient] = [:]
    var add_name_from = ""
    var add_name_to = ""
    var objectAndId:[String: String] = [:]
    var confirmList:[String] = []
    var confirmFriends:[Patient] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getInvitationOnline()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return invitationInfo.count
    }
    
   
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = self.myTableView.dequeueReusableCellWithIdentifier("cell") as! InvitationTableViewCell
        cell.nameLabel.text = invitationInfo[indexPath.row]
        cell.confirmButton.tag = indexPath.row
        cell.confirmButton.addTarget(self, action: Selector("confirmAction:"), forControlEvents: .TouchUpInside)
        
        cell.refuseButton.tag = indexPath.row
        cell.refuseButton.addTarget(self, action: Selector("refuseAction:"), forControlEvents: .TouchUpInside)
        return cell
    }
    
    @IBAction func confirmAction(sender: UIButton){
        let query = PFQuery(className: "InvitationObject")
        let index:Int = sender.tag
        let name = invitationInfo[index]
        //UserInfoManager.getInstance().saveNewFriend(name, nameTo: add_name_to)
        self.confirmList.append(name)
        self.confirmFriends.append(invitationFriends[name]!)
        print(objectAndId[name]!)
        let id = objectAndId[name]!
        query.getObjectInBackgroundWithId(id){
            (objectName: PFObject?, error: NSError?) -> Void in
            if error != nil{
                print(error)
            }
            else if let objectName = objectName{
                objectName["hasAdded"] = "1"
                objectName["timesTo"] = "0"
                objectName["untilDateTo"] = "11/29/2015"
                objectName.saveInBackground()
                print("has Changed")
            }
            dispatch_async(dispatch_get_main_queue()){
                self.invitationInfo.removeAtIndex(index)
                self.myTableView.reloadData()
            }
        }
        
    }
    
    @IBAction func refuseAction(sender: UIButton){
        let index:Int = sender.tag
        let name = invitationInfo[index]
        let id = objectAndId[name]!
        let obj = PFObject.init(withoutDataWithClassName: "InvitationObject", objectId: id)
        obj.deleteEventually()
        
        invitationInfo.removeAtIndex(index)
        dispatch_async(dispatch_get_main_queue()) {
            self.myTableView.reloadData()
        }
    }
    
    func getInvitationOnline(){
        let query = PFQuery(className: "InvitationObject")
        query.whereKey("nameTo", equalTo: add_name_to)
        query.findObjectsInBackgroundWithBlock{
            (objects:[PFObject]?, error: NSError?)-> Void in
            if error == nil{
                print("successfully")
                if let array = objects{
                    for item in array{
                        print(item)
                        let fullName = item.objectForKey("nameFrom") as! String
                        let hasAdded = item.objectForKey("hasAdded") as! String
                        let timesFrom = item.objectForKey("timesFrom") as! String
                        let untilDateFrom = item.objectForKey("untilDateFrom") as! String
                        print(timesFrom)
                        print(untilDateFrom)
                        
                        if(hasAdded == "0"){
                            let patient = Patient(name: fullName, times: timesFrom, date: untilDateFrom)
                            self.invitationInfo.append(fullName)
                            self.objectAndId[fullName] = item.objectId
                            self.invitationFriends[fullName] = patient
                            print(self.invitationInfo.count)
                        }
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.myTableView.reloadData()
            }
        }
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueToSearch"{
            let nextViewController = (segue.destinationViewController as! UINavigationController).topViewController as! SearchFriendsViewController
            nextViewController.name_From = add_name_to
        }
        
    }
    
    @IBAction func unwindFromAddView(segue: UIStoryboardSegue){
        
    }
}
