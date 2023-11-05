//
//  SPCreateViewController.swift
//  SeptemberPhoto
//
//  Created by Eric on 2023/9/21.
//

import UIKit
import AssetsLibrary

class SPCreateViewController: SPBaseViewController {
    
    var resultImage : UIImage?
    var popArtImgs : [UIImage] = []
    var pngPath: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.hex(hexString: "#FACD56")
        
        self.view.addSubview(headerImgView)
        let headHeight = UIScreen.statusBarH + 118
        headerImgView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(headHeight)
        }
        
        self.view.addSubview(avatarImgView)
        let avatarH = UIScreen.statusBarH + 58
        avatarImgView.snp.makeConstraints { make in
            make.width.height.equalTo(92)
            make.top.equalTo(avatarH)
            make.centerX.equalToSuperview()
        }
        
        avatarImgView.image = resultImage
        
        self.view.addSubview(bottomImgView)
        bottomImgView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(134)
        }
        
        self.view.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.left.equalTo(46)
            make.right.equalTo(-46)
            make.bottom.equalTo(-47)
            make.height.equalTo(57)
        }
        
        self.view.addSubview(recoverBtn)
        recoverBtn.snp.makeConstraints { make in
            make.left.equalTo(46)
            make.right.equalTo(-46)
            make.bottom.equalTo(-47)
            make.height.equalTo(57)
        }
        
        progressView.addSubview(saveImg)
        saveImg.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
            make.left.equalTo(22)
        }
        
        progressView.addSubview(saveTitle)
        saveTitle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(saveImg.snp.right).offset(8)
        }
        
        progressView.addSubview(progressLabel)
        progressLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-22)
        }
        
        progressView.addSubview(saveBtn)
        saveBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let height : CGFloat = 114 * 3 + 16
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(avatarImgView.snp.bottom).offset(25)
            make.height.equalTo(height)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.titleString == "History".localized() {
            let deleteItem = UIBarButtonItem(customView: deleteBtn)
            navigationItem.rightBarButtonItems = [deleteItem ]
        } else if self.titleString == "Deleted".localized() {
            progressView.isHidden = true
            recoverBtn.isHidden = false
        }
        
        popArtImgs = []
        if let res = self.resultImage {
            let imgs = ImageFilterManger.getImageArr(with: res)
            popArtImgs.append(contentsOf: imgs)
        }
    }
    
    @objc func didClickSaveBtn(){
        if popArtImgs.count > 0 {
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "HH:mm:ss yyyy-MM-dd"
            let homeDirectory = NSHomeDirectory()
            let documentPath = homeDirectory + "/Documents/Create"
            let fileManager : FileManager = FileManager.default
            
            let dateString = dateFormater.string(from: Date())
            let filePath = documentPath + "/" + dateString + ".png"
            let documentUrl : URL = URL(fileURLWithPath: documentPath)
            let imgData = self.resultImage?.jpegData(compressionQuality: 1.0)
            do{
                try fileManager.createDirectory(at: documentUrl, withIntermediateDirectories: true)
                fileManager.createFile(atPath: filePath, contents: imgData, attributes: nil)
            }catch let error{
                print(error)
            }
            
            let authorizationStatus = PHPhotoLibrary.authorizationStatus()
            for i in 0 ..< popArtImgs.count {
                let image = popArtImgs[i]
                if authorizationStatus == .notDetermined {
                    /// 首次保存 权限未知 需进行相册权限授权操作
                    PHPhotoLibrary.requestAuthorization { status in
                        if status == .authorized {
                            self.save(image: image, index: i)
                        } else {
                            self.alertUser(message: "Camera alert".localized())
                        }
                    }
                    
                } else if authorizationStatus == .authorized {
                    self.save(image: image, index: i)
                } else {
                    /// 权限不允许
                    self.alertUser(message: "Camera alert".localized())
                }
            }
            
        }
    }
    
    @objc func didClickDeleteBtn(){
        
        let alert = UIAlertController(title: "Delete title".localized(), message: "Delete description".localized(), preferredStyle: .alert)
        let confirm = UIAlertAction(title:"Confirm".localized(), style: .default) { [weak self] action in
            guard let `self` = self else { return }
            self.moveImgData()
        }
        let cancel = UIAlertAction(title:"Cancel".localized(), style: .cancel) { action in
            
        }
        alert.addAction(confirm)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
    @objc func didClickRecoverBtn(){
        self.moveImgData()
    }
    
    func moveImgData(){
        if let pngPath = pngPath {
            let fileManager = FileManager.default
            let homeDirectory = NSHomeDirectory()
            let documentPath = homeDirectory + "/Documents/"
            let sourcePath = documentPath + "Create/" + pngPath
            let destinationPath = documentPath + "Deleted/" + pngPath
            if self.titleString == "History".localized() {
                self.createDirectoryIfNeeded(atPath: documentPath + "Deleted/")
                do {
                    try fileManager.moveItem(atPath: sourcePath, toPath: destinationPath)
                    print("成功将文件从 \(sourcePath) 移动到 \(destinationPath)")
                    self.navigationController?.popViewController(animated: true)
                } catch {
                    print("移动文件时出错：\(error)")
                    self.navigationController?.popViewController(animated: true)
                }
            }else if self.titleString == "Deleted".localized() {
                do {
                    try fileManager.moveItem(atPath: destinationPath, toPath: sourcePath)
                    print("成功将文件从 \(destinationPath) 移动到 \(sourcePath)")
                    self.navigationController?.popViewController(animated: true)
                } catch {
                    print("移动文件时出错：\(error)")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func createDirectoryIfNeeded(atPath path: String) {
        let fileManager = FileManager.default
        
        // 使用fileExists(atPath:)方法检查文件夹是否存在
        if !fileManager.fileExists(atPath: path) {
            do {
                // 使用createDirectory(atPath:withIntermediateDirectories:attributes:)方法创建文件夹
                try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                print("文件夹创建成功：\(path)")
            } catch {
                print("创建文件夹时出错：\(error)")
            }
        } else {
            print("文件夹已存在：\(path)")
        }
    }
    
    func save(image: UIImage, index : Int){
        let imageManager = TZImageManager()
        imageManager.savePhoto(with: image) { asset, error in
            if asset != nil {
                self.progressLabel.text = "\(index + 1)/9"
                self.progressView.progress = CFloat(index + 1) / 9.0
                
                if index == self.popArtImgs.count - 1 {
                    self.saveTitle.text = "Saved success!".localized()
                    self.saveImg.image = UIImage(named: "success_icon")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
            if error != nil {
                
            }
        }
    }
    
    func alertUser(message : String){
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Confirm".localized(), style: .default) { action in
            
        }
        alert.addAction(action)
        self.present(alert, animated: true)
        
    }
    
    lazy var recoverBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("Recover".localized(), for: .normal)
        btn.titleLabel?.font = UIFont.norFont(size: 18)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .white
        btn.addTarget(self, action: #selector(didClickRecoverBtn), for: .touchUpInside)
        btn.isHidden = true
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 57/2
        return btn
    }()
    
    lazy var deleteBtn :  UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "delete_icon"), for: .normal)
        btn.addTarget(self, action: #selector(didClickDeleteBtn), for: .touchUpInside)
        return btn
    }()
    
    lazy var saveBtn : UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(didClickSaveBtn), for: .touchUpInside)
        return btn
    }()
    
    lazy var saveImg : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "download_icon")
        return imgView
    }()
    
    lazy var saveTitle : UILabel = {
        let label = UILabel()
        label.font = UIFont.norFont(size: 18)
        label.textColor = .black
        label.text = "Saved all".localized()
        return label
    }()
    
    lazy var progressLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.norFont(size: 14)
        label.textColor = .black
        label.text = "0/9"
        return label
    }()
    
    lazy var progressView : UIProgressView = {
        let progress = UIProgressView()
        progress.trackTintColor = .white
        progress.progressTintColor = UIColor.hex(hexString: "00CA7C")
        progress.layer.masksToBounds = true
        progress.layer.cornerRadius = 57/2
        progress.progress = 0
        return progress
    }()
    
    lazy var headerImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "create_head")
        imgView.backgroundColor = UIColor.hex(hexString: "5B79FF")
        return imgView
    }()
    
    lazy var bottomImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "create_bottom")
        return imgView
    }()
    
    lazy var avatarImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.layer.masksToBounds = true
        imgView.layer.cornerRadius = 46
        imgView.layer.borderColor = UIColor.white.cgColor
        imgView.layer.borderWidth = 5
        return imgView
    }()
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let itemW : CGFloat = (UIScreen.ScreenW - 8 * 2 - 20)/3
        layout.itemSize = CGSize(width: itemW, height:  itemW)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.hex(hexString: "#FACD56")
        collectionView.register(SPCreateCell.self, forCellWithReuseIdentifier: "SPCreateCell")
        return collectionView
        
    }()
    
}

extension SPCreateViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SPCreateCell", for: indexPath) as! SPCreateCell
        if popArtImgs.count > 0, indexPath.row < popArtImgs.count{
            cell.imgView.image = popArtImgs[indexPath.row]
        }
        return cell
    }
    
}
