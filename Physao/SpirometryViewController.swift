//
//  SpirometryViewController.swift
//  Physao
//
//  Created by Weiqi Wei on 15/11/17.
//  Copyright © 2015年 Physaologists. All rights reserved.
//

import UIKit

class SpirometryViewController: UIViewController {
    
    // MARK: Properties
    let twoSecondButton = UIButton()
    let sixSecondButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let buttonWidth = self.view.frame.size.width - 20.0
        let buttonHeight = (self.view.frame.size.height - 100) / 2.0
        twoSecondButton.frame = CGRectMake(10, 80, buttonWidth, buttonHeight)
        twoSecondButton.setImage(UIImage(named: "2-second.png"), forState: UIControlState.Normal)
        
        sixSecondButton.frame = CGRectMake(twoSecondButton.frame.origin.x, twoSecondButton.frame.origin.y + twoSecondButton.frame.size.height + 10, buttonWidth, buttonHeight)
        sixSecondButton.setImage(UIImage(named: "6-second.png"), forState: UIControlState.Normal)
        
        self.view.addSubview(twoSecondButton)
        self.view.addSubview(sixSecondButton)
        
        // swip gesture
        let swipeDown = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        self.twoSecondButton.addGestureRecognizer(swipeDown)
        let swipeUp = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        self.sixSecondButton.addGestureRecognizer(swipeUp)
        // Do any additional setup after loading the view.
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                print("Swiped right")
            case UISwipeGestureRecognizerDirection.Down:
                // two sec
                // animation & fadeout
                UIView.animateWithDuration(0.45, animations: {
                    // the two sec image goes down until out of the bound
                    self.twoSecondButton.frame = CGRectMake(self.twoSecondButton.frame.origin.x,
                        self.view.frame.height,
                        self.twoSecondButton.frame.size.width,
                        self.twoSecondButton.frame.size.height)
                    
                    self.sixSecondButton.fadeOut()
                    },
                    completion: { finish in    // after the completion of the animation, go to the next view
                        UIView.animateWithDuration(0.35){
                            self.performSegueWithIdentifier("segueTwoSecond", sender: self)
                        }
                })
            case UISwipeGestureRecognizerDirection.Left:
                print("Swiped left")
            case UISwipeGestureRecognizerDirection.Up:
                // six sec
                // animation & fadeout
                UIView.animateWithDuration(0.50, animations: {
                    // the six sec image goes up until out of the bound
                    self.sixSecondButton.frame = CGRectMake(self.sixSecondButton.frame.origin.x,
                        0-self.view.frame.height,
                        self.sixSecondButton.frame.size.width,
                        self.sixSecondButton.frame.size.height)
                    
                    self.twoSecondButton.fadeOut()
                    },
                    completion: { finish in    // after the completion of the animation, go to the next view
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

    @IBAction func unwindFromTwoSecond(segue: UIStoryboardSegue){
        // as the button fades out before, show it now again
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
        // as the button fades out before, show it now again
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
        // as the button fades out before, show it now again
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
