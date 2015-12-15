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
    
    var fvcLabel = UILabel()
    var fvcVal = UILabel()
    var fev1Label = UILabel()
    var fev1Val = UILabel()
    var pefrLabel = UILabel()
    var pefrVal = UILabel()
    var scrollView = UIScrollView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // customize the scrollview
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.contentSize = self.view.bounds.size
        scrollView.contentOffset = CGPoint(x: 0, y: 80)
        scrollView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        // three images
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
        fvcVal.frame = CGRectMake(self.view.center.x-20, self.view.center.y+80, 90, 20)
        fev1Label.frame = CGRectMake(self.view.center.x-120, self.view.center.y+115, 60, 20)
        fev1Label.text = "FEV1:"
        fev1Val.frame = CGRectMake(self.view.center.x-20, self.view.center.y+115, 90, 20)
        pefrLabel.frame = CGRectMake(self.view.center.x-120, self.view.center.y+150, 60, 20)
        pefrLabel.text = "PEFR:"
        pefrVal.frame = CGRectMake(self.view.center.x-20, self.view.center.y+150, 90, 20)
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
        // According to the fvc, fev1, and pefr transmitted from the blow mode view controller to decide whether it's a smile face, neutral face, or sad face (Physao team will do those calculation)
        self.scrollView.addSubview(smileView) // by default for now
    }
    
}
