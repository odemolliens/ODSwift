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

/* NSObject+JSON
* Easy way to JSONify object
*/

public extension NSObject {
    
    /* JSON Serialize
    * Serialize an object in JSON
    */
    public func JSONSerialize() -> String? {
        
        var error: NSError?;
        
        let jsonData: NSData! = NSJSONSerialization.dataWithJSONObject(
            self,
            options: NSJSONWritingOptions(0),
            error: &error);
        
        if error != nil {
            
            return "";
            
        } else {
            
            return NSString(data: jsonData, encoding: NSUTF8StringEncoding)!;
            
        }
    }
    
    /* JSON Deserialize Array
    * Deserialize an array in JSON
    */
    public class func JSONDeserializeArray(jsonString: String) -> Array<AnyObject> {
        
        var error: NSError?;
        
        var data: NSData!=jsonString.dataUsingEncoding(NSUTF8StringEncoding);
        
        var jsonObj = NSJSONSerialization.JSONObjectWithData(
            data,
            options: NSJSONReadingOptions(0),
            error: &error) as Array<AnyObject>;
        if error != nil {
            
            return Array<AnyObject>();
            
        } else {
            
            return jsonObj;
            
        }
    }
    
    /* JSON Deserialize Dic
    * Deserialize an dictionnary in JSON
    */
    public class func JSONDeserializeDic(jsonString:String) -> Dictionary<String, AnyObject> {
        
        var error: NSError?;
        
        var data: NSData! = jsonString.dataUsingEncoding(
            NSUTF8StringEncoding)
        
        var jsonObj = NSJSONSerialization.JSONObjectWithData(
            data,
            options: NSJSONReadingOptions(0),
            error: &error) as Dictionary<String, AnyObject>;
        
        if error != nil {
            
            return Dictionary<String, AnyObject>();
            
        } else {
            
            return jsonObj;
            
        }
    }
    
    
    
    
}