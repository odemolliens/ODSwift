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
import QuartzCore
import UIKit

/*
*
*/
class ODSpinnerView : UIView {
    
    var thickness:Float;
    
    //Colors
    var colors:NSArray;
    var posColors:NSArray;
    var currentPosColors:Int;
    
    //Layers
    var textLayer:CATextLayer;
    var maskLayer:CALayer;
    var wellLayer:CAShapeLayer;
    var spinLayer:CAShapeLayer;
    
    //Timer
    var anim:Float;
    var duration:Float;
    
    //Status
    var progressStatus:Float;
    var maxProgressStatus:Float;
    var timeIntervalProgress:Float;
    var textDisplay:Bool;
    
    // MARK: init
    
    override init(frame: CGRect) {
        self.progressStatus = 0;
        self.thickness = 0;
        self.anim = 0;
        self.duration = 0;
        self.maxProgressStatus = 0;
        self.timeIntervalProgress = 0.1;
        self.textDisplay = false;
        
        self.colors = NSArray();
        self.posColors = NSArray();
        self.currentPosColors = -1;
        
        self.textLayer = CATextLayer();
        
        self.maskLayer = CALayer();
        
        self.wellLayer = CAShapeLayer();
        self.spinLayer = CAShapeLayer();
        
        super.init(frame: frame);
        self.mInit();
        
    }
    
    required init(coder aDecoder: NSCoder) {
        
        self.progressStatus = 0;
        self.thickness = 0;
        self.anim = 0;
        self.duration = 0;
        self.maxProgressStatus = 0;
        self.timeIntervalProgress = 0.1;
        self.textDisplay = false;
        
        self.colors = NSArray();
        self.posColors = NSArray();
        self.currentPosColors = -1;
        
        self.textLayer = CATextLayer();
        
        self.maskLayer = CALayer();
        
        self.wellLayer = CAShapeLayer();
        self.spinLayer = CAShapeLayer();
        
        super.init(coder: aDecoder);
        self.mInit();
        
    }
    
    /**
    * Init colors
    **/
    func mInit(){
        
        //Configure properties
        self.thickness = 8;
        self.textLayer.string = "0";
        self.textLayer.alignmentMode = kCAAlignmentCenter;
        
        self.wellLayer.strokeColor = UIColor.grayColor().CGColor;
        self.wellLayer.fillColor = UIColor.clearColor().CGColor;
        self.wellLayer.shadowColor = UIColor.darkGrayColor().CGColor;
        self.wellLayer.shadowOpacity = 1;
        self.wellLayer.shadowOffset = CGSizeZero;
        
        self.spinLayer.strokeColor = UIColor.blueColor().CGColor;
        self.spinLayer.fillColor = UIColor.clearColor().CGColor;
        
        // Manage elements
        self.spinLayer.lineWidth = CGFloat(self.thickness);
        self.wellLayer.lineWidth = CGFloat(self.thickness);
        
        self.layer.addSublayer(textLayer);
        self.layer.addSublayer(self.wellLayer);
        self.layer.addSublayer(self.spinLayer);
    }
    
    // MARK: methods
    
    /**
    * Progress methods
    * Move the current progress to the params value
    * value : go to the progress (>0 <100)
    * animated : animate the progress
    * duration : duration animation
    */
    func progress(value : Float, animated : Bool,text : Bool, speed : Float) -> Void {
        
        self.maxProgressStatus = value;
        self.textDisplay = text;
        
        if(animated){
            // TODO : maybe?
            //self.currentPosColors = 0;
            self.anim = 0;
            
            self.timeIntervalProgress = 100;
            
            NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(speed), target: self, selector: "animation:", userInfo: nil, repeats: animated);
        }else{
            anim = 1;
            self.animated(self.maxProgressStatus/100, animated: false);
        }
    }
    
    
    func progress(value : Float, animated:Bool,text : Bool, speed : Float, colorArray:NSArray, progressColorArray:NSArray) -> Void {
        
        //Force first value
        self.spinLayer.strokeColor = (colorArray.objectAtIndex(0) as UIColor).CGColor;
        
        self.colors = colorArray;
        self.posColors = progressColorArray;
        self.progress(value-1, animated: animated, text: text, speed:speed);
    }
    
    /**
    * Animation method
    * Fill the bar to the previous value setted
    */
    func animation(timer : NSTimer) -> Void
    {
        anim += 0.03;
        if(anim >= (self.maxProgressStatus/100)){
            
            //anim = 1;
            timer.invalidate();
        }
        self.animated(anim, animated: true);
    }
    
    func animated(progress : Float, animated:Bool) -> Void {
        var currentProgressStatus : Float = self.progressStatus;
        self.progressStatus = progress;
        
        CATransaction.begin();
        
        if(animated==true){
            var delta : Float = fabs(self.progressStatus-currentProgressStatus);
            if(self.textDisplay){
                self.textLayer.string = NSString(format:"%.f",self.progressStatus*100);
            }else{
                self.textLayer.string = "";
            }
            
            CATransaction.setAnimationDuration(CFTimeInterval(fmax(0.2, delta * 1.0)));
        }else{
            if(self.textDisplay){
                self.textLayer.string = NSString(format:"%.f",self.maxProgressStatus+1);
            }else{
                self.textLayer.string = "";
            }
            
            CATransaction.setDisableActions(true);
        }
        roundedColor();
        
        self.spinLayer.strokeEnd = CGFloat(self.progressStatus);
        CATransaction.commit();
    }
    
    func roundedColor() -> Void
    {
        var colorsCount:Int = self.colors.count;
        
        if(colorsCount>0){
            //Manage many colors
            
            for(var i = self.posColors.count-1; i >= 0;i--){
                if((self.progressStatus*100) > (self.posColors.objectAtIndex(i)as Float)){
                    if(i != self.currentPosColors){
                        self.currentPosColors = i;
                        self.spinLayer.strokeColor = (self.colors.objectAtIndex(i) as UIColor).CGColor;
                    }
                    break;
                }
            }
        }
    }
    
    
    func radius() -> Float {
        
        var thickDiv : CGFloat = CGFloat(self.thickness / 2.0);
        var rect : CGRect = CGRectInset(self.bounds, thickDiv, thickDiv);
        var w : CGFloat = rect.size.width;
        var h : CGFloat = rect.size.height;
        
        if(w>h){
            return Float(h) / 2.0;
        }else{
            return Float(w) / 2.0;
        }
    }
    
    // MARK: draw
    
    override func layoutSubviews() {
        super.layoutSubviews();
        
        var bounds : CGRect = self.bounds;
        var wellDiv : CGFloat = CGFloat(self.thickness / 2.0);
        var outer : CGRect = CGRectInset(bounds, wellDiv, wellDiv);
        var inner : CGRect = CGRectInset(bounds, CGFloat(self.thickness), CGFloat(self.thickness));
        
        var innerPath : UIBezierPath = UIBezierPath(ovalInRect:inner);
        var outerPath : UIBezierPath = UIBezierPath(arcCenter: CGPointMake(CGRectGetMidX(outer), CGRectGetMidY(outer)), radius: CGFloat(self.radius()), startAngle: CGFloat(-M_PI_2), endAngle: (2.0 * CGFloat(M_PI) - CGFloat(M_PI_2)), clockwise: true);
        
        self.wellLayer.path = outerPath.CGPath;
        self.spinLayer.path = outerPath.CGPath;
        
        self.textLayer.frame = CGRectMake(bounds.origin.x, bounds.size.height/3.5/*Harcoded value*/, bounds.size.width, bounds.size.height);
        self.maskLayer.frame = bounds;
        self.spinLayer.frame = bounds;
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.mainScreen().scale);
        innerPath.fill();
        self.maskLayer.contents = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    
}