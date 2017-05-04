//
//  CustomCameraView.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 3/29/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMotion
protocol CustomCameraViewDelegate {
    func cameraShotFinished(image:UIImage)
}
class CustomCameraView: UIView,UIGestureRecognizerDelegate {
    var previewViewContainer: UIView!
    var shotButton: UIButton!
   // var flashButton: UIButton!
    var flipButton: UIButton!
    var fullAspectRatioConstraint: NSLayoutConstraint!
    var croppedAspectRatioConstraint: NSLayoutConstraint?
    
    var delegate:CustomCameraViewDelegate?
    
    let screenSize: CGRect = UIScreen.main.bounds
    let valuePro:CGFloat  = CGFloat(NSNumber.getPropotionalValueDevice())
    
    var session: AVCaptureSession?
    var device: AVCaptureDevice?
    var videoInput: AVCaptureDeviceInput?
    var imageOutput: AVCaptureStillImageOutput?
    var focusView: UIView?
    
    var flashOffImage: UIImage?
    var flashOnImage: UIImage?
    
    var motionManager: CMMotionManager?
    var currentDeviceOrientation: UIDeviceOrientation?

    func createComponents(){
        self.frame = CGRect(x: (screenSize.width-320*valuePro)/2, y: 58*valuePro, width: 320*valuePro, height: 320*valuePro)
        previewViewContainer = UIView()
        previewViewContainer.frame = CGRect(x: 0, y: 0, width: 320*valuePro, height: 320*valuePro)
        addSubview(previewViewContainer)

    }
    func drawBody() {
        
        if session != nil {
            
            return
        }

        self.isHidden = false
        
        // AVCapture
        session = AVCaptureSession()
        
        for device in AVCaptureDevice.devices() {
            
            if let device = device as? AVCaptureDevice , device.position == AVCaptureDevicePosition.back {
                
                self.device = device
                
                if !device.hasFlash {
                    
                //    flashButton.isHidden = true
                }
            }
        }
        
        do {
            
            if let session = session {
                
                videoInput = try AVCaptureDeviceInput(device: device)
                
                session.addInput(videoInput)
                
                imageOutput = AVCaptureStillImageOutput()
                
                session.addOutput(imageOutput)
                
                let videoLayer = AVCaptureVideoPreviewLayer(session: session)
                videoLayer?.frame = self.previewViewContainer.bounds
                videoLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
                
                self.previewViewContainer.layer.addSublayer(videoLayer!)
                
                session.sessionPreset = AVCaptureSessionPresetPhoto
                
                session.startRunning()
                
            }
            
            // Focus View
            self.focusView         = UIView(frame: CGRect(x: 0, y: 0, width: 90, height: 90))

            
        } catch {
            
        }
       // self.flashConfiguration()
        
        self.startCamera()
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForegroundNotification(_:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    func flashConfiguration() {
        
        do {
            
            if let device = device {
                
                try device.lockForConfiguration()
                
                device.flashMode = AVCaptureFlashMode.off
            //    flashButton.setImage(flashOffImage, for: UIControlState())
                
                device.unlockForConfiguration()
                
            }
            
        } catch _ {
            
            return
        }
    }
    func willEnterForegroundNotification(_ notification: Notification) {
        
        startCamera()
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func startCamera() {
        
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        if status == AVAuthorizationStatus.authorized {
            
            session?.startRunning()
            
            motionManager = CMMotionManager()
            motionManager!.accelerometerUpdateInterval = 0.2
            motionManager!.startAccelerometerUpdates(to: OperationQueue()) { [unowned self] (data, _) in
                if let data = data {
                    if abs( data.acceleration.y ) < abs( data.acceleration.x ) {
                        if data.acceleration.x > 0 {
                            self.currentDeviceOrientation = .landscapeRight
                        } else {
                            self.currentDeviceOrientation = .landscapeLeft
                        }
                    } else {
                        if data.acceleration.y > 0 {
                            self.currentDeviceOrientation = .portraitUpsideDown
                        } else {
                            self.currentDeviceOrientation = .portrait
                        }
                    }
                }
            }
            
        } else if status == AVAuthorizationStatus.denied || status == AVAuthorizationStatus.restricted {
            
            stopCamera()
        }
    }
    
    func stopCamera() {
        session?.stopRunning()
        motionManager?.stopAccelerometerUpdates()
        currentDeviceOrientation = nil
    }
    // MARK - Actions
    func shotButtonPressed(sender: UIButton) {
        
        guard let imageOutput = imageOutput else {
            
            return
        }
        
        DispatchQueue.global(qos: .default).async(execute: { () -> Void in
            
            let videoConnection = imageOutput.connection(withMediaType: AVMediaTypeVideo)
            
            let orientation: UIDeviceOrientation = self.currentDeviceOrientation ?? UIDevice.current.orientation
            switch (orientation) {
            case .portrait:
                videoConnection?.videoOrientation = .portrait
            case .portraitUpsideDown:
                videoConnection?.videoOrientation = .portraitUpsideDown
            case .landscapeRight:
                videoConnection?.videoOrientation = .landscapeLeft
            case .landscapeLeft:
                videoConnection?.videoOrientation = .landscapeRight
            default:
                videoConnection?.videoOrientation = .portrait
            }
            
            imageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (buffer, error) -> Void in
                
              //  self.stopCamera()
                
                let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)
                
                if let image = UIImage(data: data!), let delegate = self.delegate {
                    
                    // Image size
                    var iw: CGFloat
                    var ih: CGFloat
                    
                    switch (orientation) {
                    case .landscapeLeft, .landscapeRight:
                        // Swap width and height if orientation is landscape
                        iw = image.size.height
                        ih = image.size.width
                    default:
                        iw = image.size.width
                        ih = image.size.height
                    }
                    
                    // Frame size
                    let sw = self.previewViewContainer.frame.width
                    
                    // The center coordinate along Y axis
                    let rcy = ih * 0.5
                    
                    let imageRef = image.cgImage?.cropping(to: CGRect(x: rcy-iw*0.5, y: 0 , width: iw, height: iw))
                    
                    
                    
                    DispatchQueue.main.async(execute: { () -> Void in

                        let resizedImage = UIImage(cgImage: imageRef!, scale: sw/iw, orientation: image.imageOrientation)
                        delegate.cameraShotFinished(image: resizedImage)
                        
//                        self.session       = nil
//                        self.device        = nil
//                        self.imageOutput   = nil
//                        self.motionManager = nil
                        
                    })
                }
                
            })
            
        })
    }
  
    func flipButtonPressed() {
        
        if !cameraIsAvailable() {
            
            return
        }
        
        session?.stopRunning()
        
        do {
            
            session?.beginConfiguration()
            
            if let session = session {
                
                for input in session.inputs {
                    
                    session.removeInput(input as! AVCaptureInput)
                }
                
                let position = (videoInput?.device.position == AVCaptureDevicePosition.front) ? AVCaptureDevicePosition.back : AVCaptureDevicePosition.front
                
                for device in AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) {
                    
                    if let device = device as? AVCaptureDevice , device.position == position {
                        
                        videoInput = try AVCaptureDeviceInput(device: device)
                        session.addInput(videoInput)
                        
                    }
                }
                
            }
            
            session?.commitConfiguration()
            
            
        } catch {
            
        }
        
        session?.startRunning()
    }
    
    func flashButtonPressed(sender:UIButton) {
        if !cameraIsAvailable() {
            
            return
        }
        
        do {
            
            if let device = device {
                
                guard device.hasFlash else { return }
                
                try device.lockForConfiguration()
                
                let mode = device.flashMode
                
                if mode == AVCaptureFlashMode.off {
                    
                    device.flashMode = AVCaptureFlashMode.on
                sender.setImage(#imageLiteral(resourceName: "flashOn"), for: UIControlState())
                    
                } else if mode == AVCaptureFlashMode.on {
                    
                    device.flashMode = AVCaptureFlashMode.off
                    sender.setImage(#imageLiteral(resourceName: "flash"), for: UIControlState())
                }
                
                device.unlockForConfiguration()
                
            }
            
        } catch _ {
            
            sender.setImage(#imageLiteral(resourceName: "flash"), for: UIControlState())
            return
        }
        
    }
    func cameraIsAvailable() -> Bool {
        
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        if status == AVAuthorizationStatus.authorized {
            
            return true
        }
        
        return false
    }
}
