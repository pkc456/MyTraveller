//
//  ServiceHandler.swift
//  OlaDemo
//
//  Created by Ruby Kaushik on 15/09/16.
//  Copyright © 2016 Ruby Kaushik. All rights reserved.
//

import UIKit
import Foundation
import AFNetworking

class ServiceHandler: NSObject {
    
    static let sharedInstance = ServiceHandler()
    
    func getServiceInstance() -> AFHTTPRequestOperationManager
    {
        let manager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.requestSerializer.setValue(X_APP_TOKEN, forHTTPHeaderField: "X-APP-TOKEN")
        return manager
    }
    

    func calculateFare(isFareEstimate : Bool , coordinateModal : CoordinateModal , successBlock : ((cabCategoryModal : CabCategoryModal? ,rideEstimationModal : RideEstimationModal?)-> Void))
    {
//        var urlString = BASE_URL
//        if isFareEstimate
//        {
//            urlString += MakeAPI.GetCabFareEstimation(coordinate: coordinateModal).urlString
//        }
//        else
//        {
//            urlString += MakeAPI.GetFareAvailability(coordinate: coordinateModal).urlString
//        }
        
        
        let urlString =   "http://sandbox-t.olacabs.com/v1/products?pickup_lat=12.950072&pickup_lng=77.642684&drop_lat=12.961152&drop_lng=77.652684&category=sedan"
        let manager : AFHTTPRequestOperationManager = getServiceInstance()
        
        manager.GET(urlString, parameters: nil, success: { (operation, responseObject) in
        
         //   print(responseObject.description)
            if let data = responseObject as? NSData
            {
                do
                {
                    if let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String : AnyObject]
                    {
                        print("data ==== ",json)
                        
                        if (json["code"] as? String) == "INVALID_CITY"
                        {
                            UtilityClass.sharedInstance.showAlertViewWithMessage(json["message"] as? String)
                            
                            successBlock(cabCategoryModal: nil, rideEstimationModal: nil)
                    }
                        else  if let jsonArray =  json["categories"] as? Array<[String : AnyObject]>
                        {
                            let cabCategoryModal = CabCategoryModal(jsonArray: jsonArray)
                            let rideEstimationModal = RideEstimationModal(jsonArray: json["ride_estimate"] as? Array<[String : AnyObject]>)
                            
                            successBlock(cabCategoryModal: cabCategoryModal, rideEstimationModal: rideEstimationModal)
                        }
                        else
                        {
                            UtilityClass.sharedInstance.showAlertViewWithMessage("Something is wrong")
                        }
                    }
                    
                }
                catch let error as NSError
                {
                    UtilityClass.sharedInstance.showAlertViewWithMessage(error.localizedDescription)
                }
                

            }
            
            }) { (operation, error) in
               print(error)
        }
    }
    
}
