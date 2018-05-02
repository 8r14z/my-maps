//
//  BaseDirectionViewController.swift
//  My Maps
//
//  Created by Le Vu Hoai An on 4/28/18.
//  Copyright © 2018 Le Vu Hoai An. All rights reserved.
//

import UIKit

class BaseMapViewController: UIViewController {
    
    var contentMainView = UIView()
    var headerDirectionView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews()
        setupComponents()
    }
    
    func setupViews() {
        contentMainView.backgroundColor = UIColor.white
        contentMainView.frame = view.bounds
        
        self.headerDirectionView.frame = CGRect(x: DEFAULT_PADDING, y: DEFAULT_PADDING, width: self.view.bounds.width - (DEFAULT_PADDING * 2) , height: self.view.bounds.height/5 - DEFAULT_PADDING)
        
        self.headerDirectionView.backgroundColor = UIColor.white
        self.headerDirectionView.clipsToBounds = true
        
        self.view.addSubview(contentMainView)
        self.view.addSubview(headerDirectionView)
    }
    
    func setupComponents() {
        
    }
    
    func hideHeaderDirectionView(_ hide: Bool, animated: Bool = false) {
        if animated {
            UIView.transition(with: headerDirectionView, duration: 0.5, options: .transitionCrossDissolve, animations: { [weak self] in
                self?.headerDirectionView.isHidden = hide
            })
        } else {
            self.headerDirectionView.isHidden = hide
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
