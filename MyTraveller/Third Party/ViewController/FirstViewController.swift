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
    
    private var cabType : CabType = .Ola
    
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
        let pickupLocation = CLLocation(latitude: 28.444297, longitude: 77.038529)//Source address//iffco chonk gurgaon
        let dropoffLocation = CLLocation(latitude: 28.610940, longitude: 77.234482)//Destination address//India gate

        //make sure that the pickupLocation is set in the deeplink
        let builder = RideParametersBuilder()
            .setPickupLocation(pickupLocation)
            .setDropoffLocation(dropoffLocation,
                                nickname: "India gate")


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
    
    
    func setLabelTextOfOLA(cabCategoryModal : CabCategoryModal)
    {
        
    }
    
    @IBAction func indexChanged(sender : UISegmentedControl)
    {
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
        
        let pickupLocation = CLLocation(latitude: sourceCoordinate!.coordinate.latitude, longitude: sourceCoordinate!.coordinate.longitude)
        let dropoffLocation = CLLocation(latitude: destinationCoordinate!.coordinate.latitude, longitude: destinationCoordinate!.coordinate.longitude)
        var builder = RideParametersBuilder().setPickupLocation(pickupLocation).setDropoffLocation(dropoffLocation)
        ridesClient.fetchCheapestProduct(pickupLocation: pickupLocation, completion: {
            product, response in
            if let productID = product?.productID {
                builder = builder.setProductID(productID)
                button.rideParameters = builder.build()
                button.loadRideInformation()
            }
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

