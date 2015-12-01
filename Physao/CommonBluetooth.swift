//
//  CommonBluetooth.swift
//  Physao
//
//  Created by HAO LI on 11/6/15.
//  Copyright © 2015 Physaologists. All rights reserved.
//

import UIKit
import CoreBluetooth

let SERVICE_UUID = "40FA96F6-7C5F-4A71-B5A3-EE720DD96821"
// "973A007E-3C39-45C6-B2DD-0141DD82F973"
let CHARACTERISTIC_UUID = "FC4F78D8-1642-45AD-BBDC-368BF6E8C45C"
// "1D04E43A-4B06-41D9-A499-7594D94A7814"
let HMSoftCharacterUUID = "FC4F78D8-1642-45AD-BBDC-368BF6E8C45C"
let HMSoftServiceUUID = "6CD621DB-5ABF-AF50-1CD9-BDBC01412B5F"
let HMSoftService = "FFE0"
let HMSoftname = "HMSoft"

let MTU = 20
let serviceUUIDs:[AnyObject] = [CBUUID(string: SERVICE_UUID)]
let serviceUUID = CBUUID(string: SERVICE_UUID)
let characteristicUUIDs:[AnyObject] = [CHARACTERISTIC_UUID]
let characteristicUUID = CBUUID(string: CHARACTERISTIC_UUID)
let endOfMessage = "EOM".dataUsingEncoding(NSUTF8StringEncoding)
