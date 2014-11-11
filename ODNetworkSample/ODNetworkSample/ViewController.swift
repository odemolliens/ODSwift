//
//  ViewController.swift
//  ODNetworkSample
//
//  Created by OlivierDemolliens on 04/11/14.
//  Copyright (c) 2014 dreamteam. All rights reserved.
//

import UIKit
import ODNetwork
import Alamofire

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ODRequest.call(method:.GET, url:"http://httpbin.org/get", expire: NSDate(timeIntervalSince1970: NSDate().timeIntervalSince1970+40),success :{data, response in
            
            NSLog("success:%@",/*NSString(data: data!, encoding: NSUTF8StringEncoding)!*/"");
            
            },failure:{data, error in
                NSLog("fail");
        });
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    
}

