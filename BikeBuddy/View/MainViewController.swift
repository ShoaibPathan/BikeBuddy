//
//  MainViewController.swift
//  BikeBuddy
//
//  Created by Lech H. Conde on 18/05/2018.
//  Copyright © 2018 Lech H. Conde. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class MainViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var centerMapButton: UIButton!
    
    private lazy var viewModel = MainViewModel()
    
    var nearbySpots: [Network] {
        return DataBase.nearbySpots(mapRect: mapView.visibleMapRect)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.mapType = .standard
        centerMapOnLocation(viewModel.currentLocation)
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.setLocationManagerDelegate(self)
        viewModel.fetchData()
        
        viewModel.isdataReceived.then { [weak self] _ in
            self?.addAnnotations()
        }
    }
    
    private func addAnnotations() {
        nearbySpots.forEach { spot in
            let annotation = MKPointAnnotation()
            annotation.title = spot.name
            annotation.coordinate = spot.coordinates
            mapView.addAnnotation(annotation)
        }
    }
    
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
    }
    
    @IBAction func centerMapButtonAction(_ sender: UIButton) {
        centerMapOnLocation(viewModel.currentLocation)
    }
}

extension MainViewController: CLLocationManagerDelegate {
    
    func centerMapOnLocation(_ location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: viewModel.regionRadius * 2.0,
                                                  longitudinalMeters: viewModel.regionRadius * 2.0)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            guard let currentLocation = manager.location else { return }
            centerMapOnLocation(currentLocation)
        }
    }
}

extension MainViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        return view
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        addAnnotations()
    }
}
