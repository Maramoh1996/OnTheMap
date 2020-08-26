//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Maram Moh on 12/07/2020.
//  Copyright © 2020 Maram Moh. All rights reserved.
//

import UIKit
import CoreLocation

class AddLocationViewController: ViewController {

   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
      override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          
          subscribeToNotificationsObserver()
      }
      
      override func viewWillDisappear(_ animated: Bool) {
          super.viewWillDisappear(animated)
          
          unsubscribeFromNotificationsObserver()
      }
      
    @IBOutlet weak var yourLocation: UITextField!
    
    
    @IBAction func findOnTheMap(_ sender: Any) {
            guard let location = self.yourLocation.text,
                     location != "" else {
                        self.showAlert(title: "Error", message: "Fill the field")
                   return
               }
        
               let studentLocation = StudentLocation(mapString: location)
               geocodeCoordinates(studentLocation)

        }
    
 func geocodeCoordinates(_ studentLocation: StudentLocation) {
    let ai = self.startAnActivityIndicator()
        CLGeocoder().geocodeAddressString(studentLocation.mapString!) { (placeMarks, err) in
        ai.stopAnimating()
        if let error = err {
            self.showAlert(title: "Error", message: "Geocoding fails")
            return
        }
        
        guard let firstLocation = placeMarks?.first?.location else {
            self.showAlert(title: "Missing information", message: "location not found")
            return }
        
        var location = studentLocation
        location.latitude = firstLocation.coordinate.latitude
        location.longitude = firstLocation.coordinate.longitude
            
    
        
         self.performSegue(withIdentifier: "mapSegue", sender: location)
    }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapSegue", let vc = segue.destination as? AddMediaViewController{
            vc.LocataionInfo = (sender as! StudentLocation)
        }
    }
    
    @IBAction  func cancel(_ sender: Any) {
          self.dismiss(animated: true, completion: nil)
      }
    
  
    
}

  
