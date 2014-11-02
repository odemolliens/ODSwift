//
//  ODAnnotation.swift
//  iMap
//
//  Created by OlivierDemolliens on 21/10/14.
//  Copyright (c) 2014 dreamteam. All rights reserved.
//

import Foundation

import MapKit;

public class ODAnnotation : NSObject, MKAnnotation {
    
    public var coordinate : CLLocationCoordinate2D;
    public var content : ODMapObject!;
    public var title : NSString;
    public var subtitle : NSString;
    
    override init() {
        self.coordinate = CLLocationCoordinate2DMake(0, 0);
        self.title = "";
        self.subtitle = "";
    }
    
    
    public init(content : ODMapObject) {
        self.coordinate = CLLocationCoordinate2DMake(0, 0);
        self.title = "";
        self.subtitle = "";
        self.content = content;
    }
    
    public func setCoordinate(newCoordinate : CLLocationCoordinate2D) {
        self.coordinate = newCoordinate;
    }
    
}