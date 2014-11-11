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

//General
let kImageCachePath : NSString = ODAppUtil.appName()!+"Cache";

//Parse
let kImageExtension : NSString = "png";
let kImageNoRetina : NSString = "%@@2x";
let kImageRetina : NSString = "%@";

/* UIImage+ODImageCached
* Easy way to draw on image and cache it
*/
public extension UIImage {
    
    // MARK : public functions
    
    /* Image With Name
    * Load an png image in main bundle.
    */
    public class func imageWithName(imageName image : NSString) -> UIImage? {
        
        var realImageName : NSString = "";
        var isRetina : Bool = ODDeviceUtil.isRetinaDevice();
        
        if(isRetina){
            realImageName = NSString(format: kImageRetina, image);
        }else{
            realImageName = NSString(format: kImageNoRetina, image);
        }
        
        if let filePath : NSString = NSBundle.mainBundle().pathForResource(realImageName, ofType: kImageExtension){
            
            if let data : NSData = NSData(contentsOfFile: filePath){
                
                var scale : CGFloat = isRetina ? 2.0:1.0;
                return UIImage(data: data, scale: scale);
                
            }else{
                return nil;
            }
        }else{
            return nil;
        }
        
    }
    
    /* Image From Library Without Resolution
    * Load an png image in main bundle with no resolution
    */
    public class func imageFromLibraryWithoutResolution(imageName image : NSString) -> UIImage? {
        
        var realImageName : NSString = "";
        
        realImageName = NSString(format: kImageNoRetina+kImageExtension, image);
        
        if let filePath : NSString = NSBundle.mainBundle().pathForResource(realImageName, ofType: kImageExtension){
            
            if let data : NSData = NSData(contentsOfFile: filePath){
                
                return UIImage(data: data);
                
            }else{
                return nil;
            }
        }else{
            return nil;
        }
    }
    
    /* Image From Library With Name
    * Load an png image library app folder
    */
    public class func imageFromLibraryWithName(imageName image : NSString) -> UIImage? {
        
        var realImageName : NSString = "";
        var libraryPath : NSString = self.libraryDirectory();
        var data = NSData?();
        var cachePath : NSString = libraryPath.stringByAppendingPathComponent(kImageCachePath);
        var isRetina : Bool = ODDeviceUtil.isRetinaDevice();
        
        if(isRetina){
            realImageName = NSString(format: kImageRetina+kImageExtension, image);
        }else{
            realImageName = NSString(format: kImageNoRetina+kImageExtension, image);
        }
        
        var pngPath : NSString = cachePath.stringByAppendingPathComponent(realImageName);
        
        if(!(NSFileManager.defaultManager().fileExistsAtPath(cachePath))){
            self.createDirectory(directoryName: kImageCachePath, filePath: libraryPath);
        }
        
        
        data = NSData(contentsOfFile: pngPath);
        
        if(data == nil){
            return nil;
        }else{
            var scale : CGFloat = isRetina ? 2.0:1.0;
            return UIImage(data: data!, scale: scale);
        }
    }
    
    
    /* Cache Drawed New Image
    *
    */
    public class func cacheDrawedNewImage(imageName image : NSString, cacheName : NSString, completion:(UIImage)) -> UIImage? {
        
        var imageName : NSString = "";
        var isRetina : Bool = ODDeviceUtil.isRetinaDevice();
        var libraryPath : NSString = self.libraryDirectory();
        var data = NSData?();
        var cachePath : NSString = libraryPath.stringByAppendingPathComponent(kImageCachePath);
        
        if(isRetina){
            imageName = NSString(format: kImageRetina+kImageExtension, cacheName);
        }else{
            imageName = NSString(format: kImageNoRetina+kImageExtension, cacheName);
        }
        
        if(!(NSFileManager.defaultManager().fileExistsAtPath(cachePath))){
            self.createDirectory(directoryName: kImageCachePath, filePath: libraryPath);
        }
        
        var pngPath : NSString = cachePath.stringByAppendingPathComponent(imageName);
        
        if(NSFileManager.defaultManager().fileExistsAtPath(pngPath)){
            
            data = NSData(contentsOfFile: pngPath);
            
            if(data == nil){
                return nil;
            }else{
                var scale : CGFloat = isRetina ? 2.0:1.0;
                return UIImage(data: data!, scale: scale);
            }
        }else{
            
            //Not exist, draw and write it in image cache folder.
            var image : UIImage = completion;
            
            // Write image to PNG
            if(UIImagePNGRepresentation(image).writeToFile(pngPath, atomically: true)){
                if(NSFileManager.defaultManager().fileExistsAtPath(pngPath)){
                    
                    data = NSData(contentsOfFile: pngPath);
                    
                    if(data == nil){
                        return nil;
                    }else{
                        var scale : CGFloat = isRetina ? 2.0:1.0;
                        return UIImage(data: data!, scale: scale);
                    }
                }else{
                    return nil;
                }
            }else{
                return nil;
            }
            
        }
    }
    
    
    /* Cache Drawed New Image
    *
    */
    public class func cacheDrawedImage(imageName image : NSString, cacheName : NSString, completion:(( imageToDraw : UIImage) -> UIImage)) -> UIImage? {
        
        
        var imageName : NSString = "";
        var realImageName : NSString = "";
        var isRetina : Bool = ODDeviceUtil.isRetinaDevice();
        var libraryPath : NSString = self.libraryDirectory();
        var data = NSData?();
        var cachePath : NSString = libraryPath.stringByAppendingPathComponent(kImageCachePath);
        
        if(isRetina){
            imageName = NSString(format: kImageRetina+kImageExtension, cacheName);
            realImageName = NSString(format: kImageRetina, image);
        }else{
            imageName = NSString(format: kImageNoRetina+kImageExtension, cacheName);
            realImageName = NSString(format: kImageNoRetina, image);
        }
        
        if(!(NSFileManager.defaultManager().fileExistsAtPath(cachePath))){
            self.createDirectory(directoryName: kImageCachePath, filePath: libraryPath);
        }
        
        var pngPath : NSString = cachePath.stringByAppendingPathComponent(imageName);
        
        if(NSFileManager.defaultManager().fileExistsAtPath(pngPath)){
            
            data = NSData(contentsOfFile: pngPath);
            
            if(data == nil){
                return nil;
            }else{
                var scale : CGFloat = isRetina ? 2.0:1.0;
                return UIImage(data: data!, scale: scale);
            }
        }else{
            
            //Not exist, draw and write it in image cache folder.
            
            var finalFilePath : NSString = NSString();
            
            if let filePath : NSString = NSBundle.mainBundle().pathForResource(realImageName, ofType: kImageExtension){
                finalFilePath = filePath;
                
                data = NSData(contentsOfFile: finalFilePath);
                
                if(data == nil){
                    return nil;
                }
                
            }else{
                finalFilePath = cachePath.stringByAppendingPathComponent(kImageNoRetina+kImageExtension+image);
                
                data = NSData(contentsOfFile: finalFilePath);
                
                if(data == nil){
                    return nil;
                }
            }
            
            var scale : CGFloat = isRetina ? 2.0:1.0;
            var image : UIImage? = UIImage(data: data!, scale: scale)!;
            
            image = completion(imageToDraw: image!);
            
            if(UIImagePNGRepresentation(image).writeToFile(pngPath, atomically: true)){
                if(NSFileManager.defaultManager().fileExistsAtPath(pngPath)){
                    
                    data = NSData(contentsOfFile: pngPath);
                    
                    if(data == nil){
                        return nil;
                    }else{
                        var scale : CGFloat = isRetina ? 2.0:1.0;
                        return UIImage(data: data!, scale: scale);
                    }
                }else{
                    return nil;
                }
            }else{
                return nil;
            }
            
        }
    }
    
    // MARK : private functions
    
    
    /* Library Directory
    * Get app library cache folder
    */
    private class func libraryDirectory() -> NSString {
        return NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)[0] as NSString;
    }
    
    /* Create directory
    * Create directory with a name and a file path
    */
    private class func createDirectory(directoryName name : NSString, filePath : NSString ) -> Void {
        var filePathAndDirectory : NSString = filePath.stringByAppendingPathComponent(name);
        var error : NSError?;
        
        NSFileManager.defaultManager().createDirectoryAtPath(filePathAndDirectory, withIntermediateDirectories: false, attributes: nil, error: &error);
        
        if(error != nil){
            NSLog("ODImageCached", "can't create directory");
        }
    }
    
    
}

