//
//  MapTestViewController.swift
//  iMap
//
//  Created by OlivierDemolliens on 22/10/14.
//  Copyright (c) 2014 dreamteam. All rights reserved.
//

import UIKit
import ODMapSDK;
import CoreLocation;
import MapKit;

class MapTestViewController: ODMapViewController {

    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder);
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
        self.model = ODMapViewModel(userLocation: true,buildings: false,pointOfInterests: false);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        var longitude:CLLocationDegrees = 41.8991623;
        var latitude:CLLocationDegrees = 12.47307180000007;
       
        // Latitude delta: The map will look more zoom-in
        var latDelta:CLLocationDegrees = 0.1
        // Longitude delta
        var longDelta:CLLocationDegrees = 0.1
        // It defines the latitude and longitude directions to show on a map.
        var spanCoordinate: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        // Set the location
        var myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        // Create a region: it defines which portion of the map to display
        var theRegion:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, spanCoordinate)
        // Set the region in the mapview
        self.mapView.setRegion(theRegion, animated: true)
        // Add an annotation on the center of the map (PIN)
        
        
        var mapObject : ODMapObject = ODMapObject(location: myLocation);
        mapObject.title = "Piazza Navona"
        // Subtitle of the pin
        mapObject.subtitle = "Roma, Italy"
        mapObject.iconPin = "violet";
        
        var myLocationAnnotation = ODAnnotation(content:mapObject)
        // Coordinate of the pin
        myLocationAnnotation.coordinate = myLocation
        // Title of the pin
        myLocationAnnotation.title = "Piazza Navona"
        // Subtitle of the pin
        myLocationAnnotation.subtitle = "Roma, Italy"
        // Add the annotation to the mapview
        self.mapView.addAnnotation(myLocationAnnotation)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
