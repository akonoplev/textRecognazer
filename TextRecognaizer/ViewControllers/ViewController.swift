//
//  ViewController.swift
//  TextRecognaizer
//
//  Created by Andrei Konoplev on 16/09/2019.
//  Copyright © 2019 Коноплев Андрей. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func openCamera(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "cameraViewController") as! CameraViewController
        vc.view.frame = view.bounds
        vc.view.backgroundColor = UIColor.white
        vc.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
}



