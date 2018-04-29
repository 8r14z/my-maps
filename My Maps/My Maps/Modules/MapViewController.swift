//
//  MainMapsViewController.swift
//  My Maps
//
//  Created by Le Vu Hoai An on 4/27/18.
//  Copyright © 2018 Le Vu Hoai An. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

class MapViewController: BaseMapViewController {
    
    fileprivate var _locationManager = CLLocationManager()
    fileprivate var _currentLocation: CLLocation?
    fileprivate let DEFAULT_ZOOM_LEVEL: Float = 15.0
    
    fileprivate var _mapView: GMSMapView!
    fileprivate var _placeDetailView: PlaceDetailView!
    fileprivate var _placePickerView: TwoPlacesPickerView!
    
    internal var _autocompleteController: GMSAutocompleteViewController = {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.view.backgroundColor = .red
        autocompleteController.tableCellBackgroundColor = .clear
        return autocompleteController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setupViews() {
        super.setupViews()
        
        let placeDetailYPosition = self.view.bounds.height - DEFAULT_PLACE_DETAIL_VIEW_HEIGHT
        self._placeDetailView = PlaceDetailView(frame: CGRect(x: 0,
                                                              y: placeDetailYPosition,
                                                              width: self.view.bounds.width,
                                                              height: DEFAULT_PLACE_DETAIL_VIEW_HEIGHT))
        self._placeDetailView.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        self._placeDetailView.isHidden = true
        
        self._mapView = GMSMapView(frame: self.view.bounds)
        self._mapView.settings.myLocationButton = true
        self._mapView.isMyLocationEnabled = true
        self._mapView.isHidden = true
        self._mapView.delegate = self
        self._mapView.padding.top = self.headerDirectionView.bounds.height
        
        self.contentMainView.addSubview(self._mapView)
        self.contentMainView.addSubview(self._placeDetailView)
        
        self._placePickerView = TwoPlacesPickerView(frame: self.headerDirectionView.bounds)
        self._placePickerView.delegate = self
        self.headerDirectionView.backgroundColor = UIColor.clear
        self.headerDirectionView.addSubview(self._placePickerView)
    }
    
    private func hidePlaceDetail(_ hide: Bool, animated: Bool) {
        if animated {
            UIView.transition(with: headerDirectionView, duration: 0.5, options: .transitionCrossDissolve, animations: { [weak self] in
                self?._placeDetailView.isHidden = hide
                if hide {
                    self?._mapView.padding.bottom = 0
                } else {
                    self?._mapView.padding.bottom = DEFAULT_PLACE_DETAIL_VIEW_HEIGHT
                }
            })
        }
        else {
            self._placeDetailView.isHidden = hide
            if hide {
                self._mapView.padding.bottom = 0
            } else {
                self._mapView.padding.bottom = DEFAULT_PLACE_DETAIL_VIEW_HEIGHT
            }
        }
    }
    
    override func setupComponents() {
        super.setupComponents()
        
        self._locationManager = CLLocationManager()
        self._locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self._locationManager.requestAlwaysAuthorization()
        self._locationManager.distanceFilter = 50
        self._locationManager.startUpdatingLocation()
        self._locationManager.delegate = self
        
        self._autocompleteController.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: CoreLocationManager Delegate
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!

        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: DEFAULT_ZOOM_LEVEL)

        self._mapView.isHidden = false
        self._mapView.animate(to: camera)
        self._currentLocation = location
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self._locationManager.stopUpdatingLocation()
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
            self._locationManager.startUpdatingLocation()
        }
    }
    
}

// MARK: GoogleMapView Delegate
extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String, name: String, location: CLLocationCoordinate2D) {
        let infoMarker = GMSMarker()
        infoMarker.snippet = "(\(location.latitude), \(location.longitude))"
        infoMarker.position = location
        infoMarker.title = name
        infoMarker.opacity = 0;
        infoMarker.infoWindowAnchor.y = 1
        infoMarker.map = mapView
        mapView.selectedMarker = infoMarker
    }
}


