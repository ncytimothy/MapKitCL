//
//  ViewController.swift
//  MapKitCL
//
//  Created by Tim Ng on 7/6/19.
//  Copyright © 2019 Tim Ng. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    
    let mapView: MKMapView = {
        let mapView = MKMapView()
        return mapView
    }()
    
    var currentLocation: CLLocation?
    
    let currentLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Current Location", for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(updateToCurrentLocation), for: .touchUpInside)
        return button
    }()
    
    // 1. Create the location manager
    let locationManager = CLLocationManager()
    
    // 2. Enable location services based on authorization
    func enableBasicLocationServices() {
        // At the same time, conform to the CLLocationManagerDelegate
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            // Request when-in-use authorization if not determined
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted, .denied:
            // Disable location features if not allowed
            disableAppLocationBasedFeatures()
            break
        default:
            enableAppLocationBasedFeatures()
            break
        }
    }
    
    // 3. Manage if location authorization changes, CoreLocation does this asynchronously
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:
            disableAppLocationBasedFeatures()
            break
        case .authorizedWhenInUse:
            enableAppLocationBasedFeatures()
            break
        case .notDetermined, .authorizedAlways:
            break
        }
    }
    
    func enableAppLocationBasedFeatures() {
        startReceivingLocationChanges()
    }
    
    func disableAppLocationBasedFeatures() {
        locationManager.stopUpdatingLocation()
    }
    
    
    // 4. Location Methods
    func startReceivingLocationChanges() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus != .authorizedWhenInUse && authorizationStatus != .authorizedAlways {
            // A. User did not authorize location use
            return
        }
        
        // B. Do not start services that are not enabled
        if !CLLocationManager.locationServicesEnabled() {
            return
        }
        
        // C. Configure and start the service
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 100.00
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.startUpdatingLocation()
    }
    
    // Receiving location updates when location changes
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations.last!
        currentLocation = lastLocation
        setCurrentLocationMapRegion(lastLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            locationManager.stopUpdatingLocation()
            return
        }
        // Notify any errors
    }
    
    @objc func updateToCurrentLocation() {
        locationManager.requestLocation()
        guard let currentLocation = currentLocation else { return }
        setCurrentLocationMapRegion(currentLocation)
    }
    
    fileprivate func setCurrentLocationMapRegion(_ lastLocation: CLLocation) {
        mapView.showsUserLocation = true
        mapView.region.center = CLLocationCoordinate2D(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
        mapView.region.span = .init(latitudeDelta: 0.01, longitudeDelta: 0.01)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotation = mapView.dequeueReusableAnnotationView(withIdentifier: "annotation") as! MKAnnotationView
        return annotation
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(mapView)
        view.addSubview(currentLocationButton)
        
        mapView.fillSuperview()
        currentLocationButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 16))
        enableBasicLocationServices()
    }


}

