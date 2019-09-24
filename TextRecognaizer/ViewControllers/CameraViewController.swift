//
//  CameraViewController.swift
//  TextRecognaizer
//
//  Created by Andrei Konoplev on 16/09/2019.
//  Copyright © 2019 Коноплев Андрей. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {

    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var backCamera: AVCaptureDevice?
    
    fileprivate var sessionQueue = DispatchQueue(label: "akonoplevQueue")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.all)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupSession()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.captureSession.stopRunning()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
        }
    }
    
    fileprivate func setupSession() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .hd1280x720
        
        backCamera = AVCaptureDevice.default(for: AVMediaType.video)
        
        guard let backCamera = backCamera else {
            print("Unable to access back camera")
            return
        }
        
        guard let input = try? AVCaptureDeviceInput(device: backCamera) else { return }
        stillImageOutput = AVCapturePhotoOutput()
        
        if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
            captureSession.addInput(input)
            captureSession.addOutput(stillImageOutput)
            setupLivePreview()
        }
        
        try? backCamera.lockForConfiguration()
        self.defaultFocus(device: backCamera)
        backCamera.unlockForConfiguration()
        
        
        //чтобы не заблокировать пользовательский интерфейс нельзя запускать на главном потоке
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.cameraView.bounds
            }
        }
    }
    
    fileprivate func setupLivePreview() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        cameraView.layer.addSublayer(videoPreviewLayer)
    }
    
    fileprivate func cropImage(image: UIImage) {
        let controller = CropViewController()
        controller.delegate = self
        controller.image = image
        controller.modalPresentationStyle = .overCurrentContext
        self.present(controller, animated: true, completion: nil)
    }
}

//adding to image
extension CameraViewController: AVCapturePhotoCaptureDelegate {
    //захватим камеру
    @IBAction func didTakePhoto(_ sender: Any) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else
        { return }
        
        guard let image = UIImage(data: imageData) else { return  }
        cropImage(image: image)
    }
}

//MARK: Crop delegate
extension CameraViewController: CropViewControllerDelegate {
    func cropViewController(_ controller: CropViewController, didFinishCroppingImage image: UIImage) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func cropViewController(_ controller: CropViewController, didFinishCroppingImage image: UIImage, transform: CGAffineTransform, cropRect: CGRect) {
        
    }
    
    func cropViewControllerDidCancel(_ controller: CropViewController) {
        
    }
    
    
}

//MARK: - Other
extension CameraViewController {
    @IBAction func cameraDidTap(_ sender: Any) {
        if videoPreviewLayer != nil {
            if let tapRec = sender as? UITapGestureRecognizer {
                let touchPoint = tapRec.location(in: view)
                let focusPoint = videoPreviewLayer.captureDevicePointConverted(fromLayerPoint: touchPoint)
                continuousFocus(at: focusPoint)
            }
        }
    }
    
    
    fileprivate func defaultFocus(device: AVCaptureDevice?) {
        if let camera = device {
            if camera.isFocusModeSupported(.autoFocus) {
                if camera.isFocusPointOfInterestSupported {
                    camera.focusPointOfInterest = CGPoint(x: 0.5, y: 0.5)
                }
                camera.focusMode = .continuousAutoFocus
            }
        }
    }
    
    func continuousFocus(at focusPoint: CGPoint) {
        sessionQueue.async {
               if let camera = self.backCamera {
                   do {
                       try camera.lockForConfiguration()
                       if camera.isFocusPointOfInterestSupported {
                           //Logger.log("focus point (x,y): \(focusPoint.x) \(focusPoint.y)")
                           camera.focusPointOfInterest = focusPoint
                       }
                    if camera.isFocusModeSupported(.continuousAutoFocus) {
                        //Logger.log(".continuousAutoFocus")
                        camera.focusMode = .autoFocus
                    }
                       camera.unlockForConfiguration()
                   } catch {
                       print("can't lock video device for configuration: \(error)")
                   }
               }
           }
       }
       
       func autoFocus(at focusPoint: CGPoint) {
           sessionQueue.async {
               if let camera = self.backCamera {
                   do {
                       try camera.lockForConfiguration()
                       if camera.isFocusModeSupported(.autoFocus) {
                           camera.focusMode = .autoFocus
                       }
                       if camera.isFocusPointOfInterestSupported {
                           camera.focusPointOfInterest = focusPoint
                       }
                       camera.unlockForConfiguration()
                   } catch {
                       print("can't lock video device for configuration: \(error)")
                   }
               }
           }
       }
}
