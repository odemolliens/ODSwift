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

import UIKit;
import MapKit;
import CoreLocation;

private let kMapViewControllerReuseMe : NSString = "kMapViewControllerReuseMe";

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
    
    // MARK: Util public method
    
    
    /* Show Region
    * Show on the map the region setted in parameters
    */
    public func showRegion(coordinate aCoordinate : CLLocationCoordinate2D, delta : MKCoordinateSpan, animated : Bool){
        
        self.mapView.setRegion(MKCoordinateRegionMake(aCoordinate, delta), animated: animated);
    }
    
    /* Show Point Of Interest
    * Show on the map the annotation setted in parameters
    */
    public func showPointOfInterest(annotation anAnnotation : ODAnnotation, delta : MKCoordinateSpan, animated : Bool){
        self.mapView.setRegion(MKCoordinateRegionMake(anAnnotation.coordinate, delta), animated: animated);
    }
    
    /* Add Map Object On Map
    * Create an annotation with custom content and display it
    */
    public func addMapObjectOnMap(mapObject aMapObject : ODMapObject){
        var customAnnotation : ODAnnotation = ODAnnotation(content:aMapObject);
        self.mapView.addAnnotation(customAnnotation);
    }
    
    /* Add Map Objects On Map
    * Create an annotation list with custom content and display it
    */
    public func addMapObjectsOnMap(mapObjects aListMapObject : NSMutableArray){
        
        if(aListMapObject.count>0){
            var privateArray : NSMutableArray = NSMutableArray();
            
            for(var i = 0; i < aListMapObject.count;i++){
                
                var aMapObject : ODMapObject = aListMapObject.objectAtIndex(i) as ODMapObject;
                var customAnnotation : ODAnnotation = ODAnnotation(content:aMapObject);
                privateArray.addObject(customAnnotation);
                
            }
            
            self.mapView.addAnnotations(privateArray);
        }
        
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
    
    /*
    *
    */
    public func mapView(mapView: MKMapView!, didDeselectAnnotationView view: MKAnnotationView!)
    {
        
        for(var i = 0; i < view.subviews.count; i++){
            var childView : AnyObject = view.subviews[i] as AnyObject;
            childView.removeFromSuperview();
        }
        
    }
    
    /*
    *
    */
    public func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView!
    {
        var pinView : MKPinAnnotationView = MKPinAnnotationView(annotation: annotation,reuseIdentifier: kMapViewControllerReuseMe);
        var customAnnotation = annotation as ODAnnotation;
        
        var iconPin : NSString = customAnnotation.content.iconPin!;
        
        pinView.image = UIImage(named: iconPin);
        
        
        pinView.canShowCallout = self.nativeCalloutView();
        
        return pinView;
    }
    
    /*
    *
    */
    public func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!){
        if(!view.annotation.isKindOfClass(MKUserLocation)){
            
            var calloutView : ODOverlayAnnotationView = self.customAnnotationView();
            
            var calloutViewFrame = calloutView.frame;
            
            calloutViewFrame.origin = CGPointMake(-calloutViewFrame.size.width/2-self.calloutViewFrameWidthShift(), -calloutViewFrame.size.height);
            
            calloutView.frame = calloutViewFrame;
            
            var customAnnotation = (mapView.selectedAnnotations as NSArray).objectAtIndex(0) as ODAnnotation;
            
            view.canShowCallout = self.nativeCalloutView();
            view.draggable = false;
            
            if(!self.nativeCalloutView()){
                view.addSubview(self.fillCustomAnnotationView(calloutView,annotation: customAnnotation));
            }
        }
    }
    
    // MARK : ODMapView Protocol Callout
    
    public func nativeCalloutView() -> Bool
    {
        return false;
    }
    
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
