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
import CoreLocation;
import MapKit;

// MARK : Google maps
private let kGoogleMapsName : NSString = "Google Maps";
private let kGoogleMapsNavigation : NSString = "http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f";
private let kGoogleMapsUrlScheme : NSString = "comgooglemaps://";
private let kGoogleMapsUrlSchemeNavigation : NSString = "comgooglemaps://?saddr=%f,%f&daddr=%f,%f";

// MARK : Apple maps
private let kAppleMapsName : NSString = "Maps";
private let kAppleMapsNavigation : NSString = "http://maps.apple.com/maps?saddr=%f,%f&daddr=%f,%f";


// MARK : Navigon
private let kNavigonName : NSString = "Navigon";
private let kNavigonUrlScheme : NSString = "navigon://";
private let kNavigonUrlSchemeNavigation : NSString = "navigon://coordinate/%@/%f/%f";


// MARK : TomTom
private let kTomTomName : NSString = "Tom Tom";
private let kTomTomUrlScheme : NSString = "tomtomhome://";
private let kTomTomUrlSchemeNavigation : NSString = "tomtomhome:geo:action=show&lat=%f&long=%f&name=%@";

/* Navigation Helper
* Provide an easy way to launch GPS with some functions
*/

public class ODNavigationHelper {
    
    
    // MARK : Private functions
    
    
    /* Launch With Url
    * Call an url from the current application
    */
    private class func launchWithUrl(url anUrl : NSString){
        var url : NSURL = NSURL(string: anUrl)!;
        UIApplication.sharedApplication().openURL(url);
    }
    
    
    /* Can Launch With Url
    * Verify if an url can launch an url from the current application
    */
    private class func canLaunchWithUrl(url anUrl : NSString) -> Bool{
        var url : NSURL = NSURL(string: anUrl)!;
        return UIApplication.sharedApplication().canOpenURL(url);
    }
    
    // MARK : Public functions
    
    
    // MARK : Apple maps function
    
    public class func showRouteWithAppleMaps(fromLocation from : CLLocationCoordinate2D, to : CLLocationCoordinate2D) -> Void {
        ODNavigationHelper.launchWithUrl(url: NSString(format: kAppleMapsNavigation,from.latitude, from.longitude, to.latitude, to.longitude));
    }
    
    // MARK : Google maps function
    
    public class func showRouteWithGoogleMaps(fromLocation from : CLLocationCoordinate2D, to : CLLocationCoordinate2D) -> Void {
        ODNavigationHelper.launchWithUrl(url: NSString(format: kGoogleMapsNavigation,from.latitude, from.longitude, to.latitude, to.longitude));
    }
    
    /* Is Google Maps App Installed
    * Return true if the Google Maps app is installed
    */
    public class func isGoogleMapsAppInstalled() -> Bool {
        return ODNavigationHelper.canLaunchWithUrl(url: kGoogleMapsUrlScheme);
    }
    
    // MARK : Navigon GPS function
    
    public class func showRouteWithNavigon(toLocation to : CLLocationCoordinate2D) -> Void {
        ODNavigationHelper.launchWithUrl(url: NSString(format: kNavigonUrlSchemeNavigation, to.latitude, to.longitude));
    }
    
    /* Is Navigon App Installed
    * Return true if the Navigon app is installed
    */
    public class func isNavigonAppInstalled() -> Bool {
        return ODNavigationHelper.canLaunchWithUrl(url: kNavigonUrlScheme);
    }
    
    // MARK : TomTom GPS function
    
    public class func showRouteWithTomTom(toLocation to : CLLocationCoordinate2D) -> Void {
        ODNavigationHelper.launchWithUrl(url: NSString(format: kTomTomUrlSchemeNavigation, to.latitude, to.longitude,""));
    }
    
    /* Is Tom Tom App Installed
    * Return true if the Tom Tom app is installed
    */
    public class func isTomTomAppInstalled() -> Bool {
        return ODNavigationHelper.canLaunchWithUrl(url: kTomTomUrlScheme);
    }
    
    // MARK : ActionSheet function
    
    /* Show GPS Action Sheet
    * Provide an prepared Action Sheet with all GPS available
    */
    public class func showGPSActionSheet(displayOn : UIActionSheetDelegate, title : NSString, cancelButtonTitle : NSString) -> UIActionSheet {
        
        var actionSheet : UIActionSheet = UIActionSheet();
        var actionSheetItem : NSMutableArray = NSMutableArray();
        
        var hasGoogleMaps : Bool = ODNavigationHelper.isGoogleMapsAppInstalled();
        var hasTomTom : Bool = ODNavigationHelper.isTomTomAppInstalled();
        var hasNavigon : Bool = ODNavigationHelper.isNavigonAppInstalled();
        
        
        //Default GPS
        actionSheetItem.addObject(kAppleMapsName);
        
        if(hasGoogleMaps){
            actionSheetItem.addObject(kGoogleMapsName);
        }
        
        if(hasTomTom){
            actionSheetItem.addObject(kTomTomName);
        }
        
        if(hasNavigon){
            actionSheetItem.addObject(kNavigonName);
        }
        
        actionSheet = UIActionSheet(title: title, delegate: displayOn, cancelButtonTitle: nil, destructiveButtonTitle: cancelButtonTitle);
        
        for(var i = 0 ; i < actionSheetItem.count; i++){
            var titleButton = actionSheetItem.objectAtIndex(i) as NSString;
            actionSheet.addButtonWithTitle(titleButton);
        }
        
        return actionSheet;
    }
    
    /* Show GPS Action Sheet
    * Override of optional func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int)
    */
    public class func actionSheetTouch(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int, from : CLLocationCoordinate2D, to : CLLocationCoordinate2D) -> Void {
        
        if(buttonIndex != -1){
            
            var choice : NSString = (actionSheet.buttonTitleAtIndex(buttonIndex));
            
            if(buttonIndex == actionSheet.destructiveButtonIndex){
                //Cancel, nothing to do
            }else{
                
                if(choice.isEqualToString(kGoogleMapsName)){
                    ODNavigationHelper.showRouteWithGoogleMaps(fromLocation:from, to: to);
                }else if(choice.isEqualToString(kAppleMapsName)){
                    ODNavigationHelper.showRouteWithAppleMaps(fromLocation:from, to: to);
                }else if(choice.isEqualToString(kNavigonName)){
                    ODNavigationHelper.showRouteWithNavigon(toLocation:to);
                }else if(choice.isEqualToString(kTomTomName)){
                    ODNavigationHelper.showRouteWithTomTom(toLocation:to);
                }else{
                    NSLog("actionSheetTouch - unknow choice");
                }
                
            }
        }
    }
    
}
