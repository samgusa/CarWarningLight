//
//  RequestPermission.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 4/25/21.
//  Copyright © 2021 simplyAmazingMachines. All rights reserved.
//

import Foundation
import AppTrackingTransparency
import AdSupport


func requestPermission() {
   if #available(iOS 14, *) {
       ATTrackingManager.requestTrackingAuthorization { status in
           switch status {
           case .authorized:
               // Tracking authorization dialog was shown
               // and we are authorized
               print("Authorized")
               
               // Now that we are authorized we can get the IDFA
               print(ASIdentifierManager.shared().advertisingIdentifier)
           case .denied:
               // Tracking authorization dialog was
               // shown and permission is denied
               print("Denied")
           case .notDetermined:
               // Tracking authorization dialog has not been shown
               print("Not Determined")
           case .restricted:
               print("Restricted")
           @unknown default:
               print("Unknown")
           }
       }
   } else {
       // Fallback on earlier versions
   }
}
