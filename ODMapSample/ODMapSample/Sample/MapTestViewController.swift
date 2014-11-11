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
        
        self.showRegion(coordinate: CLLocationCoordinate2DMake(48.58476, 7.750576), delta: MKCoordinateSpanMake(1, 1), animated: true);
        
        var mapObject : ODMapObject = ODMapObject(location: CLLocationCoordinate2DMake(48.58476, 7.750576));
        mapObject.title = "Title"
        mapObject.subtitle = "Subtitle"
        mapObject.iconPin = "violet";
        
        self.addMapObjectOnMap(mapObject: mapObject);
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
        
    }
    
    // MARK : ODMapView Protocol Callout
    
    internal override func nativeCalloutView() -> Bool
    {
        return false;
    }
    
    internal override func customAnnotationView() -> ODOverlayAnnotationView
    {
        return (NSBundle.mainBundle().loadNibNamed("ODOverlayAnnotationView", owner: self, options: nil))[0] as ODOverlayAnnotationView;
    }
    
    internal override func fillCustomAnnotationView(view : ODOverlayAnnotationView, annotation : ODAnnotation) -> ODOverlayAnnotationView
    {
        return view;
    }
    
    internal override func calloutViewFrameWidthShift() -> CGFloat
    {
        return -10;
    }
    
    // MARK: ODMapView Protocol Core Location
    
    internal override func showUserLocation() -> Bool
    {
        return true;
    }
    
    internal override func showBuildings() -> Bool
    {
        return true;
    }
    
    internal override func showPointOfInterests() -> Bool
    {
        return true;
    }
    
}
