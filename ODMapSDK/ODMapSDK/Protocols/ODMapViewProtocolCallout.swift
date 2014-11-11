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

/* ODMapViewProtocolCallout
* Provide an easy way to implement custom view elements in a Map View
*
*/
public protocol ODMapViewProtocolCallout {
    
    /* Native Callout View
    * Define if callout view is native or custom
    */
    func nativeCalloutView() -> Bool;
    
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