//
//  CameraVCViewController.swift
//  Museek
//
//  Created by Mauricio Monsivais on 11/2/17.
//  Copyright © 2017 Museek. All rights reserved.
//

import UIKit
import AVFoundation

/**
 Will ask for camera permision, if given will display camera in view
 and with 45 second recording capabilities.
 - Author: Mauricio Monsivais
 - Note:
 guidance from "https://github.com/codepath/ios_guides/wiki/Creating-a-Custom-Camera-View "
 */
class CameraVC: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    var isPresented = true //used in appDelegate as check for landscape
    @IBOutlet private weak var recButton: RoundedButton!
    private var isRecording = false
    
    private var previewLayer: AVCaptureVideoPreviewLayer!
    fileprivate static var _captureSession: AVCaptureSession? //to transfer data between one or more device inputs
    static var captureSession: AVCaptureSession { //singleton pattern
        get{
            if let sesh = _captureSession { return sesh }
            else {
                _captureSession = AVCaptureSession()
                return _captureSession!
            }
        }
    }
    
    internal override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.checkCameraAuthorization { authorized in
            if authorized { self.setupCamera()}
            else { print("Permission to use camera denied.") }
        }
    }
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    internal override func viewDidDisappear(_ animated: Bool) {
        isPresented = false // Set this flag to NO before dismissing controller, so that correct orientation will be chosen
        CameraVC.captureSession.stopRunning()
    }
    
    internal func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if isRecording {
        }
        else {
            
        }
    }
    
    /**
     starts recording a video until method is called again
     */
    @IBAction private func recordButtonPressed(_ sender: UIButton) {
        isRecording = !isRecording
        //logic in captureOutput
    }
    
    /**
     checks if user has previously authorized app to use camera
     */
    private func checkCameraAuthorization(_ completionHandler: @escaping ((_ authorized: Bool) -> Void)) {
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
        case .authorized:
            //The user has previously granted access to the camera.
            completionHandler(true)
        case .notDetermined:
            // The user has not yet been presented with the option to grant video access so request access.
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { success in
                completionHandler(success)
            })
        case .denied:
            // The user has previously denied access.
            completionHandler(false)
        case .restricted:
            // The user doesn't have the authority to request access e.g. parental restriction.
            completionHandler(false)
        }
    }
    
    /**
    called every time camera VC willAppear().
     Sets up capture session, preview layer, and output queue
    */
    private func setupCamera(){
        if let captureDevice = AVCaptureDevice.default(for: .video) {
            // let audioCapture = AVCaptureDevice.default(for: .audio)
            do {
                let videoInput = try AVCaptureDeviceInput(device: captureDevice)//reason for do-catch
                if CameraVC.captureSession.inputs.isEmpty {
                    CameraVC.captureSession.addInput(videoInput)
                }
                
                self.setupVideoPreviewLayer()
                CameraVC.captureSession.startRunning()
                self.setupOutput()
                
            } catch { print(error.localizedDescription) }
        }
    }
    
    private func setupOutput() {
        let outputQueue = DispatchQueue(label: "outputQueue")
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.videoSettings =
            [(kCVPixelBufferPixelFormatTypeKey as String) : NSNumber(value:kCVPixelFormatType_32BGRA)]//@TODO: do research on video format
        videoOutput.alwaysDiscardsLateVideoFrames = true
        if CameraVC.captureSession.canAddOutput(videoOutput) {
            CameraVC.captureSession.addOutput(videoOutput)
        }
        CameraVC.captureSession.commitConfiguration()
        videoOutput.setSampleBufferDelegate(self, queue: outputQueue)
    }
    
    /**
     sets up a video preview of the camera to display in view
     */
    private func setupVideoPreviewLayer(){
        previewLayer = AVCaptureVideoPreviewLayer(session: CameraVC.captureSession)
        //        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = self.view.layer.bounds
        self.view.layer.sublayers?.insert(previewLayer, at: 0)

    }
}
