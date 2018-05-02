//
//  MapViewController_OnePlacePicker.swift
//  My Maps
//
//  Created by Le Vu Hoai An on 4/30/18.
//  Copyright © 2018 Le Vu Hoai An. All rights reserved.
//

import Foundation

extension MapViewController: OnePlacePickerViewDelegate {
    func didTapPlacePicker() {
        present(self._autocompleteController, animated: true, completion: nil)
    }
    
    func didTapChangePickerView() {
        hideTwoPlacesPickerView(false, animated: true)
    }
    
}
