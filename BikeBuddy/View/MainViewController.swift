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

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.mapType = .standard
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.setLocationManagerDelegate(self)
        viewModel.fetchData()
        
        viewModel.bikeBuddyData.bind { data in
            DataBase.write(data)
        }
    }
    
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        guard let option = UserOptions(rawValue: sender.selectedSegmentIndex) else {
            return
        }
    }
    
    @IBAction func centerMapButtonAction(_ sender: UIButton) {
        centerMapOnLocation(viewModel.currentLocation)
    }
    
    enum UserOptions: Int {
        case all, pickup, dropout
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
            viewModel.currentLocation = currentLocation
            centerMapOnLocation(currentLocation)
        }
    }
}

extension MainViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? MapStationLocation else { return nil }
        
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
}
