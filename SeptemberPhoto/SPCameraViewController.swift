//
//  SPCameraViewController.swift
//  SeptemberPhoto
//
//  Created by Eric on 2023/9/21.
//

import UIKit
import AVFoundation

class SPCameraViewController: SPBaseViewController {
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var photoOutput: AVCapturePhotoOutput!
    var setting:AVCapturePhotoSettings?
    var videoConnection: AVCaptureConnection?//捕获链接
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleString = "Photograph"
        
        self.view.backgroundColor = UIColor.hex(hexString: "#FACD56")
        let headHeight = 98 + UIScreen.statusBarH
        self.view.addSubview(headView)
        headView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(headHeight)
        }
        
        self.view.addSubview(cameraView)
        cameraView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(UIScreen.ScreenW)
            make.top.equalTo(headView.snp.bottom)
        }
        
        self.view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(cameraView.snp.bottom).offset(16)
        }
        
        self.view.addSubview(bottomImgView)
        bottomImgView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(134)
        }
        
        self.view.addSubview(circleView)
        circleView.snp.makeConstraints { make in
            make.width.height.equalTo(88)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-48)
        }
        
        // 创建捕捉会话和预览图层
        captureSession = AVCaptureSession()
        setupCaptureSession()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 添加预览图层到视图
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        let headHeight = 98 + UIScreen.statusBarH
        previewLayer.frame = CGRect(x: 0, y: headHeight, width: UIScreen.ScreenW, height: UIScreen.ScreenW)// 设置拍照区域大小
        view.layer.addSublayer(previewLayer)
    }
    
    // 设置捕捉会话
    func setupCaptureSession() {
        captureSession.sessionPreset = .photo
        setting=AVCapturePhotoSettings.init(format: [AVVideoCodecKey:AVVideoCodecType.jpeg])
        photoOutput = AVCapturePhotoOutput.init()
        
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            fatalError("前置摄像头不可用")
        }
        
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
        } catch {
            print("无法添加摄像头输入: \(error.localizedDescription)")
        }
        
        captureSession.startRunning()
    }
    
    @objc func didClickCircleBtn(){
        //拍照
        videoConnection = photoOutput.connection(with: AVMediaType.video)
        if videoConnection == nil {
            print("take photo failed!")
            return
        }
        
        photoOutput.capturePhoto(with: setting!, delegate: self)
    }
    
    lazy var circleView : UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 44
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.hex(hexString: "5B79FF").cgColor
        view.backgroundColor = .white
        view.addSubview(circleBtn)
        circleBtn.frame = CGRect(x: 6, y: 6, width: 76, height: 76)
        return view
    }()
    
    lazy var circleBtn : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.hex(hexString: "5B79FF")
        btn.addTarget(self, action: #selector(didClickCircleBtn), for: .touchUpInside)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 38
        return btn
    }()
    
    lazy var descriptionLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.norFont(size: 16)
        label.textColor = UIColor(hex: 0x02040E, alpha: 0.4)
        label.text = "Camera Description".localized()
        label.numberOfLines = 2
        return label
    }()
    
    lazy var cameraView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var headView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.hex(hexString: "5B79FF")
        return view
    }()
    
    lazy var bottomImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "create_bottom")
        return imgView
    }()
    
}

extension SPCameraViewController : AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        captureSession.stopRunning()//停止
        let data = photo.fileDataRepresentation();
        let image=UIImage.init(data: data!)
        print("\(photo.metadata)")
        let create = SPCreateViewController()
        create.resultImage = image?.fixOrientation()
        create.titleString = "Pop wind"
        self.navigationController?.popViewController(animated: false)
        UIViewController.current()?.navigationController?.pushViewController(create, animated: true)
    }
}
