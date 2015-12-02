//
//  DashBoardViewController.swift
//  Physao
//
//  Created by Weiqi Wei on 15/11/17.
//  Copyright © 2015年 Physaologists. All rights reserved.
//

import UIKit

class DashBoardViewController: UIViewController {

    var incomming_string: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(self.incomming_string)
        let BUTTON_WIDTH = (self.view.frame.size.width - 60.0) / 2.0
        healthKitSharedInstance.requestAuthorizationToShareTypes(All_Types, readTypes: All_Types, completion: { (success, error) -> Void in
            if success {
                print("success")
            } else {
                print(error!.description)
            }
        })
        let blowButton = UIButton()
        let dataButton = UIButton()
        let settingsButton = UIButton()
        let socialButton = UIButton()
        
        blowButton.frame = CGRectMake(20, 100, BUTTON_WIDTH, BUTTON_WIDTH)
        blowButton.setImage(UIImage(named: "blowButton.png"), forState: UIControlState.Normal)
        blowButton.addTarget(self, action: Selector("blowAction:"), forControlEvents: .TouchUpInside)
        
        
        dataButton.frame = CGRectMake(40 + BUTTON_WIDTH, blowButton.frame.origin.y, BUTTON_WIDTH, BUTTON_WIDTH)
        dataButton.setImage(UIImage(named: "data.png"), forState: UIControlState.Normal)
        dataButton.addTarget(self, action: Selector("HistoryData:"), forControlEvents: .TouchUpInside)
        
        settingsButton.frame = CGRectMake(blowButton.frame.origin.x, blowButton.frame.origin.y + blowButton.frame.size.height + 20, BUTTON_WIDTH, BUTTON_WIDTH)
        settingsButton.setImage(UIImage(named: "settings.png"), forState: UIControlState.Normal)
        settingsButton.addTarget(self, action: Selector("Settings:"), forControlEvents: .TouchUpInside)
        
        socialButton.frame = CGRectMake(dataButton.frame.origin.x, dataButton.frame.origin.y + dataButton.frame.size.height + 20, BUTTON_WIDTH, BUTTON_WIDTH)
        socialButton.setImage(UIImage(named: "social.png"), forState: UIControlState.Normal)
        socialButton.addTarget(self, action: Selector("SocialAction:"), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(blowButton)
        self.view.addSubview(dataButton)
        self.view.addSubview(settingsButton)
        self.view.addSubview(socialButton)
        
        UserInfoManager.getInstance().getAllUserInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SegueToFriends"{
            let nextController = (segue.destinationViewController as! UINavigationController).topViewController as! FriendsListViewController
            nextController.incomming_name = self.incomming_string
        }
    }*/
    

    @IBAction func pressed(sender: UIButton!) {
        print("press button")
    }
    
    @IBAction func blowAction(sender: UIButton!){
        let SpirometryView = self.storyboard?.instantiateViewControllerWithIdentifier("Spirometry") as! SpirometryViewController
        let navController = UINavigationController(rootViewController: SpirometryView) // Creating a navigation controller with VC1 at the root of the navigation stack.
        self.presentViewController(navController, animated:true, completion: nil)
        //self.presentViewController(SpirometryView, animated: true, completion: nil)
        
    }
    
    @IBAction func HistoryData(sender: UIButton){
        let HistoryDataView = self.storyboard?.instantiateViewControllerWithIdentifier("HistoryData") as! HistoryDataViewController
        let navController = UINavigationController(rootViewController: HistoryDataView)
        self.presentViewController(navController, animated: true, completion: nil)
    }
    
    @IBAction func Settings(sender: UIButton){
        let SettingsView = self.storyboard?.instantiateViewControllerWithIdentifier("SettingsView") as! SettingsViewController
        let navController = UINavigationController(rootViewController: SettingsView)
        self.presentViewController(navController, animated: true, completion: nil)
    }
    
    @IBAction func SocialAction(sender: UIButton){
        let SocialView = self.storyboard?.instantiateViewControllerWithIdentifier("FriendsView") as! FriendsListViewController
        //print(self.incomming_name)
        SocialView.incomming_name = self.incomming_string
        let navController = UINavigationController(rootViewController: SocialView)
        self.presentViewController(navController, animated: true, completion: nil)
    }
    
    @IBAction func unwindFromSpirometry(segue: UIStoryboardSegue){
    
    }
    
    @IBAction func unwindFromHistoryData(segue: UIStoryboardSegue){
    
    }
    
    @IBAction func unwindFromSettings(segue: UIStoryboardSegue){
    
    }
    
    @IBAction func unwindFromSocial(segue: UIStoryboardSegue){
    
    }
}
