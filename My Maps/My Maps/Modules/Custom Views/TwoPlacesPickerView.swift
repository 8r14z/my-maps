//
//  PlacesPickerView.swift
//  My Maps
//
//  Created by Le Vu Hoai An on 4/29/18.
//  Copyright © 2018 Le Vu Hoai An. All rights reserved.
//

import UIKit

protocol TwoPlacesPickerViewDelegate: AnyObject {
    func didTapFirstPlaceChooser()
    func didTapSecondPlaceChooser()
    func didTapBackButton()
}

class TwoPlacesPickerView: UIView {
    
    var firstPlaceChooser: UIButton = UIButton()
    var secondPlaceChooser: UIButton = UIButton()
    
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
        
        self._backButton.frame = CGRect(x: DEFAULT_PADDING,
                                        y: height/2 - backButtonDefaultSize/2,
                                        width: backButtonDefaultSize,
                                        height: backButtonDefaultSize)
        
        let placeChooserXPosition = self._backButton.bounds.size.width + DEFAULT_PADDING*2
        let placeChooserHeight = height/4
        let placeChooserWidth = width - placeChooserXPosition - DEFAULT_PADDING*2
        let placeChooserVericalPadding = placeChooserHeight*2/3
        
        self.firstPlaceChooser.frame = CGRect(x: placeChooserXPosition,
                                              y: placeChooserVericalPadding,
                                              width: placeChooserWidth,
                                              height: placeChooserHeight)
        self.firstPlaceChooser.backgroundColor = UIColor.white
        
        self.secondPlaceChooser.frame = CGRect(x: placeChooserXPosition,
                                               y: firstPlaceChooser.bounds.height + placeChooserVericalPadding*2,
                                               width: placeChooserWidth,
                                               height: placeChooserHeight)
        self.secondPlaceChooser.backgroundColor = UIColor.white

        addSubview(self._backButton)
        addSubview(self.firstPlaceChooser)
        addSubview(self.secondPlaceChooser)
        
        self.backgroundColor = DEFAULT_PLACE_PICKER_VIEW_BACKGROUND_COLOR
        
        // Setup components
        self.firstPlaceChooser.addTarget(self, action: #selector(firstPlaceChooserTapped), for: UIControlEvents.touchUpInside)
        self.secondPlaceChooser.addTarget(self, action: #selector(secondPlaceChooserTapped), for: UIControlEvents.touchUpInside)
        self._backButton.addTarget(self, action: #selector(backButtonTapped), for: UIControlEvents.touchUpInside)
    }
    
    @objc private func firstPlaceChooserTapped() {
        delegate?.didTapFirstPlaceChooser()
    }
    
    @objc private func secondPlaceChooserTapped() {
        delegate?.didTapSecondPlaceChooser()
    }
    
    @objc private func backButtonTapped() {
        delegate?.didTapBackButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
