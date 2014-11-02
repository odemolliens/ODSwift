//
//  MapHelper.swift
//  AddressMap
//
//  Created by md arifuzzaman on 7/15/14.
//  Copyright (c) 2014 md arifuzzaman. All rights reserved.
//

import Foundation
import MapKit

//Google MAP services
let kMapHelperGoogleMapGeoCode = "http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@";

//Util for parse
let kMapHelperLat : NSString = "\"lat\" :";
let kMapHelperLong : NSString = "\"lng\" :";


class ODMapHelper : NSObject {
    
    /* findGeoCode
    * Find Geo position with an address with Google Maps service
    * address -> address searched
    * return nil or filled CLLocationCoordinate2D
    */
    func findGeoCode( address : NSString ) -> CLLocationCoordinate2D? {
        
        var latitude : Double = 0.0;
        
        var longitude : Double = 0.0;
        
        // Manage accent
        var address_utf : NSString = address.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!;
        
        //Service used to retrieve long/lat
        
        var req : NSString = NSString(format: kMapHelperGoogleMapGeoCode,address_utf);
        
        var result : NSString? = NSString(contentsOfURL: NSURL(string: req)!, encoding: 1, error: nil);
        
        if let value = result {
            
            let scanner : NSScanner = NSScanner(string: value);
            
            if(scanner.scanUpToString(kMapHelperLat, intoString: nil) && scanner.scanString(kMapHelperLat, intoString: nil)){
                scanner.scanDouble(&latitude)
            }
            
            if(scanner.scanUpToString(kMapHelperLong, intoString: nil) && scanner.scanString(kMapHelperLong, intoString: nil)){
                scanner.scanDouble(&longitude);
            }
            
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude);
            
        }
        else{
            
            return nil;
        }
    }
    
    /* arrayNear
    * Provide near points from a location define by some parameters
    * location -> location where u want get near other locations
    * radius -> defined the area around the selected location
    * objs -> POI list
    */
    class func arrayNear(location : CLLocation, radius : CLLocationDistance, objs : NSArray) -> NSArray {
        
        var locations : NSSet = NSSet(array: objs);
        
        var centerLocation : CLLocation = location;
        var radius : CLLocationDistance = radius;
        
        var nearbyLocations : NSSet;
        
        nearbyLocations = locations.objectsPassingTest ({ (object:AnyObject!, pointer:UnsafeMutablePointer<ObjCBool>) -> Bool in
            
            var testCoordinate : CLLocationCoordinate2D?;
            
            
            if let newObject: AnyObject = object {
                var testObject = newObject as ODMapObject;
                testCoordinate = testObject.coordinate;
            }

            if let coord = testCoordinate {
                var testLocation : CLLocation = CLLocation(latitude: coord.latitude, longitude: coord.longitude);
                
                var returnValue : Bool = (centerLocation.distanceFromLocation(testLocation) <= radius);
                
                return returnValue;
            }else{
                return false;
            }
            
        });
        
        return nearbyLocations.allObjects;
    }
}