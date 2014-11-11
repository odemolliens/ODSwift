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
import CoreData

private let kUrlProtocolNamePrivate : NSString = "ODURLProtocolHandledKey";

private let kUrlProtocolObject : NSString = "ODCachedURLResponse";

private let kUrlProtocolObjectPropertyUrl : NSString = "url";

private let kUrlProtocolObjectPropertyTimestamp : NSString = "timestamp";
private let kUrlProtocolObjectPropertyMimetype : NSString = "mimeType";
private let kUrlProtocolObjectPropertyEncoding : NSString = "encoding";
public  let kUrlProtocolObjectPropertyExpire : NSString = "expire";
private let kUrlProtocolObjectPropertyData : NSString = "data";

/*
*
*/
public class ODURLCache : NSURLCache {
    
    
    /*
    *
    */
    public override func cachedResponseForRequest(request: NSURLRequest) -> NSCachedURLResponse?
    {
        // TODO : if no cache?
        
        let possibleCachedResponse = ODURLCache.cachedResponseForCurrentRequest(aRequest: request);
        
        if let cachedResponse = possibleCachedResponse {
            
            // 2.
            var data : NSData? = cachedResponse.valueForKey(kUrlProtocolObjectPropertyData) as NSData!
            var mimeType : NSString? = cachedResponse.valueForKey(kUrlProtocolObjectPropertyMimetype) as NSString!
            var encoding : NSString? = cachedResponse.valueForKey(kUrlProtocolObjectPropertyEncoding) as NSString!
            var expire : NSDate? = cachedResponse.valueForKey(kUrlProtocolObjectPropertyExpire) as NSDate!
            
            if(expire != nil && expire?.timeIntervalSince1970 < NSDate().timeIntervalSince1970){
                
                if(!Reachability.isConnectedToNetwork()){
                    
                    let response = NSURLResponse(URL: request.URL, MIMEType: mimeType, expectedContentLength: data!.length, textEncodingName: encoding)
                    
                    let responseCache = NSCachedURLResponse(response: response, data: data!);
                    return responseCache;
                }else{
                    return nil;
                }
                
            }else{
                
                let response = NSHTTPURLResponse(URL: request.URL, MIMEType: mimeType, expectedContentLength: data!.length, textEncodingName: encoding)
                
                let responseCache = NSCachedURLResponse(response: response, data: data!);
                return responseCache;
                
            }
        }else{
            //Nothing in cache
            return nil;
        }
    }
    
    /*
    *
    */
    public override func storeCachedResponse(cachedResponse: NSCachedURLResponse, forRequest request: NSURLRequest)
    {
        ODURLCache.saveCachedResponse(aRequest: request,response: cachedResponse);
    }
    
    /*
    *
    */
    public override func removeCachedResponseForRequest(request: NSURLRequest)
    {
        return super.removeCachedResponseForRequest(request);
    }
    
    /*
    *
    */
    public override func removeAllCachedResponses()
    {
        super.removeAllCachedResponses();
    }
    
    /*
    *
    */
    public override func removeCachedResponsesSinceDate(date: NSDate)
    {
        super.removeCachedResponsesSinceDate(date);
    }
    
    
    
    /* Save Cached Response
    * Update &/or Copy the current request and add it in Core Data
    */
    private class func saveCachedResponse (aRequest request : NSURLRequest, response : NSCachedURLResponse) {
        
        var requestHTTPExpire : NSString? = request.valueForHTTPHeaderField(kUrlProtocolObjectPropertyExpire);
        
        if(requestHTTPExpire != nil && requestHTTPExpire?.length>0){
            
            var  delegate : ODAppDelegate = UIApplication.sharedApplication().delegate as ODAppDelegate
            var context : NSManagedObjectContext! = ODNetworkManagement.sharedNetwork().managedObjectContext!
            
            let possibleCachedResponse = ODURLCache.cachedResponseForCurrentRequest(aRequest: request);
            
            var oldTimeStamp : NSDate?;
            
            if let cachedResponse = possibleCachedResponse {
                oldTimeStamp = cachedResponse.valueForKey(kUrlProtocolObjectPropertyExpire) as NSDate!;
                context.deleteObject(cachedResponse);
            }
            
            var cachedResponse : NSManagedObject = NSEntityDescription.insertNewObjectForEntityForName(kUrlProtocolObject, inManagedObjectContext: context) as NSManagedObject
            
            cachedResponse.setValue(response.data, forKey: kUrlProtocolObjectPropertyData)
            cachedResponse.setValue(request.URL.absoluteString, forKey: kUrlProtocolObjectPropertyUrl)
            cachedResponse.setValue(NSDate(), forKey: kUrlProtocolObjectPropertyTimestamp)
            cachedResponse.setValue(response.response.MIMEType, forKey: kUrlProtocolObjectPropertyMimetype)
            cachedResponse.setValue(response.response.textEncodingName, forKey: kUrlProtocolObjectPropertyEncoding)
            
            if(oldTimeStamp==nil){
                
                var dateFormatter = NSDateFormatter()
                
                dateFormatter.dateFormat = "YYYY-MM-dd\'T\'HH:mm:ssZZZZZ"
                
                var dateFromString : NSDate? = dateFormatter.dateFromString(requestHTTPExpire!)!
                
                cachedResponse.setValue(dateFromString!, forKey: kUrlProtocolObjectPropertyExpire);
                
            }else{
                cachedResponse.setValue(oldTimeStamp, forKey: kUrlProtocolObjectPropertyExpire);
                
            }
            
            var error: NSError?
            
            var success : Bool = context.save(&error)
            if !success {
                println("Could not cache the response")
            }
            
            if !(error==nil) {
                NSLog("error:%@",error!);
            }
            
        }else{
            //println("requestHTTPValidity unvalid - no need to use cache")
        }
        
        
    }
    
    /* Cached Response For Current Request
    * Try to find an cached response in Core Data
    */
    private class func cachedResponseForCurrentRequest(aRequest request : NSURLRequest) -> NSManagedObject? {
        
        let delegate = UIApplication.sharedApplication().delegate as ODAppDelegate
        let context = ODNetworkManagement.sharedNetwork().managedObjectContext!
        
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName(kUrlProtocolObject, inManagedObjectContext: context)
        fetchRequest.entity = entity
        
        let predicate = NSPredicate(format:"url == %@", request.URL.description)
        fetchRequest.predicate = predicate
        
        var error: NSError?
        let possibleResult = context.executeFetchRequest(fetchRequest, error: &error) as Array<NSManagedObject>?
        
        
        if(error != nil){
            NSLog("Error occurs during fetch request");
            return nil;
        }
        
        if let result = possibleResult {
            if !result.isEmpty {
                return result[0]
            }
        }
        
        return nil
    }
}