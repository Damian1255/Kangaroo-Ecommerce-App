//
//  MapViewController.swift
//  KangarooApp
//
//  Created by Damian on 24/2/22.
//  Copyright © 2022 ITE. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let anns = [MKPointAnnotation(), MKPointAnnotation()]
        anns[0].coordinate = CLLocationCoordinate2D(latitude: 1.290062, longitude: 103.855784)
        anns[0].title = "Pick up 1"
        anns[0].subtitle = "Pick up point 1"
        
        anns[1].coordinate = CLLocationCoordinate2D(latitude: 1.403539, longitude: 103.790721)
        anns[1].title = "Pick up 2"
        anns[1].subtitle = "Pick up point 2"
        
        mapView.addAnnotations(anns)
        
        mapView.setCenter(anns[0].coordinate, animated: false)
    }
    
    @IBAction func dismissBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        var annView = mapView.dequeueReusableAnnotationView(withIdentifier: "Pin")
        if annView == nil {
            annView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
        }
        
        if (annotation.title)! == "Esplanade" {
            annView?.image = UIImage(named: "Kangaroo")
        }
        else if (annotation.title)! == "River Safari" {
            annView?.image = UIImage(named: "Kangaroo")
        }
        annView!.canShowCallout = true
        
        return annView
    }
}

