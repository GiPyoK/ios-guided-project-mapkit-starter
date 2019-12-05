//
//  EarthquakesViewController.swift
//  Quakes
//
//  Created by Paul Solt on 10/3/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

import UIKit
import MapKit

class EarthquakesViewController: UIViewController {
		
	// NOTE: You need to import MapKit to link to MKMapView
	@IBOutlet var mapView: MKMapView!
    
    var quakeFetcher = QuakeFetcher()
	
	override func viewDidLoad() {
		super.viewDidLoad()
        
        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "QuakeView")
        
        fetchQuakes()
		
	}
    
    private func fetchQuakes() {
        quakeFetcher.fetchQuakes { (quakes, error) in
            if let error = error {
                fatalError("Error: \(error)")
            }
            
            if let quakes = quakes {
                // print("Quakes: \(quakes)")
                print("Number of Quakes: \(quakes.count)")
                
                // Show a region of interest -> Zoom map to location
                // Show the biggest quake
                // Customize the popup (register Cell)
                // Custom pin color
                
                DispatchQueue.main.async {
                    self.mapView.addAnnotations(quakes)
                    
                    // Zoom to the earthquake
                    // guard let largestQuake = quakes.first else { return }
                    
                    // Zoom to La Habra
                    let coordinateSpan = MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
                    let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 33.9319, longitude: -117.9461), span: coordinateSpan)
                    self.mapView.setRegion(region, animated: true)
                }
            }
        }
    }
}

extension EarthquakesViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let quake = annotation as? Quake else { fatalError("Only Quake objects are shown in demo") }
        
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "QuakeView") as? MKMarkerAnnotationView else {
            print("Missing a registered map annotation view")
            return nil
        }
        
        annotationView.glyphImage = UIImage(named: "QuakeIcon")
        
        if quake.magnitude >= 6 {
            annotationView.markerTintColor = .red
        } else if quake.magnitude >= 3 && quake.magnitude < 6 {
            annotationView.markerTintColor = .orange
        } else {
            annotationView.markerTintColor = .yellow
        }
        
        annotationView.canShowCallout = true
        let detailView = QuakeDetailView()
        detailView.quake = quake
        annotationView.detailCalloutAccessoryView = detailView
        
        return annotationView
    }
}
