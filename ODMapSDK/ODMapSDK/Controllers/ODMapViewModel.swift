//
//  ODMapViewModel.swift
//  iMap
//
//  Created by OlivierDemolliens on 22/10/14.
//  Copyright (c) 2014 dreamteam. All rights reserved.
//

import Foundation

public class ODMapViewModel : NSObject {
 
    // Utilities
    var showsUserLocation : Bool;
    var showsBuildings : Bool;
    var showsPointsOfInterest : Bool;
    
    
    override init() {
        self.showsUserLocation = false;
        self.showsBuildings = false;
        self.showsPointsOfInterest = false;
        super.init();
    }
    
    public init(userLocation : Bool, buildings : Bool, pointOfInterests : Bool) {
        self.showsUserLocation = userLocation;
        self.showsBuildings = buildings;
        self.showsPointsOfInterest = pointOfInterests;
        super.init();
    }
    
    
}