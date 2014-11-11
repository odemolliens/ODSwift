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


private let kUrlProtocolNameScheme : NSString = "ODURLProtocol";
private let kUrlProtocolNameDb : NSString = kUrlProtocolNameScheme+".sqlite";

private let kUrlProtocolDomainError : NSString = "ODURLProtocol";
private let kUrlProtocolDomainErrorCode : Int = 4554;

/*
*
*/
public class ODNetworkManagement : NSObject {
    
    
    // MARK: - Static functions
    
    
    // MARK: - Singleton
    
    /* Shared Network
    * Singleton
    */
    public class func sharedNetwork() -> ODNetworkManagement {
        
        struct StaticNetworkManagement {
            static let instance : ODNetworkManagement = ODNetworkManagement();
        }
        
        return StaticNetworkManagement.instance;
    }
    
    // MARK: - Constructor
    
    /*
    *
    */
    override init(){
        
    }
    
    
    
    // MARK: - Core Data stack
    
    /* Application Documents Directory
    * The directory the application uses to store the Core Data store file. This code uses a directory named
    * "com.test.test" in the application's documents Application Support directory.
    */
    private lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        
        return urls[urls.count-1] as NSURL
        }()
    
    /* Managed Object Model
    * The managed object model for the application. This property is not optional. It is a fatal error for the
    * application not to be able to find and load its model.
    */
    private lazy var managedObjectModel: NSManagedObjectModel? = {
        let modelURL : NSURL? = NSBundle.mainBundle().URLForResource(kUrlProtocolNameScheme, withExtension: "mom")!
        
        if(modelURL==nil){
            NSLog("managedObjectModel, can't load the object model:%@",kUrlProtocolNameScheme+"mom");
            return nil;
        }else{
            return NSManagedObjectModel(contentsOfURL: modelURL!)!
        }
        
        }()
    
    /* Persistent Store Coordinator
    * Create the coordinator and store
    */
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel!)
        
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(kUrlProtocolNameDb)
        
        var error: NSError? = nil
        
        var failureReason = "There was an error creating or loading the application's saved data."
        
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain:kUrlProtocolDomainError, code: kUrlProtocolDomainErrorCode, userInfo: dict)
            
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
        }()
    
    /* Managed Object Context
    * Returns the managed object context for the application (which is already bound to the persistent store
    * coordinator for the application.) This property is optional since there are legitimate error conditions that
    * could cause the creation of the context to fail.
    */
    public lazy var managedObjectContext: NSManagedObjectContext? = {
        
        let coordinator = self.persistentStoreCoordinator
        
        if coordinator == nil {
            return nil
        }
        
        var managedObjectContext = NSManagedObjectContext()
        
        managedObjectContext.persistentStoreCoordinator = coordinator
        
        return managedObjectContext
        
        }()
    
    // MARK: - Core Data Saving Support
    
    /* Save Context
    * Save current context in DB
    */
    public func saveContext () {
        if let moc = self.managedObjectContext {
            
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // TODO : fix IF DB is corrupted
                NSLog("Unresolved error \(error), \(error!.userInfo)")
            }
            
        }
    }
    
    
}