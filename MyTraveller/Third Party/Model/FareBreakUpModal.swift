//
//  FareBreakUpModal.swift
//  OlaDemo
//
//  Created by Ruby Kaushik on 16/09/16.
//  Copyright © 2016 Ruby Kaushik. All rights reserved.
//

import Foundation

class FareBreakUpModal: NSObject {
    
    var baseFare : String?
    var costPerDistance : String?
    var minimumDistance : String?
    var minimumTime : String?
    var minimumFare : String?
    var rideCostPerMinute : String?
    var type : String?
    var waitingCostPerMinute : String?
    
    
    init(JSON : [String : AnyObject])
    {
        if let baseFare = JSON["base_fare"] as? String {
            self.baseFare = baseFare
        }
        if let costPerDistance = JSON["cost_per_distance"] as? String {
            self.costPerDistance = costPerDistance
        }
        if let minimumDistance = JSON["minimum_distance"]as? String {
            self.minimumDistance = minimumDistance
        }
        if let minimumFare = JSON["minimum_fare"] as? String {
            self.minimumFare = minimumFare
        }
        if let minimumTime = JSON["minimum_time"] as? String {
            self.minimumTime = minimumTime
        }
        if let ridePerMinute = JSON["ride_cost_per_minute"] as? String  {
            self.rideCostPerMinute = ridePerMinute
        }
        if let type = JSON["type"] as? String {
            self.type = type
        }
        if let waitingPerMin = JSON["waiting_cost_per_minute"] as? String
        {
            self.waitingCostPerMinute = waitingPerMin
        }
    }



}
