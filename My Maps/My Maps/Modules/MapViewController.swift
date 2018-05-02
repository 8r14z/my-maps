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
    
    fileprivate var _mapView: GMSMapView!
    fileprivate var _placeDetailView: PlaceDetailView!
    fileprivate var _twoPlacesPickerView: TwoPlacesPickerView!
    fileprivate var _onePlacePickerView: OnePlacePickerView!
    fileprivate var _pickerViewType: PickerViewType = .onePlace

    internal var _autocompleteController: GMSAutocompleteViewController = {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.view.backgroundColor = .red
        autocompleteController.tableCellBackgroundColor = .clear
        return autocompleteController
    }()
    
    fileprivate var isSearching: Bool = false
    
    // MARK: Implementation
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setupViews() {
        super.setupViews()
        
        // Setup main view
        let placeDetailYPosition = self.view.bounds.height - DEFAULT_PLACE_DETAIL_VIEW_HEIGHT
        let placeDetailViewRect = CGRect(
            x: 0,
            y: placeDetailYPosition,
            width: self.view.bounds.width,
            height: DEFAULT_PLACE_DETAIL_VIEW_HEIGHT
        )
        self._placeDetailView = PlaceDetailView(frame: placeDetailViewRect)
        self._placeDetailView.backgroundColor = UIColor.white
        self._placeDetailView.isHidden = true
        
        self._mapView = GMSMapView(frame: self.view.bounds)
        self._mapView.settings.myLocationButton = true
        self._mapView.isMyLocationEnabled = true
        self._mapView.isHidden = true
        self._mapView.delegate = self
        self._mapView.padding.top = self.headerDirectionView.bounds.height
        
        self.contentMainView.addSubview(self._mapView)
        self.contentMainView.addSubview(self._placeDetailView)
        
        // Setup header view
        self._twoPlacesPickerView = TwoPlacesPickerView(frame: self.headerDirectionView.bounds)
        self._twoPlacesPickerView.delegate = self
        
        let onePlacePickerViewRect = CGRect(
            x: 0,
            y: 0,
            width: self.headerDirectionView.bounds.width,
            height: self.headerDirectionView.bounds.height/3
        )
        self._onePlacePickerView = OnePlacePickerView(frame: onePlacePickerViewRect)
        self._onePlacePickerView.delegate = self
        
        self.headerDirectionView.addSubview(self._twoPlacesPickerView)
        self.headerDirectionView.addSubview(self._onePlacePickerView)

        if self._pickerViewType == .onePlace {
            self._twoPlacesPickerView.isHidden = true
        }
        else {
            self._onePlacePickerView.isHidden = true
        }

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
    func hideTwoPlacesPickerView(_ hide: Bool, animated: Bool) {
        self._twoPlacesPickerView.isHidden = !self._twoPlacesPickerView.isHidden
        self._onePlacePickerView.isHidden = !self._onePlacePickerView.isHidden
        
        var originX: CGFloat = 0
        let moveDistance = self.headerDirectionView.bounds.width
        
        if hide {
            self._pickerViewType = .onePlace
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
            
            if isSearching {
                hidePlaceDetail(false, animated: true)
            }
        }
        else {
            self._pickerViewType = .twoPlace
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
            
            hidePlaceDetail(true, animated: true)
        }
    }
    
    func hidePlaceDetail(_ hide: Bool, animated: Bool) {
        
        let paddingMapView = {
            if hide {
                self._mapView.padding.bottom = 0
            } else {
                self._mapView.padding.bottom = DEFAULT_PLACE_DETAIL_VIEW_HEIGHT
            }
        }
        
        if animated {
            UIView.transition(with: headerDirectionView, duration: 0.5, options: .transitionCrossDissolve, animations: { [weak self] in
                self?._placeDetailView.isHidden = hide
            }) { (completion) in
                paddingMapView()
            }
        }
        else {
            self._placeDetailView.isHidden = hide
            paddingMapView()
        }
        
    }

}

// MARK: CoreLocationManager Delegate
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!

        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: DEFAULT_MAP_ZOOM_LEVEL)

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


// MARK: GoogleMap AutoCompleteView Delegate
extension MapViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // One place picker handle
        if self._pickerViewType == .onePlace {
            let marker = GMSMarker()
            marker.position = place.coordinate
            marker.title = place.name
            marker.map = self._mapView
            
            let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude,
                                                  longitude: place.coordinate.longitude,
                                                  zoom: DEFAULT_MAP_ZOOM_LEVEL)
            self._mapView.animate(to: camera)
            
            self.hidePlaceDetail(false, animated: true)
            
            if let address = place.formattedAddress {
                self._placeDetailView.setDetailDescription(address)
            }
            else {
                self._placeDetailView.setDetailDescription(place.name)
            }
            
            self._onePlacePickerView.setPlacePicker(place.name)
            
            self.isSearching = true
        }
        else { // Two places picker handle
            
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        UtilityHelper.presentAlert("Error", message: error.localizedDescription, vc: self)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}


