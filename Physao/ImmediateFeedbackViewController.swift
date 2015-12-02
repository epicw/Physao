//
//  ImmediateFeedbackViewController.swift
//  Physao
//
//  Created by Weiqi Wei on 15/11/17.
//  Copyright © 2015年 Physaologists. All rights reserved.
//

import UIKit

class ImmediateFeedbackViewController: UIViewController {
    
    // MARK: Properties
    var smileView = UIImageView()
    var neutralView = UIImageView()
    var sadView = UIImageView()
    
    //var passedValues =
    
    var fvcLabel = UILabel()
    var fvcVal = UILabel()
    var fev1Label = UILabel()
    var fev1Val = UILabel()
    var pefrLabel = UILabel()
    var pefrVal = UILabel()
    var scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView = UIScrollView(frame: view.bounds)
        //scrollView.backgroundColor = UIColor.blackColor()
        scrollView.contentSize = self.view.bounds.size
        scrollView.contentOffset = CGPoint(x: 30, y: 80)
        scrollView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        let smileImage = UIImage(named: "smile.png")
        let neutralImage = UIImage(named: "neutral.png")
        let sadImage = UIImage(named: "sad.png")
        smileView = UIImageView(image: smileImage)
        neutralView = UIImageView(image: neutralImage)
        sadView = UIImageView(image: sadImage)
        let viewX = self.view.center.x - 100
        let viewY = self.view.center.y - 180
        let viewWidth = CGFloat(200)
        let viewHeight = CGFloat(200)
        smileView.frame = CGRectMake(viewX, viewY, viewWidth, viewHeight)
        neutralView.frame = CGRectMake(viewX, viewY, viewWidth, viewHeight)
        sadView.frame = CGRectMake(viewX, viewY, viewWidth, viewHeight)
        // display three values
        fvcLabel.frame = CGRectMake(self.view.center.x-120, self.view.center.y+80, 60, 20)
        fvcLabel.text = "FVC:"
        fvcVal.frame = CGRectMake(self.view.center.x-40, self.view.center.y+80, 90, 20)
        //fvcVal.backgroundColor = UIColor.blackColor()
        fev1Label.frame = CGRectMake(self.view.center.x-120, self.view.center.y+115, 60, 20)
        fev1Label.text = "FEV1:"
        fev1Val.frame = CGRectMake(self.view.center.x-40, self.view.center.y+115, 90, 20)
        //fev1Val.backgroundColor = UIColor.blackColor()
        pefrLabel.frame = CGRectMake(self.view.center.x-120, self.view.center.y+150, 60, 20)
        pefrLabel.text = "PEFR:"
        pefrVal.frame = CGRectMake(self.view.center.x-40, self.view.center.y+150, 90, 20)
        //pefrVal.backgroundColor = UIColor.blackColor()
        self.scrollView.addSubview(fvcLabel)
        self.scrollView.addSubview(fev1Label)
        self.scrollView.addSubview(pefrLabel)
        self.scrollView.addSubview(fvcVal)
        self.scrollView.addSubview(fev1Val)
        self.scrollView.addSubview(pefrVal)
        self.view.addSubview(scrollView)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        //passedValues
        //fvcVal.text =
        //fev1Val.text =
        //pefrVal.text =
        // TODO: According to the fvc, fev1, and pefr to decide whether it's a smile face, neutral face, or sad face
        self.scrollView.addSubview(smileView) // by default
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
