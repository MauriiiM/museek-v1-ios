//
//  CameraVCViewController.swift
//  Museek
//
//  Created by Mauricio Monsivais on 11/2/17.
//  Copyright © 2017 Museek. All rights reserved.
//

import UIKit
import AVFoundation

extension CameraVC: AVCaptureFileOutputRecordingDelegate{
    func fileOutput(_ output: AVCaptureFileOutput,
                    didFinishRecordingTo outputFileURL: URL,
                    from connections: [AVCaptureConnection],
                    error: Error?) {
        //@TODO
        if let err = error { print(err) }
    }
}

/**
 Will ask for camera permision, if given, will display camera in view sublayer
 and record video once recording button is pressed.
 - Author: Mauricio Monsivais
 - Note:
 guidance from "https://github.com/codepath/ios_guides/wiki/Creating-a-Custom-Camera-View "
 */
class CameraVC: UIViewController {
    @IBOutlet weak fileprivate var flashButton: UIButton!
    @IBOutlet weak fileprivate var recButton: UIButton!
    
    static var isPresented = false //used in appDelegate as check for landscape
    fileprivate lazy var previewLayer: AVCaptureVideoPreviewLayer? = {
        let layer = AVCaptureVideoPreviewLayer(session: CameraVC.captureSession)
        layer.videoGravity = .resizeAspectFill
        layer.frame = self.view.bounds
        self.view.layer.sublayers?.insert(layer, at: 0)
        return layer
    }()
    fileprivate let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy-HH:mm"
        return formatter
    }()
    //timer vars
    @IBOutlet weak fileprivate var timeLabel: UILabel!
    fileprivate var timer = Timer()
    fileprivate var recMin = 0
    fileprivate var recSec = 0
    //end timer vars
    //capture objects vars
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
    fileprivate var videoCaptureDevice: AVCaptureDevice?
    fileprivate var audioCaptureDevice: AVCaptureDevice?
    fileprivate var movieOutput: AVCaptureMovieFileOutput?
    fileprivate var movieURL: URL!
    fileprivate var docDirectory: URL {
        get{
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        }
    }
    //end vars
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let uploadVC = segue.destination as! UploadVC
        uploadVC.url.movie = movieURL
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupOutput()
        CameraVC.isPresented = true
        self.checkCameraAuthorization { authorized in
            if authorized { self.setupCamera()}
            else { print("Permission to use camera denied.") }
        }
        timeLabel.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        CameraVC.isPresented = false // Set this flag to NO before dismissing controller, so that correct orientation will be chosen
        if movieOutput != nil && movieOutput!.isRecording { stopRecording() }
        CameraVC.captureSession.stopRunning()
    }
    
    /**
     called when camera first opens and changes from portrait to landscape
     */
    override func viewDidLayoutSubviews() {
        self.configureVideoOrientation()
    }
    
    /**
     called when every orientation change
     */
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.configureVideoOrientation()
    }
    
    /**
     toggles flash on/off whenever flash button is pressed
     */
    @IBAction private func flashButtonPressed(_ sender: UIButton) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                
                if device.torchMode == .off {
                    device.torchMode = .on
                    sender.setImage(UIImage(named: "flash (on)"), for: .normal)
                }
                else /*if device.torchMode == .on*/{
                    device.torchMode = .off
                    sender.setImage(UIImage(named: "flash (off)"), for: .normal)
                } /*else {
                 device.torchMode = .auto
                 }*/
                
                device.unlockForConfiguration()
            } catch { print("problem with flash \(error)") }
        }
    }
    
    /**
     starts recording a video until method is called again
     @TODO use AVAssetExportSession to changef rom .mov to mp4
     @TODO fix record repeatability
     */
    @IBAction private func recordButtonPressed(_ sender: UIButton) {
        if let output = movieOutput {
            if UIDevice.current.orientation == .landscapeRight
                || UIDevice.current.orientation == .landscapeLeft
                && !output.isRecording {//start recording
                pageSwipe(isEnabled: false)
                sender.setImage(UIImage(named: "record (filled)"), for: .normal)
                sender.blink(duration: 0.75)
                flashButton.isHidden = true
                flashButton.isEnabled = false
                movieURL = docDirectory.appendingPathComponent("museek_\(dateFormatter.string(from: Date())).mov")
                try? FileManager.default.removeItem(at: movieURL)
                output.startRecording(to: movieURL, recordingDelegate: self)
            } else if output.isRecording { //stop recording
                stopRecording()
                performSegue(withIdentifier: "toUploadVC", sender: self)
            } else {
                //@TODO show turn phone animation
            }
        }
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
                completionHandler(success)})
        case .denied:
            // The user has previously denied access.
            completionHandler(false)
        case .restricted:
            // The user doesn't have the authority to request access e.g. parental restriction.
            completionHandler(false)
        }
    }
    
    /**
     should be called when phone is changing orientation to correct how the camera is previewed
     */
    fileprivate func configureVideoOrientation() {
        if let previewLayer = self.previewLayer, let connection = previewLayer.connection {
            let orientation = UIDevice.current.orientation
            
            if connection.isVideoOrientationSupported,
                let videoOrientation = AVCaptureVideoOrientation(rawValue: orientation.rawValue) {
                previewLayer.frame = self.view.bounds
                connection.videoOrientation = videoOrientation//this one's from preview layer
                movieOutput?.connection(with: .video)?.videoOrientation = videoOrientation//Ffor actual video
                CameraVC.captureSession.commitConfiguration()
            }
        }
    }
    
    fileprivate func pageSwipe(isEnabled: Bool){
        if isEnabled { NotificationCenter.default.post(name: NSNotification.Name(rawValue: "enableSwipe"), object: nil) }
        else { NotificationCenter.default.post(name: NSNotification.Name(rawValue: "disableSwipe"), object: nil) }
    }
    
    /**
     called every time camera VC willAppear().
     Sets up capture session, adds a capture input to it, and sets up output queue
     */
    fileprivate func setupCamera(){
        if let vidCaptureDevice = AVCaptureDevice.default(for: .video),
            let audCaptureDevice = AVCaptureDevice.default(for: .audio){
            videoCaptureDevice = vidCaptureDevice
            audioCaptureDevice = audCaptureDevice
            do {
                CameraVC.captureSession.sessionPreset = .high
                try self.setupCapture(audioDevice: audCaptureDevice, videoDevice: vidCaptureDevice)
                CameraVC.captureSession.startRunning()
            } catch { print(error.localizedDescription) }
        }
    }
    
    fileprivate func setupCapture(audioDevice audio: AVCaptureDevice, videoDevice video: AVCaptureDevice) throws {
        let videoInput = try AVCaptureDeviceInput(device: video)//reason for do-catch
        let audioInput = try AVCaptureDeviceInput(device: audio)
        
        if CameraVC.captureSession.canAddInput(videoInput) {
            CameraVC.captureSession.addInput(videoInput)
        }
        if CameraVC.captureSession.canAddInput(audioInput) {
            CameraVC.captureSession.addInput(audioInput)
        }
        CameraVC.captureSession.commitConfiguration()
    }
    
    fileprivate func setupOutput() {
        if movieOutput == nil { movieOutput = AVCaptureMovieFileOutput() }
        if CameraVC.captureSession.canAddOutput(movieOutput!) {
            CameraVC.captureSession.addOutput(movieOutput!)
        }
        CameraVC.captureSession.commitConfiguration()
    }
    
    /**
     stops AVCaptureMovieOutput's instance from recording and returns camera
     buttons (flash, record) to original state.
     */
    fileprivate func stopRecording(){
        pageSwipe(isEnabled: true)
        recButton.setImage(UIImage(named: "record"), for: .normal)
        recButton.blink(enabled: false)
        flashButton.isHidden = false
        flashButton.isEnabled = true
        movieOutput?.stopRecording()
    }
}
