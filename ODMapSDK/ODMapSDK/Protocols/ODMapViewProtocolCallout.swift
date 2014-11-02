//
//  ODMapViewProtocolCallout.swift
//  ODMapSDK
//
//  Created by OlivierDemolliens on 30/10/14.
//  Copyright (c) 2014 dreamteam. All rights reserved.
//

import Foundation

/* ODMapViewProtocolCallout
* Provide an easy way to implement custom view elements in a Map View
*
*/
public protocol ODMapViewProtocolCallout {
    
    /* Custom Annotation View
    * Define your own callout view on a POI
    */
    func customAnnotationView() -> ODOverlayAnnotationView;
    
    /* Fill Custom Annotation View
    * After the creation view,
    */
    func fillCustomAnnotationView(view : ODOverlayAnnotationView, annotation : ODAnnotation) -> ODOverlayAnnotationView;
    
    /* Callout View Frame Width Shift
    * If the callout center view is not the same as the pin, you can manually fix the width center
    */
    func calloutViewFrameWidthShift() -> CGFloat;
}