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
import Alamofire

/* Request
* Easy way to make expiration request with expiration date
*/
public class ODRequest : NSObject {
    
    /* Request
    * Offer the way to manage a request with an expiration date
    */
    public class func call(method aMethod : Alamofire.Method, url : NSString, expire : NSDate?, success :(NSData?, NSURLResponse?) -> Void = {data, response in /* ... */},failure: (NSData?, NSError?) -> Void = {data, error in /* ... */}) {
        
        
        if(expire==nil){

            let URL = NSURL(string: url)!
            Alamofire.request(aMethod, URL).response { (request, response, data, error) in
                
                if(error==nil){
                    success(data as NSData!,response!);
                }else{
                    failure(data as NSData!,error!);
                }
            }
            
        }else{
            
            let encodingClosure: (URLRequestConvertible, [String: AnyObject]?) -> (NSURLRequest, NSError?) = { (URLRequest, parameters) in
                
                let mutableURLRequest = URLRequest.URLRequest.mutableCopy() as NSMutableURLRequest
                
                var date : NSDate = expire!;
                
                mutableURLRequest.setValue(date.description, forHTTPHeaderField: kUrlProtocolObjectPropertyExpire);
                return (mutableURLRequest, nil)
            }
            
            let encoding: ParameterEncoding = .Custom(encodingClosure)
            
            let URL = NSURL(string: url)!
            let URLRequest = NSURLRequest(URL: URL)
            let parameters: [String: AnyObject] = [:]
            
            Alamofire.request(.GET, URL, parameters: parameters, encoding: encoding).response { (request, response, data, error) in
                
                if(error==nil){
                    
                    success(data as NSData!,response?);
                    
                }else{
                    failure(data as NSData!,error!);
                }
            }
        }
    }
    
}