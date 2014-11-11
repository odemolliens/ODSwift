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

// Based on Zouhair Mahieddine work

import UIKit
import CoreData

var requestCount = 0;

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
public class ODURLProtocol : NSURLProtocol {
    
    var connection : NSURLConnection!
    
    var mutableData : NSMutableData!
    
    var response : NSURLResponse!
    
    
    // MARK: Override functions
    
    /*
    *
    */
    override public class func canInitWithRequest(request: NSURLRequest) -> Bool {
        println("Request #\(requestCount++): URL = \(request.URL.absoluteString)")
       
        if NSURLProtocol.propertyForKey(kUrlProtocolNamePrivate, inRequest: request) != nil {
            return false
        }
        
        return true
    }
    
    /*
    *
    */
    override public class func canonicalRequestForRequest(request: NSURLRequest) -> NSURLRequest {
        
        return request
        
    }
    
    /*
    *
    */
    override public class func requestIsCacheEquivalent(aRequest: NSURLRequest, toRequest bRequest: NSURLRequest) -> Bool {
        
        return super.requestIsCacheEquivalent(aRequest, toRequest:bRequest)
        
    }
    
    /*
    *
    */
    override public func startLoading() {
        
        // 1.
        let possibleCachedResponse = self.cachedResponseForCurrentRequest()
        if let cachedResponse = possibleCachedResponse {
            println("Serving response from cache")
            
            // 2.
            let data = cachedResponse.valueForKey(kUrlProtocolObjectPropertyData) as NSData!
            let mimeType = cachedResponse.valueForKey(kUrlProtocolObjectPropertyMimetype) as String!
            let encoding = cachedResponse.valueForKey(kUrlProtocolObjectPropertyEncoding) as String!
            let expire = cachedResponse.valueForKey(kUrlProtocolObjectPropertyExpire) as NSDate!
            
            if(expire != nil && expire.timeIntervalSince1970 > NSDate().timeIntervalSince1970){
                println("Serving response from cache outdated - make new request")
                
                var newRequest = self.request.copy() as NSMutableURLRequest
                
                NSURLProtocol.setProperty(true, forKey: kUrlProtocolNamePrivate, inRequest: newRequest)
                
                self.connection = NSURLConnection(request: newRequest, delegate: self)
                
            }else{
                
                // 3.
                let response = NSURLResponse(URL: self.request.URL, MIMEType: mimeType, expectedContentLength: data.length, textEncodingName: encoding)
                
                // 4.
                self.client!.URLProtocol(self, didReceiveResponse: response, cacheStoragePolicy: .NotAllowed)
                self.client!.URLProtocol(self, didLoadData: data)
                self.client!.URLProtocolDidFinishLoading(self)
            }
            
            
        }
        else {
            // 5.
            println("Serving response from NSURLConnection")
            
            var newRequest = self.request.copy() as NSMutableURLRequest
            
            NSURLProtocol.setProperty(true, forKey: kUrlProtocolNamePrivate, inRequest: newRequest)
            
            self.connection = NSURLConnection(request: newRequest, delegate: self)
        }
    }
    
    /*
    *
    */
    override public func stopLoading() {
        
        if self.connection != nil {
            self.connection.cancel()
        }
        self.connection = nil
    }
    
    // MARK: Private functions
    
    /*
    *
    */
    private func connection(connection: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        
        self.client!.URLProtocol(self, didReceiveResponse: response, cacheStoragePolicy: .NotAllowed)
        
        self.response = response
        self.mutableData = NSMutableData()
    }
    
    /*
    *
    */
    private func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        
        self.client!.URLProtocol(self, didLoadData: data)
        self.mutableData.appendData(data)
        
    }
    
    /*
    *
    */
    private func connectionDidFinishLoading(connection: NSURLConnection!) {
        
        self.client!.URLProtocolDidFinishLoading(self)
        self.saveCachedResponse()
        
    }
    
    /*
    *
    */
    private func connection(connection: NSURLConnection!, didFailWithError error: NSError!) {
        
        self.client!.URLProtocol(self, didFailWithError: error)
    }
    
    // MARK: Private cache management functions
    
    /*
    *
    */
    private func saveCachedResponse () {
        
        println("Saving cached response")
        
        var requestHTTPExpire : NSString? = self.request.valueForHTTPHeaderField(kUrlProtocolObjectPropertyExpire);
        
        if(requestHTTPExpire != nil && requestHTTPExpire?.length>0){
            
            println("requestHTTPValidity valid")
            
            // 1.
            let delegate = UIApplication.sharedApplication().delegate as ODAppDelegate
            let context = ODNetworkManagement.sharedNetwork().managedObjectContext!
            
            // 2.
            let cachedResponse = NSEntityDescription.insertNewObjectForEntityForName(kUrlProtocolObject, inManagedObjectContext: context) as NSManagedObject
            
            cachedResponse.setValue(self.mutableData, forKey: kUrlProtocolObjectPropertyData)
            cachedResponse.setValue(self.request.URL.absoluteString, forKey: kUrlProtocolObjectPropertyUrl)
            cachedResponse.setValue(NSDate(), forKey: kUrlProtocolObjectPropertyTimestamp)
            cachedResponse.setValue(self.response.MIMEType, forKey: kUrlProtocolObjectPropertyMimetype)
            cachedResponse.setValue(self.response.textEncodingName, forKey: kUrlProtocolObjectPropertyEncoding)
            cachedResponse.setValue(requestHTTPExpire, forKey: kUrlProtocolObjectPropertyExpire);
            
            // 3.
            var error: NSError?
            let success = context.save(&error)
            if !success {
                println("Could not cache the response")
            }
        }else{
            println("requestHTTPValidity unvalid - no need to use cache")
        }
        
        
    }
    
    /*
    *
    */
    private func cachedResponseForCurrentRequest() -> NSManagedObject? {
        
        // 1.
        let delegate = UIApplication.sharedApplication().delegate as ODAppDelegate
        let context = ODNetworkManagement.sharedNetwork().managedObjectContext!
        
        // 2.
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName(kUrlProtocolObject, inManagedObjectContext: context)
        fetchRequest.entity = entity
        
        // 3.
        let predicate = NSPredicate(format:"url == %@", self.request.URL.description)
        fetchRequest.predicate = predicate
        
        // 4.
        var error: NSError?
        let possibleResult = context.executeFetchRequest(fetchRequest, error: &error) as Array<NSManagedObject>?
        
        
        if(error != nil){
            NSLog("Error occurs during fetch request");
            return nil;
        }
        // 5.
        if let result = possibleResult {
            if !result.isEmpty {
                return result[0]
            }
        }
        
        return nil
    }
    
}