//
//  RideEstimationModal.swift
//  OlaDemo
//
//  Created by Ruby Kaushik on 16/09/16.
//  Copyright © 2016 Ruby Kaushik. All rights reserved.
//

import Foundation

class RideEstimationModal: NSObject {
    
    var amountMax : Int?
    var amountMin : Int?
    var category : String?
    var distance : String?
    var minimumFare : String?
    var travelTimeInMinutes : Int?
    
    init?(jsonArray : Array<[String : AnyObject]>?)
    {
        if let JSONArray = jsonArray
        {
            
            for JSON in JSONArray
            {
                if let amount_max = JSON["amount_max"] as? Int {
                    self.amountMax = amount_max
                }
                
                if let amount_min = JSON["amount_min"] as? Int {
                    self.amountMin = amount_min
                }
                
                if let category = JSON["category"]as? String {
                    self.category = category
                }
                
                if let distance = JSON["distance"] as? String  {
                    self.distance = distance
                }
                
                if let travel_time_in_minutes = JSON["travel_time_in_minutes"] as? Int {
                    self.travelTimeInMinutes = travel_time_in_minutes
                }
            }
        }
        
    }

}
