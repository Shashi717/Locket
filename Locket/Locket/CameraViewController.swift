//
//  CameraViewController.swift
//  Locket
//
//  Created by Madushani Lekam Wasam Liyanage on 2/10/18.
//  Copyright © 2018 Madushani Lekam Wasam Liyanage. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import AVFoundation
import GooglePlaces
import GoogleMaps

class CameraViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var captureButton: UIButton!
    @IBOutlet var swapButton: UIButton!
    @IBOutlet var addButton: UIButton!
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var previewView: UIView!
    @IBOutlet var tempImageView: UIImageView!
    
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var stillImageOutput: AVCaptureStillImageOutput?
    var captureDevice: AVCaptureDevice?
    var capturedImage: UIImage?
    
    var usingFrontCamera = false
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    
    // An array to hold the list of likely places.
    var likelyPlaces: [GMSPlace] = []
    
    // The currently selected place.
    var selectedPlace: GMSPlace?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCamera()
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        videoPreviewLayer!.frame = self.previewView.bounds
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    @IBAction func takePhotoTapped(_ sender: UIButton) {
        
        print("Tapped")
        if let videoConnection = stillImageOutput?.connection(with: .video) {
            
            videoConnection.videoOrientation = AVCaptureVideoOrientation.portrait
            stillImageOutput?.captureStillImageAsynchronously(from: videoConnection, completionHandler: {
                
                (sampleBuffer, error) in
                if sampleBuffer != nil {
                    
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer!)
                    let dataProvider = CGDataProvider.init(data: imageData! as CFData)
                    let cgImageRef = CGImage.init(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
                    
                    self.capturedImage = UIImage (cgImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.right)
                    
                    self.tempImageView.image = self.capturedImage
                    self.tempImageView.isHidden = false
                    self.swapButton.isHidden = true
                    self.captureButton.isHidden = true
                    self.addButton.isHidden = false
                    self.titleTextField.isHidden = false
                }
                
            })
        }
        
    }
    
    @IBAction func swapTapped(_ sender: UIButton) {
        usingFrontCamera = !usingFrontCamera
        loadCamera()
        
    }
    
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        
        dump(capturedImage)
        
    }
    
    func getFrontCamera() -> AVCaptureDevice?{
        let videoDevices = AVCaptureDevice.devices(for: .video)
        
        for device in videoDevices {
            let device = device
            if device.position == AVCaptureDevice.Position.front {
                return device
            }
        }
        return nil
    }
    
    func getBackCamera() -> AVCaptureDevice{
        return AVCaptureDevice.default(for: .video )!
    }
    func loadCamera() {
        if(captureSession == nil){
            captureSession = AVCaptureSession()
            captureSession!.sessionPreset = AVCaptureSession.Preset.photo
        }
        var error: NSError?
        var input: AVCaptureDeviceInput!
        
        captureDevice = (usingFrontCamera ? getFrontCamera() : getBackCamera())
        
        do {
            input = try AVCaptureDeviceInput(device: captureDevice!)
        } catch let error1 as NSError {
            error = error1
            input = nil
            print(error!.localizedDescription)
        }
        
        for i : AVCaptureDeviceInput in (self.captureSession?.inputs as! [AVCaptureDeviceInput]){
            self.captureSession?.removeInput(i)
        }
        
        if error == nil && captureSession!.canAddInput(input) {
            captureSession!.addInput(input)
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecType.jpeg]
            if captureSession!.canAddOutput(stillImageOutput!) {
                captureSession!.addOutput(stillImageOutput!)
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
                videoPreviewLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
                videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                //self.cameraPreviewSurface.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
                self.previewView.layer.addSublayer(videoPreviewLayer!)
                DispatchQueue.main.async {
                    self.captureSession!.startRunning()
                }
                
            }
        }
        
    }
    
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
}


