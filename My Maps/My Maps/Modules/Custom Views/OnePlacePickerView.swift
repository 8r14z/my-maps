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
}

class OnePlacePickerView: UIView {
    
    weak var delegate: OnePlacePickerViewDelegate?
    
    var placePicker: UIButton = UIButton()
    fileprivate var _changePlacePickerViewButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "direction_icon"), for: UIControlState.normal)
        return button
    }()
    fileprivate var _separator: UIView = UIView()

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
        addSubview(self._separator)
        addSubview(self.placePicker)
        
        // Setup components
        self.placePicker.addTarget(self, action: #selector(placePickerTapped), for: UIControlEvents.touchUpInside)
        self._changePlacePickerViewButton.addTarget(self, action: #selector(changePlacePickerViewTapped), for: UIControlEvents.touchUpInside)
    }
    
    @objc private func changePlacePickerViewTapped() {
        delegate?.didTapChangePickerView()
    }
    
    @objc private func placePickerTapped() {
        delegate?.didTapPlacePicker()
    }
    
    func setPlacePicker(_ string: String) {
        self.placePicker.setTitle(string, for: UIControlState.normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
