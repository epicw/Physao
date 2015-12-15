//
//  SettingsViewController.swift
//  Physao
//
//  Created by Weiqi Wei on 15/11/17.
//  Copyright © 2015年 Physaologists. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: Properties
    let categoryIdentifier = "blow"
    let notifyPicker = UIDatePicker()  // time picker
    let saveButton = UIButton()
    let showLabel = UILabel()  // help user to see that they successfully set the notifications
    var scrollView = UIScrollView()
    
    @IBAction func saveTime(sender: AnyObject) {
        self.registerMyNotification()
    }
    
    func registerMyNotification() {
        print("checking for notification permissions")
        if let settings = UIApplication.sharedApplication().currentUserNotificationSettings() {
            if let cats = settings.categories {
                for cat in cats {
                    if cat.identifier == self.categoryIdentifier { // we are already registered
                        self.createLocalNotification()
                        return
                    }
                }
            }
        }
        let types : UIUserNotificationType = [.Alert, .Sound]
        // if we want custom actions in our alert, we must create them when we register
        let category = UIMutableUserNotificationCategory()
        category.identifier = self.categoryIdentifier // will need this at notification creation time!
        let action1 = UIMutableUserNotificationAction()
        action1.identifier = "sounds good"
        action1.title = "Sounds good" // user will see this
        action1.destructive = false // the default, I'm just setting it to call attention to its existence
        action1.activationMode = .Foreground // if .Background, app just stays in the background! cool
        // if .Background, should also set authenticationRequired to say what to do from lock screen
        
        let action2 = UIMutableUserNotificationAction()
        var which : Int {return 1} // try 1 and 2
        switch which {
        case 1:
            action2.identifier = "ohno"
            action2.title = "Oh, No!" // user will see this
            action2.destructive = false // the default, I'm just setting it to call attention to its existence
            action2.activationMode = .Background // if .Background, app just stays in the background! cool
            // if .Background, should also set authenticationRequired to say what to do from lock screen
        case 2:
            action2.identifier = "message"
            action2.title = "Message"
            action2.activationMode = .Background
            action2.behavior = .TextInput // new in iOS 9!
        default: break
        }
        
        category.setActions([action1, action2], forContext: .Default) // can have 4 for default, 2 for minimal
        let settings = UIUserNotificationSettings(forTypes: types, categories: [category])
        // prepare to proceed to next step
        var ob : NSObjectProtocol! = nil
        ob = NSNotificationCenter.defaultCenter().addObserverForName("didRegisterUserNotificationSettings", object: nil, queue: nil) {
            _ in
            NSNotificationCenter.defaultCenter().removeObserver(ob)
            self.createLocalNotification()
        }
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        // if this app has never requested this registration,
        // it will put up a dialog asking if we can present alerts etc.
        // when the user accepts or refuses,
        // will cause us to receive application:didRegisterUserNotificationSettings:
        // can also check at any time with currentUserNotificationSettings
        
        // unfortunately if the user accepts, the default is banner, not alert :(
        print("end of registerMyNotification")
    }
    
    func createLocalNotification() {
        
        UIApplication.sharedApplication().cancelAllLocalNotifications() // cancel all the previous notifications, in case previous notifications still work, which is annoying
        
        print("creating local notification")
        showLabel.fadeIn() // the label show for a second to indicate that notification has been created successfully
        showLabel.text = "Create Completed"
        showLabel.textColor = UIColor.blueColor()
        showLabel.font = UIFont(name: "systemFont", size: 18.0)
        showLabel.font = UIFont.boldSystemFontOfSize(18)
        showLabel.fadeOut()
        
        let note = UILocalNotification()
        note.alertBody = "Time to blow!"
        note.category = self.categoryIdentifier // causes Options button to spring magically to life in alert
        // Options button will offer Open, action buttons, Close
        note.fireDate = notifyPicker.date
        note.soundName = UILocalNotificationDefaultSoundName
        note.repeatInterval = NSCalendarUnit.Day // notify every day
        UIApplication.sharedApplication().scheduleLocalNotification(note)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // customize the scroll view
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.contentSize = self.view.bounds.size
        scrollView.contentOffset = CGPoint(x: 0, y: 80)
        scrollView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        // customize the picker and button
        notifyPicker.datePickerMode = UIDatePickerMode.Time // not show the day, only show the hour and minute
        let pickerWidth = self.view.frame.size.width
        let pickerHeight = self.view.frame.size.height / 2
        notifyPicker.frame = CGRectMake(0, 100, pickerWidth, pickerHeight)
        self.scrollView.addSubview(notifyPicker)
        
        let buttonX = self.view.center.x - 80
        let buttonY = 100 + pickerHeight
        let buttonWidth = CGFloat(160)
        let buttonHeight = CGFloat(130)
        saveButton.setTitle("Save", forState: UIControlState.Normal)
        saveButton.titleLabel?.font = UIFont.boldSystemFontOfSize(20)
        saveButton.backgroundColor = UIColor.whiteColor()
        saveButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        saveButton.frame = CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight)
        saveButton.addTarget(self, action: Selector("saveTime:"), forControlEvents: .TouchUpInside)
        self.scrollView.addSubview(saveButton)
        // the label
        showLabel.frame = CGRectMake(buttonX-4, buttonY+80, buttonWidth+8, buttonHeight/2-5)
        self.scrollView.addSubview(showLabel)
        self.view.addSubview(scrollView)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
