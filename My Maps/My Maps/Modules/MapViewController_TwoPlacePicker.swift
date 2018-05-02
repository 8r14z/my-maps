//
//  PlacePickerViewController.swift
//  My Maps
//
//  Created by Le Vu Hoai An on 4/29/18.
//  Copyright © 2018 Le Vu Hoai An. All rights reserved.
//

import UIKit

// MARK: TwoPlacesPickerView Delegate
extension MapViewController: TwoPlacesPickerViewDelegate {
    func didTapFirstPlacePicker() {
        present(self._autocompleteController, animated: true, completion: nil)
    }
    
    func didTapSecondPlacePicker() {
        present(self._autocompleteController, animated: true, completion: nil)
    }
    
    func didTapBackButton() {
        hideTwoPlacesPickerView(true, animated: true)
    }
}
