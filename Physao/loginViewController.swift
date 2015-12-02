//
//  loginViewController.swift
//  Physao
//
//  Created by Weiqi Wei on 15/11/19.
//  Copyright © 2015年 Physaologists. All rights reserved.
//

import UIKit
import Parse
class loginViewController: UIViewController, UIScrollViewDelegate{
    
    //@IBOutlet weak var scrollView: UIScrollView!
    
    var userNameText = UITextField()
    var passwordText = UITextField()
    var userNameLabel = UILabel()
    var passwordLabel = UILabel()
    var scrollView = UIScrollView()
    var loginButton = UIButton()
    var registerButton = UIButton()
    var imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView = UIScrollView(frame: view.bounds)
        //scrollView.backgroundColor = UIColor.blackColor()
        scrollView.contentSize = self.view.bounds.size
        scrollView.contentOffset = CGPoint(x: 30, y: 80)
        scrollView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        let width = self.scrollView.frame.width
        let height = self.scrollView.frame.height
        let label_hight = height/2
        
        imageView.image = UIImage(named: "physao.png")
        imageView.frame = CGRectMake(width/2 - 25, height/4, 105, 128)
        
        userNameLabel.text = "UserName:"
        userNameLabel.frame = CGRectMake(40, label_hight, 100, 30)
        
        userNameText.frame = CGRectMake(40, label_hight + 40, width - 20, 30)
        userNameText.borderStyle = .RoundedRect
        
        passwordLabel.text = "Password:"
        passwordLabel.frame = CGRectMake(40, label_hight + 80, 100, 30)
        
        passwordText.frame = CGRectMake(40, label_hight + 120, width - 20, 30)
        passwordText.borderStyle = .RoundedRect

        loginButton.setTitle("Log in", forState: .Normal)
        loginButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        loginButton.setTitleColor(UIColor.grayColor(), forState: .Highlighted)
        loginButton.addTarget(self, action: Selector("loginAction:"), forControlEvents: .TouchUpInside)
        loginButton.frame = CGRectMake(width/2 - 20, label_hight + 185, 100, 10)
        
        registerButton.setTitle("Register", forState: .Normal)
        registerButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        registerButton.setTitleColor(UIColor.greenColor(), forState: .Highlighted)
        registerButton.addTarget(self, action: Selector("RegisterAction:"), forControlEvents: .TouchUpInside)
        registerButton.frame = CGRectMake(width/2 - 20, label_hight + 215, 100, 10)
        
        self.scrollView.addSubview(imageView)
        self.scrollView.addSubview(userNameLabel)
        self.scrollView.addSubview(passwordLabel)
        self.scrollView.addSubview(userNameText)
        self.scrollView.addSubview(passwordText)
        self.scrollView.addSubview(loginButton)
        self.scrollView.addSubview(registerButton)
        self.view.addSubview(scrollView)
        // Do any additional setup after loading the view, typically from a nib.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("DismissKeyboard:"))
        view.addGestureRecognizer(tap)
        
        //userNameText.text = "Weiqi Wei"
        //passwordText.text = "11"
    }
    
    func DismissKeyboard(recognizer: UITapGestureRecognizer){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.scrollView.contentOffset = CGPoint(x: 30, y: 80)
        passwordText.resignFirstResponder()
        userNameText.resignFirstResponder()
        self.scrollView.contentOffset = CGPoint(x: 30, y: 80)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.registerForKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        //self.deregisterFromKeyboardNotifications()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(sender: UIButton) {
        if UserInfoManager.getInstance().logInFunction(userNameText.text!, password: passwordText.text!){
            let DashBoardView = self.storyboard?.instantiateViewControllerWithIdentifier("DashBoard") as! DashBoardViewController
            DashBoardView.incomming_string = userNameText.text!
            let navController = UINavigationController(rootViewController: DashBoardView)
            self.presentViewController(navController, animated: true, completion: nil)
        }
        else{
            let alertMessage = UIAlertController(title: "Alert", message: "Username or Password may be wrong.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alertMessage.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction) in
                print("Handle Ok logic here")
            }))
            
            presentViewController(alertMessage, animated: true, completion: nil)
        }
    }
    @IBAction func RegisterAction(sender: AnyObject) {
        if(userNameText.text == "" || passwordText.text == ""){
            let alertMessage = UIAlertController(title: "Alert", message: "Username or Password cannot be empty.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alertMessage.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction) in
                print("Handle Ok logic here")
            }))
            
            presentViewController(alertMessage, animated: true, completion: nil)
        }
        else{
            if UserInfoManager.getInstance().addUserInfoData(userNameText.text!, password: passwordText.text!){
                let alertMessage = UIAlertController(title: "Alert", message: "Register successfully.", preferredStyle: UIAlertControllerStyle.Alert)
                
                alertMessage.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction) in
                    print("Handle Ok logic here")
                }))
                
                presentViewController(alertMessage, animated: true, completion: nil)
            }
            else{
                let alertMessage = UIAlertController(title: "Alert", message: "Register Unsuccessfully. User name exists", preferredStyle: UIAlertControllerStyle.Alert)
                
                alertMessage.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction) in
                    print("Handle Ok logic here")
                }))
                
                presentViewController(alertMessage, animated: true, completion: nil)
            }
        }
    }
    
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueToDashBoard"{
            let nextController = (segue.destinationViewController as! UINavigationController).topViewController as! DashBoardViewController
            print(nextController.incomming_string)
        }
    }*/
    func registerForKeyboardNotifications ()-> Void   {
        self.scrollView.contentOffset = CGPoint(x: 30, y: 80)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
        
        
    }
    
    func deregisterFromKeyboardNotifications () -> Void {
        self.scrollView.contentOffset = CGPoint(x: 30, y: 80)
        let center:  NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.removeObserver(self, name: UIKeyboardDidHideNotification, object: nil)
        center.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
        
    }
    
    
    func keyboardWasShown (notification: NSNotification) {
        //self.scrollView.contentOffset = CGPoint(x: 30, y: 80)
        if let userInfo = notification.userInfo {
            if let keyboardSize: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size {
                let contentInset = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height,  0.0);
                
                self.scrollView.contentInset = contentInset
                self.scrollView.scrollIndicatorInsets = contentInset
                
                self.scrollView.contentOffset = CGPointMake(30, 0 + keyboardSize.height) //set zero instead self.scrollView.contentOffset.y
                //self.scrollView.contentOffset = CGPoint(x: 30, y: 80) self.scrollView.contentOffset.x
            }
        }
    }
    
    func keyboardWillBeHidden (notification: NSNotification) {
        //self.scrollView.contentOffset = CGPoint(x: 30, y: 80)
        if let userInfo = notification.userInfo {
            if let _: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size {
                let contentInset = UIEdgeInsetsZero;
                
                self.scrollView.contentInset = contentInset
                self.scrollView.scrollIndicatorInsets = contentInset
                self.scrollView.contentOffset = CGPointMake(30, self.scrollView.contentOffset.y)
                //self.scrollView.contentOffset = CGPoint(x: 30, y: 80)

            }
        }
    }
    
    @IBAction func unwindFromDashBoard(segue: UIStoryboardSegue){
        self.scrollView.contentOffset = CGPoint(x: 30, y: 80)
        //userNameText.text = ""
        //passwordText.text = ""
    }
    
}
