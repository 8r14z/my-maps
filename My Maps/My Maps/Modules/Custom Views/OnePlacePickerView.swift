//
//  OnePlacePickerView.swift
//  My Maps
//
//  Created by Le Vu Hoai An on 4/30/18.
//  Copyright © 2018 Le Vu Hoai An. All rights reserved.
//

import UIKit

protocol OnePlacePickerViewDelegate: AnyObject {
    func didTapPlacePicker()
    func didTapChangePickerView()
    func didTapCancelButton()
}

class OnePlacePickerView: UIView {
    
    weak var delegate: OnePlacePickerViewDelegate?
    
    var placePicker: UIButton = UIButton()
    fileprivate var _changePlacePickerViewButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "direction_icon"), for: UIControlState.normal)
        return button
    }()
    
    fileprivate var _cancelButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "cancel_icon"), for: UIControlState.normal)
        return button
    }()
    
    fileprivate var _separator: UIView = UIView()
    
    private func hideCancelButton(_ hide: Bool) {
        self._changePlacePickerViewButton.isHidden = !hide
        self._cancelButton.isHidden = hide
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Setup layout
        let height = frame.size.height
        let width = frame.size.width
        let changePlacePickerButtonDefaultSize = height/2
        
        self._changePlacePickerViewButton.frame = CGRect(
            x: width - DEFAULT_PADDING - changePlacePickerButtonDefaultSize,
            y: height/2 - changePlacePickerButtonDefaultSize/2,
            width: changePlacePickerButtonDefaultSize,
            height: changePlacePickerButtonDefaultSize
        )
        
        self._cancelButton.frame = self._changePlacePickerViewButton.frame
        hideCancelButton(true)
        
        let separatorWidth: CGFloat = 1.0
        self._separator.frame = CGRect(
            x: self._changePlacePickerViewButton.frame.origin.x - DEFAULT_PADDING - separatorWidth,
            y: height/2 - changePlacePickerButtonDefaultSize/2,
            width: separatorWidth,
            height: changePlacePickerButtonDefaultSize
        )
        self._separator.backgroundColor = UIColor.lightGray
        
        self.placePicker.frame = CGRect(
            x: DEFAULT_PADDING,
            y: 0,
            width: self._separator.frame.origin.x - DEFAULT_PADDING * 2,
            height: self.bounds.height
        )
        self.placePicker.setTitle("Search here", for: UIControlState.normal)
        self.placePicker.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        self.placePicker.contentHorizontalAlignment = .left
        self.placePicker.titleEdgeInsets.left = 10
        
        self.backgroundColor = UIColor.white
        
        addSubview(self._changePlacePickerViewButton)
        addSubview(self._cancelButton)
        addSubview(self._separator)
        addSubview(self.placePicker)
        
        // Setup components
        self.placePicker.addTarget(self, action: #selector(placePickerTapped), for: UIControlEvents.touchUpInside)
        self._changePlacePickerViewButton.addTarget(self, action: #selector(changePlacePickerViewTapped), for: UIControlEvents.touchUpInside)
        self._cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: UIControlEvents.touchUpInside)
    }
    
    @objc private func changePlacePickerViewTapped() {
        delegate?.didTapChangePickerView()
    }
    
    @objc private func placePickerTapped() {
        delegate?.didTapPlacePicker()
    }
    
    @objc private func cancelButtonTapped() {
        resetOnePlacePickerView()
        
        delegate?.didTapCancelButton()
    }
    
    func setPlacePicker(_ string: String) {
        self.placePicker.setTitle(string, for: UIControlState.normal)
        
        hideCancelButton(false)
    }
    
    func resetOnePlacePickerView() {
        hideCancelButton(true)
        self.placePicker.setTitle("Search here", for: UIControlState.normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
