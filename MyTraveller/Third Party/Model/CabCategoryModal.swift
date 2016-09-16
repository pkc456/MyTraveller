//
//  CabCategoryModal.swift
//  OlaDemo
//
//  Created by Ruby Kaushik on 16/09/16.
//  Copyright © 2016 Ruby Kaushik. All rights reserved.
//

import Foundation

class CabCategoryModal: NSObject {
    
    var cabId : String?
    var currency : String?
    var displayName : String?
    var distanceUnit : String?
    var distance : String?
    var eta : Int?
    var imageUrl : String?
    var timeUnit : String?
    var fareBreakupModal : Array<FareBreakUpModal>?
    
    init?(jsonArray : Array<[String : AnyObject]>?)
        {
            if let JSONArray = jsonArray
            {
                
                for JSON in JSONArray
                {
                    if let cabId = JSON["id"] as? String {
                        self.cabId = cabId
                    }
                    
                    if let timeUnit = JSON["time_unit"] as? String {
                        self.timeUnit = timeUnit
                    }
                    
                    if let imageUrl = JSON["image"]as? String {
                        self.imageUrl = imageUrl
                    }
                    
                    if let eta = JSON["eta"] as? Int  {
                        self.eta = eta
                    }
                    
                    if let distanceUnit = JSON["distance_unit"] as? String {
                        self.distanceUnit = distanceUnit
                    }
                    if let distance = JSON["distance"] as? String {
                        self.distance = distance
                    }
                    if let displayName = JSON["display_name"] as? String{
                        self.displayName = displayName
                    }
                    if let currency = JSON["currency"] as? String {
                        self.currency = currency
                    }
                    if let fareBreakup = (JSON["fare_breakup"] as? Array<[String : AnyObject]>)
                    {
                        for dict in fareBreakup {
                            let fareBreakupModal = FareBreakUpModal(JSON: dict)
                            self.fareBreakupModal?.append(fareBreakupModal)
                        }
                    }
                }
            }

        }

}



