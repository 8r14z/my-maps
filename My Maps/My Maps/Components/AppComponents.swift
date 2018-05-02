//
//  AppComponent.swift
//  My Maps
//
//  Created by Le Vu Hoai An on 4/27/18.
//  Copyright © 2018 Le Vu Hoai An. All rights reserved.
//

import Foundation
import GoogleMaps
import GooglePlaces

enum PickerViewType {
    case onePlace
    case twoPlace
}

class AppComponents {
    static let sharedInstanced = AppComponents()
    
    private init() {}
    
    func setupGoogleSDK() {
        setupGoogleMapsSDK()
        setupGooglePlacesSDK()
    }
    
    private func setupGoogleMapsSDK() {
        GMSServices.provideAPIKey(kGoogleSDKAPIKey)
    }
    
    private func setupGooglePlacesSDK() {
        GMSPlacesClient.provideAPIKey(kGoogleSDKAPIKey)
    }
    
}
