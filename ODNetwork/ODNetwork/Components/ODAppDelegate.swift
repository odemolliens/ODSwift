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

import UIKit
import CoreData

@UIApplicationMain
public class ODAppDelegate: UIResponder, UIApplicationDelegate {
    
    public var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        
        ODNetworkManagement.sharedNetwork();
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication!) {
        
    }
    
    func applicationDidEnterBackground(application: UIApplication!) {
        
    }
    
    func applicationWillEnterForeground(application: UIApplication!) {
        
    }
    
    func applicationDidBecomeActive(application: UIApplication!) {
        
    }
    
    func applicationWillTerminate(application: UIApplication!) {
        ODNetworkManagement.sharedNetwork().saveContext();
    }
    
}

