//
//  ODDeviceUtil.swift
//  ODSwiftUtil
//
//  Created by OlivierDemolliens on 31/10/14.
//  Copyright (c) 2014 dreamteam. All rights reserved.
//

import Foundation

/* Device Util
* Some information about the current device
*/
public class ODDeviceUtil : NSObject {
    
    
    /* Is a retina device
    * Return true if the device support retina
    */
    public class func isRetinaDevice() -> Bool {
        var retina : Bool = false;
        
        if(UIScreen.instancesRespondToSelector(Selector("scale"))){
            var scale : CGFloat = UIScreen.mainScreen().scale;
            if(scale>1){
                retina = true;
            }
            
            //
        }
        return retina;
    }
    
    /* Is an iPad
    * Return true if the device is an iPad
    */
    public class func isAnIpad() -> Bool {
        if(UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad){
            return true;
        }else{
            return false;
        }
    }
    
    
    /* Region format
    * return the current user region format
    */
    public class func regionFormat() -> NSString {
        return NSLocale.currentLocale().localeIdentifier;
    }
    
    
    
}