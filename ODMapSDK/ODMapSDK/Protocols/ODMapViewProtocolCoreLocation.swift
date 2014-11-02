//
//  ODMapViewProtocolCoreLocation.swift
//  ODMapSDK
//
//  Created by OlivierDemolliens on 30/10/14.
//  Copyright (c) 2014 dreamteam. All rights reserved.
//

import Foundation

/* ODMapViewProtocolCoreLocation
* Provide an easy way to show some information on the map view
*/
public protocol ODMapViewProtocolCoreLocation {
    
    /* User Location
    * Show user pin on the map
    */
    func showUserLocation() -> Bool;
    
    /* Buildings
    * Show buildings on the map
    */
    func showBuildings() -> Bool;
    
    /* Point Of Interests
    * Show all point of interests on the map
    */
    func showPointOfInterests() -> Bool;
}