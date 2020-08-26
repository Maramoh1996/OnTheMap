//
//  AddMediaViewController.swift
//  OnTheMap
//
//  Created by Maram Moh on 12/07/2020.
//  Copyright © 2020 Maram Moh. All rights reserved.
//

import UIKit
import MapKit

class AddMediaViewController: ViewController,UITextViewDelegate, MKMapViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        mediaLink.delegate = self
        mediaLink.text = "Enter a Link to Share Here"
        mediaLink.textColor = UIColor.white
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToNotificationsObserver()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromNotificationsObserver()
    }
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mediaLink: UITextView!
    
    var LocataionInfo: StudentLocation?
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if mediaLink.textColor == UIColor.white {
            mediaLink.text = nil
            mediaLink.textColor = UIColor.black
        }
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if mediaLink.text.isEmpty {
            mediaLink.text = "Enter a Link to Share Here"
            mediaLink.textColor = UIColor.white
        }
    }
    
    func  fillMediaField(){
        guard  let link = mediaLink.text,
            link != "" else {
                self.showAlert(title: "Error", message: "fill the field")
                return
        }
    }
    
    @IBAction func Submit(_ sender: Any) {
        UdacityAPI.postLocation(self.LocataionInfo!) { err in
            guard err == nil else{
                self.showAlert(title: "Error", message: err!)
                return
            }
            
            
        }
        self.navigationController?.popToRootViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    func setupMap() {
        guard let location = LocataionInfo else { return }
        
        let lat = CLLocationDegrees(location.latitude!)
        let long = CLLocationDegrees(location.longitude!)
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
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
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
}

