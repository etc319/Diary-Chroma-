//
//  SceneDelegate.swift
//  VideoSampleViewController
//
//  Created by Nien Lam on 4/27/20.
//  Copyright © 2020 Mobile Lab. All rights reserved.
//

import UIKit
import AVFoundation

class VideoSampleViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    let captureSession = AVCaptureSession()

    var previewLayer: AVCaptureVideoPreviewLayer?

    var imageBuffer: CVPixelBuffer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSession()
    
        self.displayPreview(on: self.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        captureSession.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        captureSession.stopRunning()
    }
    
    func displayPreview(on view: UIView) {
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        //        self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.previewLayer?.connection?.videoOrientation = .portrait
        
        view.layer.insertSublayer(self.previewLayer!, at: 0)
        
        // Note: Using 3/4 photo aspect ratio.
        self.previewLayer?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.width * 4/3)
    }
    
    func configureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        guard let backCamera = AVCaptureDevice.default(for: .video) else {
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            captureSession.addInput(input)
        } catch {
            return
        }
        
        let videoOutput = AVCaptureVideoDataOutput()
        //videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]

        
        let dataOutputQueue = DispatchQueue(label: "video data queue",
                                            qos: .userInitiated,
                                            attributes: [],
                                            autoreleaseFrequency: .workItem)
        
        videoOutput.setSampleBufferDelegate(self,
                                            queue: dataOutputQueue)
        
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
            captureSession.startRunning()
        }
    }
    
    // AVCaptureVideoDataOutputSampleBufferDelegate
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        
        // Save image buffer.
        imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
    }

    func convert(cmage: CIImage) -> UIImage {
         let context:CIContext = CIContext.init(options: nil)
         let cgImage:CGImage = context.createCGImage(cmage, from: cmage.extent)!
         let image:UIImage = UIImage.init(cgImage: cgImage)
         return image
    }

    func getColor(atNormalizedPoint: CGPoint) -> UIColor? {
        guard let imageBuffer = self.imageBuffer else { return nil }

        let ciimage : CIImage = CIImage(cvPixelBuffer: imageBuffer)
        let image : UIImage = self.convert(cmage: ciimage)
        
        // Pixel buffer need to be rotated to match touch point.
        let imageRotated = image.rotate(radians: CGFloat.pi / 2.0)
        
        let x = atNormalizedPoint.x * imageRotated.size.width
        let y = atNormalizedPoint.y * imageRotated.size.height
        
        return imageRotated.getPixelColor(point: CGPoint(x: x, y: y))
    }
}


