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
    
    // MARK: Properties
    fileprivate var _locationManager = CLLocationManager()
    fileprivate var _currentLocation: CLLocation?
    fileprivate let DEFAULT_ZOOM_LEVEL: Float = 15.0
    
    fileprivate var _mapView: GMSMapView!
    fileprivate var _placeDetailView: PlaceDetailView!
    fileprivate var _twoPlacesPickerView: TwoPlacesPickerView!
    fileprivate var _onePlacePickerView: OnePlacePickerView!
    
    internal var _autocompleteController: GMSAutocompleteViewController = {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.view.backgroundColor = .red
        autocompleteController.tableCellBackgroundColor = .clear
        return autocompleteController
    }()
    
    // MARK: Implementation
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
        
        self._twoPlacesPickerView = TwoPlacesPickerView(frame: self.headerDirectionView.bounds)
        self._twoPlacesPickerView.delegate = self
        
        self._onePlacePickerView = OnePlacePickerView(frame: self.headerDirectionView.bounds)
        self._onePlacePickerView.backgroundColor = UIColor.white
        self._onePlacePickerView.delegate = self
        
        self.headerDirectionView.addSubview(self._twoPlacesPickerView)
        self.headerDirectionView.addSubview(self._onePlacePickerView)

        self.headerDirectionView.backgroundColor = UIColor.clear
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
    
    // MARK: Animate show/hide UI elements
    internal func hideTwoPlacesPickerView(_ hide: Bool, animated: Bool) {
        var originX: CGFloat = 0
        let moveDistance = self.headerDirectionView.bounds.width
        
        if hide {
            originX = self._twoPlacesPickerView.frame.origin.x
            if animated {
                self._onePlacePickerView.frame.origin.x -= moveDistance
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?._onePlacePickerView.frame.origin.x = originX
                    self?._twoPlacesPickerView.frame.origin.x += moveDistance
                }
            }
            else {
                self._onePlacePickerView.frame.origin.x -= originX
                self._twoPlacesPickerView.frame.origin.x += moveDistance
            }
        }
        else {
            originX = self._onePlacePickerView.frame.origin.x
            if animated {
                self._twoPlacesPickerView.frame.origin.x += moveDistance
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?._onePlacePickerView.frame.origin.x -= moveDistance
                    self?._twoPlacesPickerView.frame.origin.x = originX
                }
            }
            else {
                self._onePlacePickerView.frame.origin.x -= moveDistance
                self._twoPlacesPickerView.frame.origin.x = originX
            }
        }
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


