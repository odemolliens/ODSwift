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

import MapKit;

public class ODMapObject : NSObject {
    
    public var coordinate : CLLocationCoordinate2D;
    public var title: String!;
    public var subtitle: String!;
    public var name : NSString!;
    public var address : NSString!;
    public var iconPin : NSString!;
    
    override init() {
        self.name = "";
        self.address = "";
        self.coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0);
    }
    
    public required init(latitude : Double, longitude : Double) {
        self.name = "";
        self.address = "";
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude);
    }
    
    public required init(location : CLLocationCoordinate2D) {
        self.name = "";
        self.address = "";
        self.coordinate = location;
    }
    
    public required init(location : CLLocationCoordinate2D, title : NSString, subtitle : NSString) {
        self.name = "";
        self.address = "";
        self.title = title;
        self.subtitle = subtitle;
        self.coordinate = location;
    }
    
}