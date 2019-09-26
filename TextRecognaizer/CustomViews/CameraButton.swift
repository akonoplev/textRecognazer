//
//  CameraButton.swift
//  TextRecognaizer
//
//  Created by Andrei Konoplev on 23/09/2019.
//  Copyright © 2019 Коноплев Андрей. All rights reserved.
//
import Foundation
import UIKit

class CameraButton: UIButton {
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        setup()
    }
    
    fileprivate func setup() {
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.backgroundColor = UIColor.white.cgColor
    }
}
