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

private let kNSURLConnectionContent : NSString = "content";
private let kNSURLConnectionHTTPCode : NSString = "httpcode";

/* NSURLConnection+Blocks
* Easy way to use sendAsynchronousRequest as a blocks
*/
public extension NSURLConnection
{
    
    /* Async Request
    * Make an async request with success / failure blocks
    */
    public class func asyncRequest(request : NSURLRequest, success :(NSData, NSURLResponse) -> Void = {data, response in /* ... */},failure: (NSData, NSError) -> Void = {data, error in /* ... */})
        
    {
        // XCTest usage
        #if DEBUG
            var waiting : Bool = true;
            #else
            var waiting : Bool = false;
        #endif
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            var queue : NSOperationQueue = NSOperationQueue();
            
            NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:{response,data,error in
                
                if((error) != nil){
                    if(data == nil){
                        failure(NSData(),error!);
                    }else{
                        failure(data,error!);
                    }
                }
                
                let res = response as NSHTTPURLResponse!;
                
                if(res != nil && res.statusCode==200){
                    success(data,response);
                }else{
                    var datastring: String = NSString(data:data, encoding:NSUTF8StringEncoding)!
                    var content : NSMutableDictionary = NSMutableDictionary();
                    content.setValue(datastring, forKey: kNSURLConnectionContent);
                    content.setValue(res.statusCode, forKey: kNSURLConnectionHTTPCode);
                    
                    var mError : NSError = NSError(domain: request.URL.description, code: res.statusCode, userInfo: content);
                    //content.setValue(NSHTTPURLResponse.localizedStringForStatusCode(res.statusCode), forKey: "localizedError");
                    failure(data,mError);
                }
                
                waiting = false;
            });
        }
        while(waiting) {
            NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: NSDate.distantFuture() as NSDate);
        }
        
    }
}