//
//  ODMapViewController.swift
//  iMap
//
//  Created by OlivierDemolliens on 21/10/14.
//  Copyright (c) 2014 dreamteam. All rights reserved.
//

import UIKit;
import MapKit;
import CoreLocation;

/* ODMapViewController
* Easy way to manage the Map View
*
*/
public class ODMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, ODMapViewProtocolCallout , ODMapViewProtocolCoreLocation{
    
    //Util
    let needUserLocationPermission : Bool = ((UIDevice.currentDevice().systemVersion as NSString).doubleValue >= 8.0);
    
    //View properties
    
    @IBOutlet weak public var mapView: MKMapView!
    
    //Model
    
    public var model : ODMapViewModel;
    
    // MARK: View Cycle Life
    
    override public func viewDidLoad() {
        super.viewDidLoad();
        showOrNot();
    }
    
    // MARK: Contructors
    
    /* Constructor - NSCoder
    *
    */
    required public init(coder aDecoder: NSCoder) {
        // TODO : can be optimized - class func doesn't work
        self.model = ODMapViewModel();
        super.init(coder: aDecoder);
        self.model = ODMapViewModel(userLocation: self.showUserLocation(),buildings: self.showBuildings(),pointOfInterests: self.showPointOfInterests());
    }
    
    /* Constructor - NSCoder
    *
    */
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        // TODO : can be optimized - class func doesn't work
        self.model = ODMapViewModel();
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
        self.model = ODMapViewModel(userLocation: self.showUserLocation(),buildings: self.showBuildings(),pointOfInterests: self.showPointOfInterests());
    }
    
    // MARK: private functions
    
    /* Show or not
    * Check if some location function are actived. If true, it's display on the map
    */
    private func showOrNot() -> Void {
        if(self.model.showsUserLocation){
            
            let status = CLLocationManager.authorizationStatus();
            
            var locManager : CLLocationManager = CLLocationManager();
            locManager.delegate = self;
            
            if(needUserLocationPermission){
                if(status == CLAuthorizationStatus.NotDetermined) {
                    locManager.requestWhenInUseAuthorization();
                }
            }
            
            locManager.startUpdatingLocation();
            
        }else{
            self.mapView.showsUserLocation = self.model.showsUserLocation;
        }
        
        self.mapView.showsBuildings = self.model.showsBuildings;
        self.mapView.showsPointsOfInterest = self.model.showsPointsOfInterest;
    }
    
    // MARK: CLLocation Manager Delegate
    
    public func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        if (status == CLAuthorizationStatus.AuthorizedWhenInUse) {
            self.mapView.showsUserLocation = true;
            manager.stopUpdatingLocation();
        }
    }
    
    // MARK: Map View Delegate
    
    public func mapView(mapView: MKMapView!, didDeselectAnnotationView view: MKAnnotationView!)
    {
        
        for(var i = 0; i < view.subviews.count; i++){
            var childView : AnyObject = view.subviews[i] as AnyObject;
            childView.removeFromSuperview();
        }
        
    }
    
    public func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView!
    {
        var pinView : MKPinAnnotationView = MKPinAnnotationView(annotation: annotation,reuseIdentifier: "");
        var customAnnotation = annotation as ODAnnotation;
        
        var iconPin : NSString = customAnnotation.content.iconPin!;
        
        pinView.image = UIImage(named: iconPin);
        pinView.canShowCallout = false;
        
        return pinView;
    }
    
    public func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!){
        if(!view.annotation.isKindOfClass(MKUserLocation)){
            
            var calloutView : ODOverlayAnnotationView = self.customAnnotationView();
            
            var calloutViewFrame = calloutView.frame;
            
            calloutViewFrame.origin = CGPointMake(-calloutViewFrame.size.width/2-self.calloutViewFrameWidthShift(), -calloutViewFrame.size.height);
            
            calloutView.frame = calloutViewFrame;
            
            var customAnnotation = (mapView.selectedAnnotations as NSArray).objectAtIndex(0) as ODAnnotation;
            
            view.canShowCallout = false;
            view.draggable = false;
            
            view.addSubview(self.fillCustomAnnotationView(calloutView,annotation: customAnnotation));
        }
    }
    
    // MARK : ODMapView Protocol Callout
    
    public func customAnnotationView() -> ODOverlayAnnotationView
    {
        return (NSBundle.mainBundle().loadNibNamed("ODOverlayAnnotationView", owner: self, options: nil))[0] as ODOverlayAnnotationView;
    }
    
    public func fillCustomAnnotationView(view : ODOverlayAnnotationView, annotation : ODAnnotation) -> ODOverlayAnnotationView
    {
        return view;
    }
    
    public func calloutViewFrameWidthShift() -> CGFloat
    {
        return -20;
    }
    
    // MARK: ODMapView Protocol Core Location
    
    public func showUserLocation() -> Bool
    {
        return false;
    }
    
    public func showBuildings() -> Bool
    {
        return false;
    }
    
    public func showPointOfInterests() -> Bool
    {
        return false;
    }
    
    
    // MARK: Override functions
    
    
    // MARK: Static usefull functions
    
    
    
    
}
