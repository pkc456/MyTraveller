//
//  FirstViewController.swift
//  MyTraveller
//
//  Created by Pardeep Chaudhary on 15/09/16.
//  Copyright © 2016 Pardeep Chaudhary. All rights reserved.
//

import UIKit
import UberRides
import CoreLocation

enum CabType : Int{
    case Ola = 0
    case Uber
}

class FirstViewController: UIViewController, UITextFieldDelegate, RideRequestButtonDelegate {
    
    @IBOutlet weak var textfieldSource: MVPlaceSearchTextField!
    @IBOutlet weak var textfieldDestination: MVPlaceSearchTextField!
    
    @IBOutlet var etaLabel: UILabel!
    @IBOutlet var maximumFareLabel: UILabel!
    @IBOutlet var minimumFareLabel: UILabel!
    
    var sourceCoordinate : GMSPlace? = nil
    var destinationCoordinate : GMSPlace? = nil
    
    private var cabType : CabType = .Uber
    
    let ridesClient = RidesClient()
    let button = RideRequestButton()
    
//    @IBOutlet weak var buttonUber: RideRequestButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        self.setUberButton()
        self.setSourceTextfield()
        self.setDestinationTextfield()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUberButton(){
//        let pickupLocation = CLLocation(latitude: 28.444297, longitude: 77.038529)//Source address//iffco chonk gurgaon
//        let dropoffLocation = CLLocation(latitude: 28.610940, longitude: 77.234482)//Destination address//India gate
        let pickUplat = self.sourceCoordinate?.coordinate.latitude ?? 0.0
        let pickUpLong = self.sourceCoordinate?.coordinate.longitude ?? 0.0
        
        let dropLat = self.destinationCoordinate?.coordinate.latitude ?? 0.0
        let dropLong = self.destinationCoordinate?.coordinate.longitude ?? 0.0
        
        
        let pickupLocation = CLLocation(latitude: pickUplat, longitude: pickUpLong)
        let dropoffLocation = CLLocation(latitude: dropLat, longitude: dropLong)
        
        let dropLocationName = self.destinationCoordinate?.name

        //make sure that the pickupLocation is set in the deeplink
        let builder = RideParametersBuilder()
            .setPickupLocation(pickupLocation)
            .setDropoffLocation(dropoffLocation,
                                nickname: dropLocationName)


        // use the same pickupLocation to get the estimate
        ridesClient.fetchCheapestProduct(pickupLocation: pickupLocation, completion: {
            product, response in
            if let productID = product?.productID { //check if the productID exists
                builder.setProductID(productID)
                
                
                
                self.button.rideParameters = builder.build()
                self.button.delegate = self

                // show estimates in the button
                self.button.loadRideInformation()
            }
        })
        
        // center the button (optional)
        button.center = view.center
        
        //put the button in the view
        view.addSubview(button)

    
//       ridesClient.fetchProducts(pickupLocation: pickupLocation) { (products, response) in
//            print(products)
//        }
    }
    
    func setSourceTextfield()
    {
//        textfieldSource.placeSearchDelegate = self
        textfieldSource.strApiKey                           = "AIzaSyCpzSYTaQd8nFgpXifFS73SD19wYr0kKb8"//define GOOGLE_API_KEY_iOS @
        textfieldSource.superViewOfList                     = self.view;  // View, on which Autocompletion list should be appeared.
        textfieldSource.autoCompleteShouldHideOnSelection   = true
        
        let rows = 4;
        textfieldSource.maximumNumberOfAutoCompleteRows     = rows;
        
//        textfieldSource.autoCompleteRegularFontName =  @"HelveticaNeue-Bold";
//        textfieldSource.autoCompleteBoldFontName = @"HelveticaNeue";
        textfieldSource.autoCompleteTableCornerRadius=0.0;
        textfieldSource.autoCompleteRowHeight = 40
        textfieldSource.autoCompleteTableCellTextColor = UIColor(white: 0.131, alpha: 1.0)
        textfieldSource.autoCompleteFontSize=12;
        textfieldSource.autoCompleteTableBorderWidth=1.0;
        textfieldSource.showTextFieldDropShadowWhenAutoCompleteTableIsOpen=true;
        textfieldSource.autoCompleteShouldHideOnSelection=true;
        textfieldSource.autoCompleteShouldHideClosingKeyboard=true;
        textfieldSource.autoCompleteShouldSelectOnExactMatchAutomatically = true;
        textfieldSource.autoCompleteTableFrame = CGRectMake(textfieldSource.frame.origin.x, textfieldSource.frame.size.height+textfieldSource.frame.origin.y+10, self.view.frame.size.width-50, 200.0);
    }
    
    func setDestinationTextfield()
    {
        textfieldDestination.strApiKey                           = "AIzaSyCpzSYTaQd8nFgpXifFS73SD19wYr0kKb8"//define GOOGLE_API_KEY_iOS @
        textfieldDestination.superViewOfList                     = self.view;  // View, on which Autocompletion list should be appeared.
        textfieldDestination.autoCompleteShouldHideOnSelection   = true
        
        let rows = 4;
        textfieldDestination.maximumNumberOfAutoCompleteRows     = rows;
        
        //        textfieldSource.autoCompleteRegularFontName =  @"HelveticaNeue-Bold";
        //        textfieldSource.autoCompleteBoldFontName = @"HelveticaNeue";
        textfieldDestination.autoCompleteTableCornerRadius=0.0;
        textfieldDestination.autoCompleteRowHeight = 40
        textfieldDestination.autoCompleteTableCellTextColor = UIColor(white: 0.131, alpha: 1.0)
        textfieldDestination.autoCompleteFontSize=12;
        textfieldDestination.autoCompleteTableBorderWidth=1.0;
        textfieldDestination.showTextFieldDropShadowWhenAutoCompleteTableIsOpen=true;
        textfieldDestination.autoCompleteShouldHideOnSelection=true;
        textfieldDestination.autoCompleteShouldHideClosingKeyboard=true;
        textfieldDestination.autoCompleteShouldSelectOnExactMatchAutomatically = true;
        textfieldDestination.autoCompleteTableFrame = CGRectMake(textfieldDestination.frame.origin.x, textfieldDestination.frame.size.height+textfieldDestination.frame.origin.y+10, self.view.frame.size.width-50, 200.0);
    }
    
    
    func setLabelTextForOLA(cabCategoryModal : CabCategoryModal?, rideEstimationModal : RideEstimationModal?)
    {
        if let eta = cabCategoryModal?.eta
        {
            self.etaLabel.text = ("\(eta) ") + (cabCategoryModal?.timeUnit ?? "")
        }
        
        if let amountMax = rideEstimationModal?.amountMax
        {
            self.maximumFareLabel.text = ("\(amountMax) ") //+ (cabCategoryModal?.currency ?? "")
        }
        
        if let amountMin = rideEstimationModal?.amountMin
        {
            self.minimumFareLabel.text = ("\(amountMin) ") //+ (cabCategoryModal?.currency ?? "")
        }

    }
    
    func setLabelTectForUber(product : UberProduct)
    {
//        if let eta = cabCategoryModal?.eta
//        {
//            self.etaLabel.text = ("\(eta) ") + (cabCategoryModal?.timeUnit ?? "")
  //      }
        
        if let amountMax = product.priceDetails?.minimumFee
        {
            self.maximumFareLabel.text = ("\(amountMax) ") //+ (cabCategoryModal?.currency ?? "")
        }
        
//        if let amountMin = rideEstimationModal?.amountMin
//        {
//            self.minimumFareLabel.text = ("\(amountMin) ") //+ (cabCategoryModal?.currency ?? "")
//        }
    }
    
    
    @IBAction func indexChanged(sender : UISegmentedControl)
    {
        self.etaLabel.text = ""
        self.minimumFareLabel.text = ""
        self.maximumFareLabel.text = ""
        switch sender.selectedSegmentIndex {
        case 0:
            self.cabType = .Uber
            break
        case 1:
            self.cabType = .Ola
            break
        default:
            break
        }
    }
    
    @IBAction func btnCalculateAction(sender: UIButton) {
//        self.uber()
        
        if cabType == .Ola
        {
            getOlaFareEstimate()
        }
        else if cabType == .Uber
        {
            self.uber()
        }
    }
    
    //MARK: - Web service
    
    func getOlaFareEstimate()
    {
        let coordinateModal = CoordinateModal()
        coordinateModal.pickUPlong = Float(self.sourceCoordinate?.coordinate.longitude ?? 0.0)
        coordinateModal.pickUplat = Float(self.destinationCoordinate?.coordinate.latitude ?? 0.0)
        coordinateModal.dropLongitude = Float(self.destinationCoordinate?.coordinate.longitude ?? 0.0)
        coordinateModal.dropLatitude = Float(self.destinationCoordinate?.coordinate.latitude ?? 0.0)
        coordinateModal.category = "prime"
        
        ServiceHandler.sharedInstance.calculateFare(true, coordinateModal: coordinateModal) { (cabCategoryModal, rideEstimationModal) in
        
            self.setLabelTextForOLA(cabCategoryModal, rideEstimationModal: rideEstimationModal)
        }

    }
    
    //MARK: Place search Textfield Delegates
    func placeSearch(textField: MVPlaceSearchTextField!, ResponseForSelectedPlace responseDict: GMSPlace!) {
        self.view.endEditing(true)
        if (textField == textfieldSource) {
            sourceCoordinate = responseDict;
        }else{
            destinationCoordinate = responseDict
        }
        
        print("Selected address: \(responseDict)")
    }
    

    func placeSearch(textField: MVPlaceSearchTextField!, responseForSelectedPlace responseDict: GMSPlace!) {
        
    }
    
    func placeSearch(textField: MVPlaceSearchTextField!, resultCell cell: UITableViewCell!, withPlaceObject placeObject: PlaceObject!, atIndex index: Int) {
        cell.textLabel?.numberOfLines = 0
    }
    
    
    func placeSearchWillHideResult(textField: MVPlaceSearchTextField!) {
        
    }
    
    func placeSearchWillShowResult(textField: MVPlaceSearchTextField!) {
        
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool{
        if(textField == textfieldSource){
            sourceCoordinate = nil
        }else{
            destinationCoordinate = nil
        }
        return true
    }
    
    //MARK:- UBER
    func uber(){
        let button = RideRequestButton()
        let ridesClient = RidesClient()
        
        let pickupLat =  sourceCoordinate?.coordinate.latitude ?? 0
        let pickupLang = sourceCoordinate!.coordinate.longitude ?? 0
        let destinationLat = sourceCoordinate!.coordinate.longitude ?? 0
        let destinationLang = destinationCoordinate!.coordinate.longitude ?? 0
        
        let pickupLocation = CLLocation(latitude: pickupLat, longitude: pickupLang)
        let dropoffLocation = CLLocation(latitude: destinationLat, longitude: destinationLang)
        var builder = RideParametersBuilder().setPickupLocation(pickupLocation).setDropoffLocation(dropoffLocation)
        ridesClient.fetchCheapestProduct(pickupLocation: pickupLocation, completion: {
            product, response in
            if let productID = product?.productID {
                builder = builder.setProductID(productID)
                button.rideParameters = builder.build()
                button.loadRideInformation()
            }
            
        /*    if let data = response.data
            {
                do
                {
                    if let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String : AnyObject]
                    {
                        print("data ==== ",json)
                        
                        if (json["code"] as? String) == "INVALID_CITY"
                        {
                            UtilityClass.sharedInstance.showAlertViewWithMessage(json["message"] as? String)
                            
                            
                        }
                        else  if let jsonArray =  json["categories"] as? Array<[String : AnyObject]>
                        {
                            let cabCategoryModal = CabCategoryModal(jsonArray: jsonArray)
                            let rideEstimationModal = RideEstimationModal(jsonArray: json["ride_estimate"] as? Array<[String : AnyObject]>)
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
                
                
            }*/

            
        })
    }
    
    //MARK: RideRequestButtonDelegate
    func rideRequestButtonDidLoadRideInformation(button: RideRequestButton) {
        button.sizeToFit()
        button.center = view.center
        print("Success")
    }
    
    func rideRequestButton(button: RideRequestButton, didReceiveError error: RidesError) {
        print("rideRequestButton Error")
    }
}

