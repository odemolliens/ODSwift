//
//Copyright 2014 Olivier Demolliens - @odemolliens
//
//Licensed under the Apache License, Version 2.0 (the "License"); you may not use this
//
//file except in compliance with the License. You may obtain a copy of the License at
//
//http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software distributed under
//
//the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
//
//ANY KIND, either express or implied. See the License for the specific language governing
//
//permissions and limitations under the License.
//
//

import Foundation

private let kDeviceUtilScale : NSString = "scale";
private let kDeviceUtilAppleLanguages : NSString = "AppleLanguages";

/* Device Util
* Some information about the current device
*/
public class ODDeviceUtil : NSObject {
    
    
    /* Is a retina device
    * Return true if the device support retina
    */
    public class func isRetinaDevice() -> Bool {
        var retina : Bool = false;
        
        if(UIScreen.instancesRespondToSelector(Selector(kDeviceUtilScale))){
            var scale : CGFloat = UIScreen.mainScreen().scale;
            if(scale>1){
                retina = true;
            }
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
    
    /* User Langage
    * Get current user langage
    */
    public class func userLangage() -> NSString {
        var defs : NSUserDefaults = NSUserDefaults.standardUserDefaults();
        var langages : NSArray = defs.objectForKey(kDeviceUtilAppleLanguages) as NSArray;
        return langages.objectAtIndex(0) as NSString;
    }
    
    
}