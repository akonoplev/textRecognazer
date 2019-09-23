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
        self.navigationController?.pushViewController(vc, animated: true)
        //setupCamera()
    }
    
//    fileprivate func setupCamera() {
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            let imagePicker = UIImagePickerController()
//            imagePicker.delegate = self
//            imagePicker.sourceType = .camera
//            imagePicker.allowsEditing = false
//            self.present(imagePicker, animated: true, completion:  nil)
//        }
//    }
}

//extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        picker.dismiss(animated: true, completion: nil)
//        
//        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
//    }
//}


