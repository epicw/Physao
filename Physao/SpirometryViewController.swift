//
//  SpirometryViewController.swift
//  Physao
//
//  Created by Weiqi Wei on 15/11/17.
//  Copyright © 2015年 Physaologists. All rights reserved.
//

import UIKit

class SpirometryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
        let twoSecondButton = UIButton()
        let buttonWidth = self.view.frame.size.width - 20.0
        let buttonHeight = (self.view.frame.size.height - 100) / 2.0
        twoSecondButton.frame = CGRectMake(10, 80, buttonWidth, buttonHeight)
        twoSecondButton.setImage(UIImage(named: "2-second.png"), forState: UIControlState.Normal)
        twoSecondButton.addTarget(self, action: Selector("twoSecondAnimation:"), forControlEvents: .TouchUpInside)
        
        let sixSecondButton = UIButton()
        sixSecondButton.frame = CGRectMake(twoSecondButton.frame.origin.x, twoSecondButton.frame.origin.y + twoSecondButton.frame.size.height + 10, buttonWidth, buttonHeight)
        sixSecondButton.setImage(UIImage(named: "6-second.png"), forState: UIControlState.Normal)
        sixSecondButton.addTarget(self, action: Selector("sixSecondAnimation:"), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(twoSecondButton)
        self.view.addSubview(sixSecondButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func twoSecondAnimation(sender: UIButton){
        let twoSecondView = self.storyboard?.instantiateViewControllerWithIdentifier("twoSecondView") as! twoSecondViewController
        let navController = UINavigationController(rootViewController: twoSecondView)
        self.presentViewController(navController, animated: true, completion: nil)
        
    }
    
    @IBAction func sixSecondAnimation(sender: UIButton){
        let sixSecondView = self.storyboard?.instantiateViewControllerWithIdentifier("sixSecondView") as! SixSecondViewController
        let navController = UINavigationController(rootViewController: sixSecondView)
        self.presentViewController(navController, animated: true, completion: nil)
    }
    
    @IBAction func unwindFromTwoSecond(segue: UIStoryboardSegue){
    
    }

    @IBAction func unwindFromSixSecond(segue: UIStoryboardSegue){
    
    }
    
    @IBAction func unwindFromImmediateFeedback(segue: UIStoryboardSegue){
    
    }
}
