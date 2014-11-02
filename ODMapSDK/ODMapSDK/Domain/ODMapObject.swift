//
//  ODMapObject.swift
//  iMap
//
//  Created by OlivierDemolliens on 21/10/14.
//  Copyright (c) 2014 dreamteam. All rights reserved.
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
    
}