//
//  RecognitionViewController.swift
//  TextRecognaizer
//
//  Created by Andrei Konoplev on 24/09/2019.
//  Copyright © 2019 Коноплев Андрей. All rights reserved.
//

import Foundation
import UIKit

class RecognitionViewController: UIViewController {
    
    var photoView: UIImageView = UIImageView(frame: .zero)
    var textView: UILabel = UILabel(frame: .zero)
    
    let processor = ScaledElementProcessor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    convenience init(image: UIImage) {
        self.init()
        setupLayout()
        photoView.image = image
        recognaize()
    }
    
    fileprivate func setupLayout() {
        view.backgroundColor = UIColor.white
        photoView.contentMode = .scaleAspectFit
        view.addSubview(photoView)
        photoView.translatesAutoresizingMaskIntoConstraints = false
        photoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 15).isActive = true
        photoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10).isActive = true
        photoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -10).isActive = true
        photoView.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    fileprivate func recognaize() {
        processor.process(in: self.photoView) { (text) in
            print("siu \(text)")
        }
    }
}
