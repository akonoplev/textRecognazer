//
//  CropViewController.swift
//  CropViewController
//
//  Created by Guilherme Moura on 2/25/16.
//  Copyright © 2016 Reefactor, Inc. All rights reserved.
//

import UIKit

public protocol CropViewControllerDelegate: class {
    func cropViewController(_ controller: CropViewController, didFinishCroppingImage image: UIImage)
    func cropViewController(_ controller: CropViewController, didFinishCroppingImage image: UIImage, transform: CGAffineTransform, cropRect: CGRect)
    func cropViewControllerDidCancel(_ controller: CropViewController)
}

open class CropViewController: UIViewController {
    open weak var delegate: CropViewControllerDelegate?
    open var image: UIImage? {
        didSet {
            cropView?.image = image
        }
    }
    open var keepAspectRatio = false {
        didSet {
            cropView?.keepAspectRatio = keepAspectRatio
        }
    }
    open var cropAspectRatio: CGFloat = 0.0 {
        didSet {
            cropView?.cropAspectRatio = cropAspectRatio
        }
    }
    open var cropRect = CGRect.zero {
        didSet {
            adjustCropRect()
        }
    }
    open var imageCropRect = CGRect.zero {
        didSet {
            cropView?.imageCropRect = imageCropRect
        }
    }
    open var toolbarHidden = false
    open var rotationEnabled = false {
        didSet {
            cropView?.rotationGestureRecognizer.isEnabled = rotationEnabled
        }
    }
    open var rotationTransform: CGAffineTransform {
        return cropView!.rotation
    }
    open var zoomedCropRect: CGRect {
        return cropView!.zoomedCropRect()
    }

    fileprivate var cropView: CropView?
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initialize()
    }
    
    fileprivate func initialize() {
        rotationEnabled = true
    }
    
    open override func loadView() {
        let contentView = UIView()
        contentView.autoresizingMask = .flexibleWidth
        contentView.backgroundColor = UIColor.black
        view = contentView
        
        // Add CropView
        cropView = CropView(frame: CGRect(x: contentView.frame.origin.x, y: contentView.frame.origin.y, width: contentView.frame.width, height: contentView.frame.height - 30))
        contentView.addSubview(cropView!)
        
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        congigureBottomBar()
        cropView?.image = image
        cropView?.rotationGestureRecognizer.isEnabled = rotationEnabled
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if cropAspectRatio != 0 {
            cropView?.cropAspectRatio = cropAspectRatio
        }
        
        if !cropRect.equalTo(CGRect.zero) {
            adjustCropRect()
        }
        
        if !imageCropRect.equalTo(CGRect.zero) {
            cropView?.imageCropRect = imageCropRect
        }
        
        cropView?.keepAspectRatio = keepAspectRatio
    }
    
    open func resetCropRect() {
        cropView?.resetCropRect()
    }
    
    open func resetCropRectAnimated(_ animated: Bool) {
        cropView?.resetCropRectAnimated(animated)
    }
    
    @objc func cancel(_ sender: UIBarButtonItem) {
        delegate?.cropViewControllerDidCancel(self)
    }
    
    @objc func done(_ sender: UIBarButtonItem) {
        if let image = cropView?.croppedImage {
            delegate?.cropViewController(self, didFinishCroppingImage: image)
            guard let rotation = cropView?.rotation else {
                return
            }
            guard let rect = cropView?.zoomedCropRect() else {
                return
            }
            delegate?.cropViewController(self, didFinishCroppingImage: image, transform: rotation, cropRect: rect)
        }
    }

    // MARK: - Private methods
    fileprivate func adjustCropRect() {
        imageCropRect = CGRect.zero
        
        guard var cropViewCropRect = cropView?.cropRect else {
            return
        }
        cropViewCropRect.origin.x += cropRect.origin.x
        cropViewCropRect.origin.y += cropRect.origin.y
        
        let minWidth = min(cropViewCropRect.maxX - cropViewCropRect.minX, cropRect.width)
        let minHeight = min(cropViewCropRect.maxY - cropViewCropRect.minY, cropRect.height)
        let size = CGSize(width: minWidth, height: minHeight)
        cropViewCropRect.size = size
        cropView?.cropRect = cropViewCropRect
    }
}

extension CropViewController {
    func congigureBottomBar() {
        let view = UIView(frame: CGRect(x: 5, y: UIScreen.main.bounds.height - 45, width: UIScreen.main.bounds.width, height: 45))
        view.backgroundColor = UIColor.black
        
        //doneButton
        let doneButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 105, y: 0, width: 100, height: 45))
        doneButton.setTitle("Сохранить", for: .normal)
        doneButton.titleLabel?.textColor = UIColor.white
        doneButton.backgroundColor = UIColor.clear
        doneButton.addTarget(self, action: #selector(CropViewController.done(_:)), for: .touchUpInside)
        view.addSubview(doneButton)
        self.view.addSubview(view)
        
        //cancel button
        let cancelButton = UIButton(frame: CGRect(x: 5, y: 0, width: 100, height: 45))
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.titleLabel?.textColor = UIColor.yellow
        cancelButton.backgroundColor = UIColor.clear
        cancelButton.addTarget(self, action: #selector(CropViewController.cancel(_:)), for: .touchUpInside)
        view.addSubview(cancelButton)
    }
}
