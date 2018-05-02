//
//  PlacesPickerView.swift
//  My Maps
//
//  Created by Le Vu Hoai An on 4/29/18.
//  Copyright © 2018 Le Vu Hoai An. All rights reserved.
//

import UIKit

protocol TwoPlacesPickerViewDelegate: AnyObject {
    func didTapFirstPlacePicker()
    func didTapSecondPlacePicker()
    func didTapBackButton()
}

class TwoPlacesPickerView: UIView {
    
    var firstPlacePicker: UIButton = UIButton()
    var secondPlacePicker: UIButton = UIButton()
    
    weak var delegate: TwoPlacesPickerViewDelegate?
    
    fileprivate var _backButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "back_icon"), for: UIControlState.normal)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Setup layout
        let height = frame.size.height
        let width = frame.size.width
        let backButtonDefaultSize = height/6
        
        self._backButton.frame = CGRect(
            x: DEFAULT_PADDING,
            y: height/2 - backButtonDefaultSize/2,
            width: backButtonDefaultSize,
            height: backButtonDefaultSize
        )
        
        let placeChooserXPosition = self._backButton.bounds.size.width + DEFAULT_PADDING*2
        let placeChooserHeight = height/4
        let placeChooserWidth = width - placeChooserXPosition - DEFAULT_PADDING*2
        let placeChooserVericalPadding = placeChooserHeight*2/3
        
        self.firstPlacePicker.frame = CGRect(
            x: placeChooserXPosition,
            y: placeChooserVericalPadding,
            width: placeChooserWidth,
            height: placeChooserHeight
        )
        self.firstPlacePicker.backgroundColor = UIColor.white
        self.firstPlacePicker.setTitle("Choose starting point...", for: UIControlState.normal)
        self.firstPlacePicker.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        self.firstPlacePicker.contentHorizontalAlignment = .left
        self.firstPlacePicker.titleEdgeInsets.left = 10
        self.firstPlacePicker.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        self.secondPlacePicker.frame = CGRect(
            x: placeChooserXPosition,
            y: firstPlacePicker.bounds.height + placeChooserVericalPadding*2,
            width: placeChooserWidth,
            height: placeChooserHeight
        )
        self.secondPlacePicker.backgroundColor = UIColor.white
        self.secondPlacePicker.setTitle("Choose destination...", for: UIControlState.normal)
        self.secondPlacePicker.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        self.secondPlacePicker.contentHorizontalAlignment = .left
        self.secondPlacePicker.titleEdgeInsets.left = 10
        self.secondPlacePicker.titleLabel?.font = UIFont.systemFont(ofSize: 15)

        addSubview(self._backButton)
        addSubview(self.firstPlacePicker)
        addSubview(self.secondPlacePicker)
        
        self.backgroundColor = DEFAULT_PLACE_PICKER_VIEW_BACKGROUND_COLOR
        
        // Setup components
        self.firstPlacePicker.addTarget(self, action: #selector(firstPlacePickerTapped), for: UIControlEvents.touchUpInside)
        self.secondPlacePicker.addTarget(self, action: #selector(secondPlacePickerTapped), for: UIControlEvents.touchUpInside)
        self._backButton.addTarget(self, action: #selector(backButtonTapped), for: UIControlEvents.touchUpInside)
    }
    
    @objc private func firstPlacePickerTapped() {
        delegate?.didTapFirstPlacePicker()
    }
    
    @objc private func secondPlacePickerTapped() {
        delegate?.didTapSecondPlacePicker()
    }
    
    @objc private func backButtonTapped() {
        delegate?.didTapBackButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
