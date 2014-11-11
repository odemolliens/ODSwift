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