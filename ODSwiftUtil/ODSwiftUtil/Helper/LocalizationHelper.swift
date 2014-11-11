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

/* Localization Helper
* Easy way to get localized strings
*/
public class LocalizationHelper {
    
    /* Localize
    * Retrieve localized value from x.lproj file
    * value: key used to define text
    * comment: key related to to the table
    */
    public class func localize(var value : NSString,var comment : NSString) -> NSString
    {
        return NSLocalizedString(value,
            tableName: nil,
            bundle: NSBundle.mainBundle(),
            value: value,
            comment: comment);
    }
    
    
}