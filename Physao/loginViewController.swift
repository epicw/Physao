//
//  loginViewController.swift
//  Physao
//
//  Created by Weiqi Wei on 15/11/19.
//  Copyright © 2015年 Physaologists. All rights reserved.
//

import UIKit

class loginViewController: UIViewController {
    
    @IBOutlet weak var userNameText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        userNameText.text = "haoli"
        passwordText.text = "11"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(sender: AnyObject) {
        if UserInfoManager.getInstance().logInFunction(userNameText.text!, password: passwordText.text!){
            let DashBoardView = self.storyboard?.instantiateViewControllerWithIdentifier("DashBoard") as! DashBoardViewController
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
    
    @IBAction func unwindFromDashBoard(segue: UIStoryboardSegue){
        userNameText.text = ""
        passwordText.text = ""
    }
    
}
