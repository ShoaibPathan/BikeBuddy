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
    
    let viewModel = MainViewModel()
    var currentLocation: Location? {
        didSet {
            guard let currentLocation = self.currentLocation else { return }
            centerMapOnLocation(CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude))
        }
    }
    
    var stationLocations: [MapStationLocation]? {
        didSet {
            filteredStationLocations = stationLocations
            segmentedControl.selectedSegmentIndex = 0
        }
    }
    var filteredStationLocations: [MapStationLocation]? {
        didSet {
            guard let filteredStationLocations = filteredStationLocations else { return }
            if let stationLocations = self.stationLocations {
                self.mapView.removeAnnotations(stationLocations)
            }
            self.mapView.addAnnotations(filteredStationLocations)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.mapType = MKMapType.standard
        setupLocationServices()
//        viewModel.fetchFooData()
        if DataBase.isDataInValid {
            viewModel.fetchData()
        }
        
        viewModel.bikeBuddyData.bind { data in
           DataBase.write(data)
        }
//
//        viewModel.mapStationLocations.bind { [unowned self] stationLocations in
//            self.stationLocations = stationLocations
//        }
//        
//        viewModel.curretLocation.bind { currentLocation in
//            self.currentLocation = currentLocation
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let currentLocation = self.currentLocation else { return }
        centerMapOnLocation(CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude))
    }
    
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        guard let option = UserOptions(rawValue: sender.selectedSegmentIndex) else {
            return
        }
        filterLocations(for: option)
    }
    
    @IBAction func centerMapButtonAction(_ sender: UIButton) {
        
    }
    
    
    func filterLocations(for userOption: UserOptions) {
        switch userOption {
        case .all:
            filteredStationLocations = stationLocations
        case .pickup:
            filteredStationLocations = stationLocations?.filter{ ($0.station?.freeBikes)! > 0}
        case .dropout:
            filteredStationLocations = stationLocations?.filter{  ($0.station?.emptySlots)! > 0}
        }
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
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, viewModel.regionRadius * 2.0, viewModel.regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func setupLocationServices() {
        guard CLLocationManager.locationServicesEnabled() else {
            viewModel.locationManager.requestWhenInUseAuthorization()
            return
        }
        viewModel.locationManager.delegate = self
        viewModel.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        viewModel.locationManager.startUpdatingLocation()
        
        if let location = viewModel.locationManager.location {
            centerMapOnLocation(location)
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
