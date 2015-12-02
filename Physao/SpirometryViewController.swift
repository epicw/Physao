//
//  SpirometryViewController.swift
//  Physao
//
//  Created by Weiqi Wei on 15/11/17.
//  Copyright © 2015年 Physaologists. All rights reserved.
//

import UIKit

class SpirometryViewController: UIViewController {
    
    let twoSecondButton = UIButton()
    let sixSecondButton = UIButton()
    // TODO: swipe view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        let buttonWidth = self.view.frame.size.width - 20.0
        let buttonHeight = (self.view.frame.size.height - 100) / 2.0
        twoSecondButton.frame = CGRectMake(10, 80, buttonWidth, buttonHeight)
        twoSecondButton.setImage(UIImage(named: "2-second.png"), forState: UIControlState.Normal)
        //twoSecondButton.addTarget(self, action: Selector("twoSecondAnimation:"), forControlEvents: .TouchUpInside)
        
        
        sixSecondButton.frame = CGRectMake(twoSecondButton.frame.origin.x, twoSecondButton.frame.origin.y + twoSecondButton.frame.size.height + 10, buttonWidth, buttonHeight)
        sixSecondButton.setImage(UIImage(named: "6-second.png"), forState: UIControlState.Normal)
        //sixSecondButton.addTarget(self, action: Selector("sixSecondAnimation:"), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(twoSecondButton)
        self.view.addSubview(sixSecondButton)
        
        // two sec
        let swipeDown = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        self.twoSecondButton.addGestureRecognizer(swipeDown)
        // six sec
        let swipeUp = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        self.sixSecondButton.addGestureRecognizer(swipeUp)
        
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                print("Swiped right")
            case UISwipeGestureRecognizerDirection.Down:
                // two sec
                // print("Swiped down")
                // animation & fadeout
                UIView.animateWithDuration(0.45, animations: {
                    self.twoSecondButton.frame = CGRectMake(self.twoSecondButton.frame.origin.x,
                        self.view.frame.height,
                        self.twoSecondButton.frame.size.width,
                        self.twoSecondButton.frame.size.height)
                    
                    self.sixSecondButton.fadeOut()
                    },
                    completion: { finish in
                        UIView.animateWithDuration(0.35){
                            self.performSegueWithIdentifier("segueTwoSecond", sender: self)
                        }
                })
                
            case UISwipeGestureRecognizerDirection.Left:
                print("Swiped left")
            case UISwipeGestureRecognizerDirection.Up:
                // six sec
                // print("Swiped up")
                // animation & fadeout
                UIView.animateWithDuration(0.50, animations: {
                    self.sixSecondButton.frame = CGRectMake(self.sixSecondButton.frame.origin.x,
                        0-self.view.frame.height,
                        self.sixSecondButton.frame.size.width,
                        self.sixSecondButton.frame.size.height)
                    
                    self.twoSecondButton.fadeOut()
                    },
                    completion: { finish in
                        UIView.animateWithDuration(0.35){
                            self.performSegueWithIdentifier("segueSixSecond", sender: self)
                        }
                })
                
            default:
                break
            }
        }
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
    /*
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
    */
    @IBAction func unwindFromTwoSecond(segue: UIStoryboardSegue){
        let buttonWidth = self.view.frame.size.width - 20.0
        let buttonHeight = (self.view.frame.size.height - 100) / 2.0
        twoSecondButton.frame = CGRectMake(10, 80, buttonWidth, buttonHeight)
        self.view.addSubview(twoSecondButton)
        sixSecondButton.frame = CGRectMake(twoSecondButton.frame.origin.x, twoSecondButton.frame.origin.y + twoSecondButton.frame.size.height + 10, buttonWidth, buttonHeight)
        self.view.addSubview(sixSecondButton)
        
        self.twoSecondButton.fadeIn()
        self.sixSecondButton.fadeIn()
    }
    
    @IBAction func unwindFromSixSecond(segue: UIStoryboardSegue){
        let buttonWidth = self.view.frame.size.width - 20.0
        let buttonHeight = (self.view.frame.size.height - 100) / 2.0
        twoSecondButton.frame = CGRectMake(10, 80, buttonWidth, buttonHeight)
        self.view.addSubview(twoSecondButton)
        sixSecondButton.frame = CGRectMake(twoSecondButton.frame.origin.x, twoSecondButton.frame.origin.y + twoSecondButton.frame.size.height + 10, buttonWidth, buttonHeight)
        self.view.addSubview(sixSecondButton)
        
        self.twoSecondButton.fadeIn()
        self.sixSecondButton.fadeIn()
    }
    
    @IBAction func unwindFromImmediateFeedback(segue: UIStoryboardSegue){
        let buttonWidth = self.view.frame.size.width - 20.0
        let buttonHeight = (self.view.frame.size.height - 100) / 2.0
        twoSecondButton.frame = CGRectMake(10, 80, buttonWidth, buttonHeight)
        self.view.addSubview(twoSecondButton)
        sixSecondButton.frame = CGRectMake(twoSecondButton.frame.origin.x, twoSecondButton.frame.origin.y + twoSecondButton.frame.size.height + 10, buttonWidth, buttonHeight)
        self.view.addSubview(sixSecondButton)
        
        self.twoSecondButton.fadeIn()
        self.sixSecondButton.fadeIn()
    }
}
