//
//  PlaceDetailView.swift
//  My Maps
//
//  Created by Le Vu Hoai An on 4/28/18.
//  Copyright © 2018 Le Vu Hoai An. All rights reserved.
//

import UIKit

protocol PlaceDetailViewDelegate: AnyObject {
    func didTapDirectionButton()
}

class PlaceDetailView: UIView {

    weak var delegate: PlaceDetailViewDelegate?
    
    private var _detailDescriptionLabel =  UILabel()
    private var _directionButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self._detailDescriptionLabel.frame = CGRect(x: DEFAULT_PADDING, y: 0, width: bounds.width - DEFAULT_PADDING * 2, height: bounds.height/2)
        self._detailDescriptionLabel.adjustsFontForContentSizeCategory = true
        self._detailDescriptionLabel.lineBreakMode = NSLineBreakMode.byTruncatingTail
        self._detailDescriptionLabel.textAlignment = NSTextAlignment.center
        self._detailDescriptionLabel.text = "Default text daskdhasudhashjkkasdkasjdjsakkdhda sdsadas sad as"
        
        self._directionButton.frame = CGRect(x: 0, y: bounds.height/2, width: bounds.width, height: bounds.height/2)
        self._directionButton.setTitle("Direction", for: UIControlState.normal)
        self._directionButton.addTarget(self, action: #selector(tapDirection), for: UIControlEvents.touchUpInside)
        
        addSubview(self._detailDescriptionLabel)
        addSubview(self._directionButton)
    }
    
    func setDetailDescription(_ string: String) {
        self._detailDescriptionLabel.text = string
    }
    
    func setButtonTitle(_ string: String) {
        self._directionButton.setTitle(string, for: UIControlState.normal)
    }
    
    @objc func tapDirection() {
        delegate?.didTapDirectionButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
