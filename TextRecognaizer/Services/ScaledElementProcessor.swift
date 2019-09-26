//
//  ScaledElementProcessor.swift
//  TextRecognaizer
//
//  Created by Andrei Konoplev on 25/09/2019.
//  Copyright © 2019 Коноплев Андрей. All rights reserved.
//

import Foundation
import Firebase

class ScaledElementProcessor {
    let vision = Vision.vision()
    var textRecognizer: VisionTextRecognizer!
    
    init() {
        textRecognizer = vision.onDeviceTextRecognizer()
    }
    
    func process(in imageView: UIImageView, completion: @escaping (_ text: String)-> Void) {
        guard let image = imageView.image else { return }
        
        let visionImage = VisionImage(image: image)
        
        textRecognizer.process(visionImage) { result, error in
            guard error == nil, let result = result, !result.text.isEmpty else {
                completion("")
                return
            }
            
            completion(result.text)
        }
    }
}
