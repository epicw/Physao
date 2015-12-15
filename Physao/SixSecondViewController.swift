//
//  SixSecondViewController.swift
//  Physao
//
//  Created by Weiqi Wei on 15/11/17.
//  Copyright © 2015年 Physaologists. All rights reserved.
//

import UIKit
import CoreBluetooth

class SixSecondViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    // MARK: Properties
    // for the countdown timer
    let TIMERVIEW_RADIUS: CGFloat = 50
    let BORDER_WIDTH: CGFloat = 2
    var timer = NSTimer()
    let timeInterval: NSTimeInterval = 0.5
    let timerStart: NSTimeInterval = 6.0
    var timerVal: NSTimeInterval = 6.0
    let circleView: UIView = UIView()
    let timerLabel: UILabel = UILabel()
    // for the animation
    var alienView = UIImageView()
    // the reset button
    let resetButton = UIButton()
    // the scrollview
    var scrollView = UIScrollView()
    
    // bluetooth properties
    var centralManager:CBCentralManager!
    var connectingPeripheral:CBPeripheral!
    var data: [String] = [""]
    // some variables from Physao team
    var isInhale: Bool = false
    var isMeasuring: Bool = false
    let threshold: Double = 270
    var count: Int = 0

    
    // view related functions
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.centralManager.stopScan()
        print("scanning stopped")
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Initializing central manager")
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        // customize the scrollview
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.contentSize = self.view.bounds.size
        scrollView.contentOffset = CGPoint(x: 0, y: 80)
        scrollView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        // animation: blow away a sailing boat & countdown timer
        /* add a custom Circle view */
        circleView.frame = CGRectMake(self.view.center.x-TIMERVIEW_RADIUS, self.view.center.y+2*TIMERVIEW_RADIUS, 2*TIMERVIEW_RADIUS, 2*TIMERVIEW_RADIUS)
        circleView.layer.cornerRadius = TIMERVIEW_RADIUS
        circleView.layer.borderColor = UIColor.blackColor().CGColor
        circleView.layer.borderWidth = BORDER_WIDTH
        self.scrollView.addSubview(circleView)
        /* add a custom Label */
        timerLabel.frame = circleView.bounds
        timerLabel.text = timeString(timerVal)
        timerLabel.textColor = UIColor.blackColor()
        timerLabel.font = UIFont(name: "MarkerFelt-Thin", size: 40)
        timerLabel.textAlignment = NSTextAlignment.Center
        circleView.addSubview(timerLabel)
        // add the animation
        let alienImage = UIImage(named: "alien.png")
        alienView = UIImageView(image: alienImage)
        alienView.frame = CGRectMake(800, 90, 200, 180) // the  sitting point after the animation is over (the default position)
        self.scrollView.addSubview(alienView)
        // add the reset button
        let buttonX = self.view.frame.size.width - 90.0
        let buttonY = self.view.frame.size.height - 90.0
        resetButton.frame = CGRectMake(buttonX, buttonY, 90.0, 90.0)
        resetButton.setImage(UIImage(named: "reset.png"), forState: UIControlState.Normal)
        resetButton.addTarget(self, action: Selector("resetFunc:"), forControlEvents: .TouchUpInside)
        self.scrollView.addSubview(resetButton)
        self.view.addSubview(scrollView)
        // Do any additional setup after loading the view.
        /*-------------------------for now, start timer and animation once going to this view, but later can cancel this setting and trigger timer and animation when user start blowing-----------------*/
        startTimer()
        startAnimation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // countdown timer format
    func timeString(time: NSTimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = time - Double(minutes) * 60
        return String(format:"%02i:%02i",minutes,Int(seconds))
    }
    
    // animation: blow away a sailing boat & countdown timer
    /*------------------------------to start timer, can be used when user start blowing-------------------*/
    func startTimer() {
        timerLabel.text = timeString(timerVal)
        timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval
            , target: self, selector: Selector("timerDidEnd:"), userInfo: nil, repeats: true)
    }

    
    func timerDidEnd(timer: NSTimer) {
        timerVal = timerVal - timeInterval
        if(timerVal <= 0) {
            timerLabel.text = "Done"
            timer.invalidate()
        }
        else {
            timerLabel.text = timeString(timerVal)
        }
    }
    
    func resetTimer() {
        timer.invalidate()
        timerVal = timerStart
        timerLabel.text = timeString(timerVal)
    }
    
    /*------------------------to trigger the animation, can be used when user start blowing----------------*/
    func startAnimation() {
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 295,y: 350)) // the current point
        path.addCurveToPoint(CGPoint(x: 0, y: 90), controlPoint1: CGPoint(x: 0, y: 373), controlPoint2: CGPoint(x: 700, y: 110))
        let anim = CAKeyframeAnimation(keyPath: "position")
        anim.path = path.CGPath
        anim.rotationMode = kCAAnimationRotateAuto
        anim.repeatCount = 1
        anim.duration = 6.0
        self.alienView.transform = CGAffineTransformMakeScale(1.5, 1.5)
        UIView.animateWithDuration(6.0 ,
            animations: {
                // the size of the alien changes during animation
                self.alienView.transform = CGAffineTransformMakeScale(0.5, 0.5)
            },
            completion: { finish in
                UIView.animateWithDuration(6.0){
                }
        })
        alienView.layer.addAnimation(anim, forKey: "animate position along path")
    }

    /*----------------------for now, we trigger the timer and animation both using reset button, but later, once the Physao team finished the calculation part, and connect the device, they can instead trigger the timer and animation using the functions above when user starts blowing----------------------*/    
    @IBAction func resetFunc(sender: UIButton) { // should only reset the timer? not to trigger the timer or animation?
        // reset timer
        resetTimer()
        startTimer()
        // reset animation
        startAnimation()
    }
    
    // Central Manager Delegate methods
    // did update state
    func centralManagerDidUpdateState(central: CBCentralManager) {
        print("checking state")
        switch(central.state) {
        case .PoweredOff:
            print("CB BLE hw is powered off")
            
        case .PoweredOn:
            print("CB BLE hw is powered on")
            self.scan()
            
        default:
            return
        }
    }
    
    func scan() {
        self.centralManager.scanForPeripheralsWithServices(nil,options: nil)
        print("scanning started\n\n\n")
    }
    
    // did discover peripheral
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        if (peripheral.name == HMSoftname) {
            print("discovered \(peripheral.name) at \(RSSI)")
            if connectingPeripheral != peripheral {
                connectingPeripheral = peripheral
                connectingPeripheral.delegate = self
                print("connecting to peripheral \(peripheral)")
                centralManager.connectPeripheral(connectingPeripheral, options: nil)
            }
            
        }
    }
    
    // did connect peripheral
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        print("\n\nperipheral connected\n\n")
        centralManager.stopScan()
        peripheral.delegate = self as CBPeripheralDelegate
        peripheral.discoverServices(nil)
    }
    
    // did fail to connect peripheral
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        print("failed to connect to \(peripheral) due to error \(error)")
        self.cleanup()
    }
    
    func cleanup() {
        switch connectingPeripheral.state {
        case .Disconnected:
            print("cleanup called, .Disconnected")
            return
        case .Connected:
            if (connectingPeripheral.services != nil) {
                print("found")
                //add any additional cleanup code here
            }
        default:
            return
        }
    }
    
    // did discover service
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        if let _ = error {
            print("error discovering services \(error!.description)")
            self.cleanup()
        }
        else {
            for service in peripheral.services as [CBService]!{
                print("service UUID  \(service.UUID)\n")
                if (service.UUID == CBUUID(string: "FFE0")) { // serviceUUID
                    peripheral.discoverCharacteristics(nil, forService: service)
                }
            }
        }
    }
    
    // did discover characteristic for service
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        if let _ = error {
            print("error - \(error!.description)")
            print(error)
            self.cleanup()
        }
        else {
            for characteristic in service.characteristics as [CBCharacteristic]! {
                print("characteristic is \(characteristic)\n")
                if (characteristic.UUID == CBUUID(string: "FFE1")) { // characteristicUUID
                    peripheral.setNotifyValue(true, forCharacteristic: characteristic)
                }
            }
        }
    }
    
    // did update notification state for characteristic
    func peripheral(peripheral: CBPeripheral, didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        if let _ = error {
            print("error changing notification state \(error!.description)")
        }
        if (characteristic.UUID != CBUUID(string: "FFE1")) {
            return
        }
        if (characteristic.isNotifying) {
            print("notification began on \(characteristic)")
        }
        else {
            print("notification stopped on \(characteristic). Disconnecting")
            self.centralManager.cancelPeripheralConnection(peripheral)
        }
    }
    
    // did update value for characteristic
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        if let _ = error {
            print("error")
        }
        else {
            let nsdata: NSData = characteristic.value!
            var count = nsdata.length / sizeof(UInt8)
            var byteData = [UInt8](count: count, repeatedValue: 0)
            nsdata.getBytes(&byteData, length:count * sizeof(UInt8)) // copy nsdata to byteData
            
            var bVal: Int = 0
            let comb = NSData(bytes: byteData, length: 4)
            comb.getBytes(&bVal, length: 4)
            bVal = Int(UInt32(bigEndian: UInt32(bVal))) // var bVal: Int = [[NSNumber numberWithUnsignedChar:byteData] intValue]; (obj-c version, from Physao team)
            let offsetAmp: Int = 75
            let bValScaled: Double = 30 * sqrt(fabs(1024 - Double(offsetAmp) - pow(Double(bVal)/8.0, 2))) // double bValScaled = 30 * sqrt(fabs(1024 - offsetAmp - pow(bVal/8.0, 2))); (obj-c version, from Physao team)
            
            if(isMeasuring == false && bValScaled > threshold) {
                // as soon as the user blows, it triggers the timer and the animation
                /*-----------------for now the problem is: there is some delay between user blow and bluetooth starts receiving data, I hope it's just because of this part is not fully funcationality--------------------------------*/
                startTimer()
                startAnimation()
                
                isMeasuring = true
                // If last measurement was not an inhalation, then this one is
                isInhale = !isInhale
                count += 1
            }
            // After one complete inhalation or exhalation, the flow goes back below threshold
            else if(isMeasuring == true && bValScaled < threshold) {
                isMeasuring = false
                // NSString* arrayText = [self.measureList componentsJoinedByString: @"| "]; (obj-c version, from Physao team)
                // var arrayText: String = data.joinWithSeparator("| ") // parse the data received & calculated (swift version)
                // TODO: divide into three: FVCValue,FEV1Value,PEFRValue (leave it to the physao team after they finished the calculating part)
                
                // Count reaches 2 when patient has inhaled (1) and exhaled (2)
                // Once inhaled and exhaled, cut off bluetooth connection and save the data
                if(count == 2) {
                    // cancel connection
                    peripheral.setNotifyValue(false, forCharacteristic: characteristic)
                    centralManager.cancelPeripheralConnection(peripheral)
                }
            }
            // Collect data into array until you have to save it
            if(isMeasuring == true) {
                // Append value to measurement array
                //self.data addObject:[NSString stringWithFormat:@"%g", bValScaled]]; (obj-c version, from Physao team)
                self.data.append(NSString(format: "%g", bValScaled) as String)
            }
        }
    }
    
    // did disconnect peripheral
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        print("didDisconnect error is \(error)")
    }
    
    // transmit data to immediate feedback view & store in the healthkit
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        // super.prepareForSegue(segue, sender: sender)
        if(segue.identifier == "sixFeed") {
            if let destinationVC = segue.destinationViewController as? UINavigationController {
                let dest = destinationVC.topViewController as! ImmediateFeedbackViewController
                // derive these three values (fvc, fev1, pefr) from bytedata above
                //Saving Random values to HealthKit.
                let now:NSDate = NSDate()
                let fvcVal = Double(arc4random_uniform(6) + 1)
                let fev1Val = Double(arc4random_uniform(3) + 1)
                let pefrVal = Double(arc4random_uniform(2) + 1)
                let thisSample:PhysaoSample = PhysaoSample(time: now, FVCValue: fvcVal, FEV1Value: fev1Val, PEFRValue: pefrVal)
                thisSample.save(healthKitSharedInstance)
                dest.fvcVal.text = String(fvcVal)
                dest.fev1Val.text = String(fev1Val)
                dest.pefrVal.text = String(pefrVal)
            }
        }
    }
}
