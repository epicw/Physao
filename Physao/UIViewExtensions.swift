//
//  UIViewExtensions.swift
//  Physao
//
//  Created by HAO LI on 11/6/15.
//  Copyright © 2015 Physaologists. All rights reserved.
//
import Foundation
import UIKit

// this extension is for the fadein and fadeout function
extension UIView {
	func fadeIn(duration: NSTimeInterval = 1.0, delay: NSTimeInterval = 0.0, completion: ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
		UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseIn, animations: {
			self.alpha = 1.0
			}, completion: completion)	}
	
	func fadeOut(duration: NSTimeInterval = 1.0, delay: NSTimeInterval = 0.0, completion: (Bool) -> Void = {(finished: Bool) -> Void in}) {
		UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseIn, animations: {
			self.alpha = 0.0
			}, completion: completion)
	}
}