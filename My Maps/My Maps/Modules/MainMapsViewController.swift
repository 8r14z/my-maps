//
//  MainMapsViewController.swift
//  My Maps
//
//  Created by Le Vu Hoai An on 4/27/18.
//  Copyright © 2018 Le Vu Hoai An. All rights reserved.
//

import UIKit
import GoogleMaps

class MainMapsViewController: UIViewController {
    
    fileprivate var _locationManager = CLLocationManager()
    fileprivate var _currentLocation: CLLocation?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    let DEFAULT_LOCATION = CLLocation(latitude: -33.869405, longitude: 151.199)
    let DEFAULT_ZOOM_LEVEL: Float = 15.0
    
    fileprivate var _mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupLocationManager()
        
        NotificationCenter.default.addObserver(self, selector: #selector(appDidInactive(_:)), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    @objc func appDidInactive(_ notification: Notification) {
        
    }
    
    func setupViews() {
        self._mapView = GMSMapView(frame: self.view.bounds)
        self._mapView.settings.myLocationButton = true
        self._mapView.isMyLocationEnabled = true
        self._mapView.isHidden = true
        
        self.view.addSubview(self._mapView)
    }
    
    func setupLocationManager() {
        self._locationManager = CLLocationManager()
        self._locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self._locationManager.requestAlwaysAuthorization()
        self._locationManager.distanceFilter = 50
        self._locationManager.startUpdatingLocation()
        self._locationManager.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MainMapsViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!

        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: DEFAULT_ZOOM_LEVEL)

        self._mapView.isHidden = false
        self._mapView.animate(to: camera)
        self._currentLocation = location
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted: fallthrough
        case .denied:
            print("[Location Authorization] Location access was restricted | User denied.")
            UtilityHelper.presentOpenSettingsAlert(self)
        case .notDetermined:
            print("[Location Authorization] Location status not determined.")
            self._locationManager.requestAlwaysAuthorization()
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("[Location Authorization] Location status is authorized.")
        }
        
        self._locationManager.startUpdatingLocation()
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self._locationManager.stopUpdatingLocation()
    }
}
