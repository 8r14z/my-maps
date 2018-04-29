//
//  OnePlacePickerView.swift
//  My Maps
//
//  Created by Le Vu Hoai An on 4/30/18.
//  Copyright © 2018 Le Vu Hoai An. All rights reserved.
//

import UIKit

protocol OnePlacePickerViewDelegate: AnyObject {
    func didTapChangePickerView()
}

class OnePlacePickerView: UIView {
    
    weak var delegate: OnePlacePickerViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didNavigate))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didNavigate() {
        delegate?.didTapChangePickerView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
