//
//  PhysaoCodingGuidelines.swift
//  Physao
//
//  Created by Emmanuel Shiferaw on 11/3/15.
//  Copyright © 2015 Physaologists. All rights reserved.
//

// Comment at the top of the file what the file is for

// CODING GUIDELINES template document
// All style decisions from Physao team.

import UIKit

// MARK: Constants
let GLOBAL_CONSTANT:String = "Constant string"
/**
* Ensure names of classes, variables, anything are good in that
* the reader can understand exactly what the variable is just from name.
*/

/**
* Try to keep ViewController and file names consistent and understandable
* (you can tell what the viewcontroller is for immediately).
*/

class PhysaoCodingGuidelines: NSObject {

    //MARK: Instance Methods
    
    // Comment for each function
    func standardMethod() {
        
        // Single line comments will be followed by a space
        for var index = 0; index < 3; ++index {
            print("index is \(index):")
        }
        //Comment for variables, especially constants to let the reader know what the variable is used for
        var  variable:String = "Something"
        print(variable)
        variable = "Change me." // (unrelated to guidelines, just to silence XCode warning about unused var)
        
    }
    // One additional space after functions

    // For curly braces, keep them on the same line
    func secondMethod(){
        // For any use of the "=" for variable assignment (or any operator),
        // surround the "=" with one space.
        let number:Int = 12
        print(number)
        
    }
    
    //CODE ORGANIZATION:
    // If using Swift, use MARK, TODO, FIXME and comments to organize/label code
    // DO comment regularly around the code to let the reader know what it’s doing without having to read every line of the code
    
    

}
