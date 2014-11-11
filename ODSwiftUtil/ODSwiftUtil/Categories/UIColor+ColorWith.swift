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
import UIKit

/* UIColor+ColorWith
* Easy way to generate colors from RGB/RGBA
*/

extension UIColor {
    
    /* Color With Hex
    * UIColor with specified hexadecimal color and alpha
    */
    class func colorWithHex (hex: Int, alpha: Double) -> UIColor {
        
        let red : Double = Double((hex & 0xFF0000) >> 16) / 255.0;
        let green : Double = Double((hex & 0xFF00) >> 8) / 255.0;
        let blue : Double = Double((hex & 0xFF)) / 255.0;
        
        var color : UIColor = UIColor( red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha:CGFloat(alpha));
        
        return color
    }
    
    /* Color With Hex
    * UIColor with specified RGBA color and alpha
    */
    class func colorWithHex (rgba:NSString, alpha: Double) -> UIColor
    {
        var red: Double = 0.0
        var green: Double = 0.0
        var blue: Double = 0.0
        var alpha: Double = 1.0
        
        if rgba.hasPrefix("#") {
            let hex = rgba.substringFromIndex(1) as NSString;
            let scanner = NSScanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexLongLong(&hexValue) {
                if hex.length == 6 {
                    red = Double((hexValue & 0xFF0000) >> 16) / 255.0
                    green = Double((hexValue & 0x00FF00) >> 8) / 255.0
                    blue = Double(hexValue & 0x0000FF) / 255.0
                } else if hex.length == 8 {
                    red = Double((hexValue & 0xFF000000) >> 24) / 255.0
                    green = Double((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue = Double((hexValue & 0x0000FF00) >> 8) / 255.0
                    alpha = Double(hexValue & 0x000000FF) / 255.0
                } else {
                    print("invalid rgb string, length should be 7 or 9")
                }
            } else {
                println("scan hex error")
            }
        } else {
            print("invalid rgb string, missing '#' as prefix")
        }
        return UIColor(red:CGFloat(red), green:CGFloat(green), blue:CGFloat(blue), alpha:CGFloat(alpha));
    }
    
    /* Color With RGB
    * UIColor with specified RGB color and alpha
    */
    class func colorWithRGB(rgbValue: UInt, alpha: Double) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
    
}

