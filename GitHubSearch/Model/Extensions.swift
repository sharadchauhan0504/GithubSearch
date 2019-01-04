//
//  Extensions.swift
//  GitHubSearch
//
//  Created by Sharad S. Chauhan on 03/01/19.
//  Copyright © 2019 Sharad S. Chauhan. All rights reserved.
//

import UIKit

extension UIView {
    func animateViewWith(duration: Double) {
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.2, options: .curveEaseIn, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    func addCornerRadius(radius: CGFloat) {
        self.layer.cornerRadius  = radius
        self.layer.masksToBounds = true
    }
    
    func addShadow() {
        self.layer.masksToBounds      = false
        self.layer.shadowColor        = UIColor.black.cgColor
        self.layer.shadowOpacity      = 0.5
        self.layer.shadowOffset       = CGSize(width: 1, height: 1)
        self.layer.shadowRadius       = 5.0
        self.layer.shadowPath         = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize    = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
}
