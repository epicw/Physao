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
    
    var userNameText = UITextField()
    var passwordText = UITextField()
    var userNameLabel = UILabel()
    var passwordLabel = UILabel()
    var scrollView = UIScrollView()
    var loginButton = UIButton()
    var registerButton = UIButton()
    var imageView = UIImageView()
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Establish a scrollViewn, then add some imageView, textFields, labels and buttons. 
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.contentSize = self.view.bounds.size
        scrollView.contentOffset = CGPoint(x: 0, y: 80)
        scrollView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        scrollView.backgroundColor = UIColor.grayColor()
        
        let width = self.scrollView.frame.width
        let height = self.scrollView.frame.height
        let label_hight = height/2
        
        imageView.image = UIImage(named: "physao.png")
        imageView.frame = CGRectMake(width/2 - 25, height/4+10, 115, 115)
        
        userNameLabel.text = "UserName"
        userNameLabel.font = UIFont(name: "systemFont", size: 18.0)
        userNameLabel.font = UIFont.boldSystemFontOfSize(18)
        userNameLabel.frame = CGRectMake(40, label_hight+25, 100, 30)
        
        userNameText.frame = CGRectMake(40, label_hight + 65, width - 20, 40)
        userNameText.borderStyle = .RoundedRect
        userNameText.placeholder = "UserName"
        let myColor : UIColor = UIColor( red: 0.1, green: 0.1, blue:0.1, alpha: 0.5 )
        userNameText.layer.borderColor = myColor.CGColor
        
        passwordLabel.text = "Password"
        passwordLabel.font = UIFont(name: "systemFont", size: 18.0)
        passwordLabel.font = UIFont.boldSystemFontOfSize(18)
        passwordLabel.frame = CGRectMake(40, label_hight + 105, 100, 30)
        
        passwordText.frame = CGRectMake(40, label_hight + 105, width - 20, 40)
        passwordText.borderStyle = .RoundedRect
        passwordText.placeholder = "Password"
        passwordText.layer.borderColor = myColor.CGColor
        passwordText.secureTextEntry = true

        loginButton.setTitle("Log In", forState: .Normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFontOfSize(18)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        loginButton.setTitleColor(UIColor.blueColor(), forState: .Highlighted)
        loginButton.addTarget(self, action: Selector("loginAction:"), forControlEvents: .TouchUpInside)
        loginButton.frame = CGRectMake(40, label_hight + 162, width-20, 40)
        loginButton.backgroundColor = UIColor.lightGrayColor()
        
        registerButton.setTitle("Sign Up", forState: .Normal)
        registerButton.titleLabel?.font = UIFont.boldSystemFontOfSize(18)
        registerButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        registerButton.setTitleColor(UIColor.blueColor(), forState: .Highlighted)
        registerButton.addTarget(self, action: Selector("RegisterAction:"), forControlEvents: .TouchUpInside)
        registerButton.frame = CGRectMake(40, label_hight + 250, width-20, 40)
        
        self.scrollView.addSubview(imageView)
        self.scrollView.addSubview(userNameText)
        self.scrollView.addSubview(passwordText)
        self.scrollView.addSubview(loginButton)
        self.scrollView.addSubview(registerButton)
        self.view.addSubview(scrollView)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("DismissKeyboard:"))
        view.addGestureRecognizer(tap)
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginAction(sender: UIButton) {
        if UserInfoManager.getInstance().logInFunction(userNameText.text!, password: passwordText.text!){
            let DashBoardView = self.storyboard?.instantiateViewControllerWithIdentifier("DashBoard") as! DashBoardViewController
            DashBoardView.incomming_string = userNameText.text!
            let navController = UINavigationController(rootViewController: DashBoardView)
            self.presentViewController(navController, animated: true, completion: nil)
        }
        else{
            AlertMessage("Username or Password may be wrong.")
        }
    }
    @IBAction func RegisterAction(sender: AnyObject) {
        if(userNameText.text == "" || passwordText.text == ""){
            AlertMessage("Username or Password cannot be empty.")
        }
        else{
            if UserInfoManager.getInstance().addUserInfoData(userNameText.text!, password: passwordText.text!){
                AlertMessage("Register successfully.")
            }
            else{
                AlertMessage("Register Unsuccessfully. User name exists")
            }
        }
    }
    
    func AlertMessage(Message: String){
        let alertMessage = UIAlertController(title: "Alert", message: Message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertMessage.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction) in
            print("Handle Ok logic here")
        }))
        
        presentViewController(alertMessage, animated: true, completion: nil)
    }
    
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
        if let userInfo = notification.userInfo {
            if let keyboardSize: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size {
                let contentInset = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height,  0.0);
                
                self.scrollView.contentInset = contentInset
                self.scrollView.scrollIndicatorInsets = contentInset
                
                self.scrollView.contentOffset = CGPointMake(30, 0 + keyboardSize.height)
            }
        }
    }
    
    func keyboardWillBeHidden (notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let _: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size {
                let contentInset = UIEdgeInsetsZero;
                
                self.scrollView.contentInset = contentInset
                self.scrollView.scrollIndicatorInsets = contentInset
                self.scrollView.contentOffset = CGPointMake(30, self.scrollView.contentOffset.y)
            }
        }
    }
    
    @IBAction func unwindFromDashBoard(segue: UIStoryboardSegue){
        self.scrollView.contentOffset = CGPoint(x: 30, y: 80)
        userNameText.text = ""
        passwordText.text = ""
    }
    
}
