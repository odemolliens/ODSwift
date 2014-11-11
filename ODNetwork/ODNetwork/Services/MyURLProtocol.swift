//
//  MyURLProtocol.swift
//  NSURLProtocolExample
//
//  Created by Zouhair Mahieddine on 7/15/14.
//  Copyright (c) 2014 Zedenem. All rights reserved.
//

import UIKit
import CoreData

var requestCount = 0

class MyURLProtocol: NSURLProtocol {
  
  var connection :NSURLConnection!
  var mutableData :NSMutableData!
  var response :NSURLResponse!
  
  override class func canInitWithRequest(request: NSURLRequest) -> Bool {
    println("Request #\(requestCount++): URL = \(request.URL.absoluteString)")
    
    if NSURLProtocol.propertyForKey("MyURLProtocolHandledKey", inRequest: request) != nil {
      return false
    }
    
    return true
  }
  
  override class func canonicalRequestForRequest(request: NSURLRequest) -> NSURLRequest {
    return request
  }
  
  override class func requestIsCacheEquivalent(aRequest: NSURLRequest, toRequest bRequest: NSURLRequest) -> Bool {
    return super.requestIsCacheEquivalent(aRequest, toRequest:bRequest)
  }
  
  override func startLoading() {
    // 1.
    let possibleCachedResponse = self.cachedResponseForCurrentRequest()
    if let cachedResponse = possibleCachedResponse {
      println("Serving response from cache")
      
      // 2.
      let data = cachedResponse.valueForKey("data") as NSData!
      let mimeType = cachedResponse.valueForKey("mimeType") as String!
      let encoding = cachedResponse.valueForKey("encoding") as String!
      
      // 3.
      let response = NSURLResponse(URL: self.request.URL, MIMEType: mimeType, expectedContentLength: data.length, textEncodingName: encoding)
      
      // 4.
      self.client!.URLProtocol(self, didReceiveResponse: response, cacheStoragePolicy: .NotAllowed)
      self.client!.URLProtocol(self, didLoadData: data)
      self.client!.URLProtocolDidFinishLoading(self)
    }
    else {
      // 5.
      println("Serving response from NSURLConnection")
      
      var newRequest = self.request.copy() as NSMutableURLRequest
      NSURLProtocol.setProperty(true, forKey: "MyURLProtocolHandledKey", inRequest: newRequest)
      self.connection = NSURLConnection(request: newRequest, delegate: self)
    }
  }
  
  override func stopLoading() {
    if self.connection != nil {
      self.connection.cancel()
    }
    self.connection = nil
  }
  
  func connection(connection: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
    self.client!.URLProtocol(self, didReceiveResponse: response, cacheStoragePolicy: .NotAllowed)
    
    self.response = response
    self.mutableData = NSMutableData()
  }
  
  func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
    self.client!.URLProtocol(self, didLoadData: data)
    self.mutableData.appendData(data)
  }
  
  func connectionDidFinishLoading(connection: NSURLConnection!) {
    self.client!.URLProtocolDidFinishLoading(self)
    self.saveCachedResponse()
  }
  
  func connection(connection: NSURLConnection!, didFailWithError error: NSError!) {
    self.client!.URLProtocol(self, didFailWithError: error)
  }
  
  func saveCachedResponse () {
    println("Saving cached response")
    
    // 1.
    let delegate = UIApplication.sharedApplication().delegate as AppDelegate
    let context = delegate.managedObjectContext!
    
    // 2.
    let cachedResponse = NSEntityDescription.insertNewObjectForEntityForName("CachedURLResponse", inManagedObjectContext: context) as NSManagedObject
    
    cachedResponse.setValue(self.mutableData, forKey: "data")
    cachedResponse.setValue(self.request.URL.absoluteString, forKey: "url")
    cachedResponse.setValue(NSDate(), forKey: "timestamp")
    cachedResponse.setValue(self.response.MIMEType, forKey: "mimeType")
    cachedResponse.setValue(self.response.textEncodingName, forKey: "encoding")
    
    // 3.
    var error: NSError?
    let success = context.save(&error)
    if !success {
      println("Could not cache the response")
    }
  }
  
  func cachedResponseForCurrentRequest() -> NSManagedObject? {
    // 1.
    let delegate = UIApplication.sharedApplication().delegate as AppDelegate
    let context = delegate.managedObjectContext!
    
    // 2.
    let fetchRequest = NSFetchRequest()
    let entity = NSEntityDescription.entityForName("CachedURLResponse", inManagedObjectContext: context)
    fetchRequest.entity = entity
    
    // 3.
    let predicate = NSPredicate(format:"url == %@", self.request.URL.absoluteString!)
    fetchRequest.predicate = predicate
    
    // 4.
    var error: NSError?
    let possibleResult = context.executeFetchRequest(fetchRequest, error: &error) as Array<NSManagedObject>?
    
    // 5.
    if let result = possibleResult {
      if !result.isEmpty {
        return result[0]
      }
    }
    
    return nil
  }
  
}