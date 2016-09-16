//
//  UtilityClass.swift
//  OlaDemo
//
//  Created by Ruby Kaushik on 15/09/16.
//  Copyright © 2016 Ruby Kaushik. All rights reserved.
//

import UIKit

class UtilityClass: NSObject {
    
    static let sharedInstance = UtilityClass()
    private let rootVC = (UIApplication.sharedApplication().delegate as! AppDelegate).window!.rootViewController
    
    private override init() {
    }
    
    
    func showAlertViewWithMessage(message : String?)
    {
        let alerController = UIAlertController(title: "My Travel", message: message ?? "", preferredStyle: .Alert)
        
        alerController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
        }))
        
        rootVC?.presentViewController(alerController, animated: true, completion: nil)
    }


}
