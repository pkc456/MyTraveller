//
//  APIHandler.swift
//  OlaDemo
//
//  Created by Ruby Kaushik on 16/09/16.
//  Copyright © 2016 Ruby Kaushik. All rights reserved.
//

import Foundation


protocol EndPoint {
    
    var urlString : String {get}
}
//http://sandbox-t.olacabs.com/v1/products?pickup_lat=12.9491416&pickup_lng=77.64298& category=micro
enum MakeAPI : EndPoint
{
    case GetCabFareEstimation (coordinate : CoordinateModal)
    case GetFareAvailability(coordinate : CoordinateModal)
    
    var urlString : String
    {
        switch self
        {
            case .GetCabFareEstimation(let coordinate) :
                let path = "v1/products?pickup_lat=\(coordinate.pickUplat)&pickup_lng=\(coordinate.pickUPlong)&drop_lat=\(coordinate.dropLatitude)&drop_lng=\(coordinate.dropLongitude)&category=\(coordinate.category)"

                return path
            
        case .GetFareAvailability(let coordinate) :
            let path = "v1/products?pickup_lat=\(coordinate.pickUplat)&pickup_lng=\(coordinate.pickUPlong)&category=\(coordinate.category)"
            return path
        
        }
    }

    
    
}