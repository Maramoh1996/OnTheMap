//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Maram Moh on 28/06/2020.
//  Copyright © 2020 Maram Moh. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: ViewController, MKMapViewDelegate {
    
    
    override var locationInfo: LocataionInfo? {
        didSet {
            setUp()
           
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
 
        loadStudentLocations()
        
    }
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func logOut(_ sender: Any) {
        UdacityAPI.logOut(completion: { err in })
            dismiss(animated: true, completion: nil)
        }
    
    
    
    @IBAction func refreshButton(_ sender: Any) {
        loadStudentLocations()
    }
    @IBAction func plusButton(_ sender: Any) {
        self.performSegue(withIdentifier: "AddLocationNavigationController", sender: nil)
    }
    
   

    
    
    
    func setUp(){
        guard let locations = locationInfo?.results else { return }
      var annotations = [MKPointAnnotation]()
            for location in locations {
                guard let latitude = location.latitude,
                    let longitude = location.longitude
                    else { continue }
                let lat = CLLocationDegrees(latitude)
                let long = CLLocationDegrees(longitude)
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let first = location.firstName
                let last = location.lastName
                let mediaURL = location.mediaURL
                
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(first ?? "") \(last ?? "")"
                annotation.subtitle = mediaURL
                
                annotations.append(annotation)
            }
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotations(annotations)
//          print("pins are there")
        }
    
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle!,
                let url = URL(string: toOpen), app.canOpenURL(url) {
                app.open(url, options: [:], completionHandler: nil)
            }
        }
    }
   
    
}
