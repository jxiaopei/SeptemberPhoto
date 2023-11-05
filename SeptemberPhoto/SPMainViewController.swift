//
//  SPMainViewController.swift
//  SeptemberPhoto
//
//  Created by Eric on 2023/9/20.
//

import UIKit
import JXSegmentedView

class SPMainViewController: SPBaseViewController {

    var titles = ["Album".localized(), "Photo".localized()]
    var dataList  = [["title" : "History".localized(),"detail" : "History Description".localized()],
                    ["title" : "Deleted".localized(),"detail" : "Deleted Description".localized()],
    ]
    
    var selIndex : Int = 0
    var resultImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addSubview(headerImgView)
        headerImgView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(278)
        }
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerImgView.snp.bottom)
            make.bottom.left.right.equalToSuperview()
        }
        
        self.view.addSubview(segmentedView)
        segmentedView.snp.makeConstraints { make in
            make.bottom.equalTo(headerImgView)
            make.left.right.equalToSuperview()
            make.height.equalTo(54)
        }
        
        self.view.addSubview(albumBtn)
        albumBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.width.equalTo(100)
            make.top.equalTo(96)
        }
        
        self.view.addSubview(cameraBtn)
        cameraBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.width.equalTo(100)
            make.top.equalTo(96)
        }
        
    }
    
    @objc func didClickAlbumBtn(){
       
        let config = LXFPhotoConfig()
        config.navBarBgColor = UIColor.hex(hexString: "FF6854")
        config.navBarTintColor = UIColor.black
        config.navBarTitleColor = UIColor.white
        
        LXFPhotoHelper.creat(with: .photoLibrary, config: config).getSourceWithSelectImageBlock { [weak self] data in
            guard let `self` = self else { return }
            if let image = data as? UIImage {
                let create = SPCreateViewController()
                create.resultImage = image
                create.titleString = "Pop wind"
                self.navigationController?.pushViewController(create, animated: true)
            }
        }
        
    }
    
    @objc func didClickCameraBtn(){
        let camera = SPCameraViewController()
        self.navigationController?.pushViewController(camera, animated: true)
    }
    
    lazy var albumBtn : UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "album_icon"), for: .normal)
        btn.addTarget(self, action: #selector(didClickAlbumBtn), for: .touchUpInside)
        return btn
    }()
    
    lazy var cameraBtn : UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "camera_icon"), for: .normal)
        btn.addTarget(self, action: #selector(didClickCameraBtn), for: .touchUpInside)
        btn.isHidden = true
        return btn
    }()
    
    lazy var headerImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "album_bg")
        imgView.backgroundColor = UIColor.hex(hexString: "FF6854")
        return imgView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.register(SPMainTableViewCell.self, forCellReuseIdentifier: "SPMainTableViewCell")
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 107
        tableView.showsVerticalScrollIndicator = false
        //iOS 15新增 不加这句代码 会留22像素空白
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
        tableView.separatorStyle = .none
        return tableView
    }()
    
    lazy var segmentedView: JXSegmentedView = {
        let segmentedView: JXSegmentedView = JXSegmentedView()
        segmentedView.isContentScrollViewClickTransitionAnimationEnabled = false
        segmentedView.delegate = self
        segmentedView.dataSource = dataSource
        segmentedView.indicators = [sliderView]
        return segmentedView
    }()
    
    lazy var sliderView : JXSegmentedIndicatorLineView = {
        let view = JXSegmentedIndicatorLineView()
        view.indicatorColor = .black
        view.indicatorWidth = UIScreen.ScreenW/2
        view.indicatorHeight = 8
        return view
    }()

    lazy var dataSource: JXSegmentedTitleDataSource = {
        let dataSource: JXSegmentedTitleDataSource = JXSegmentedTitleDataSource()
        dataSource.titleSelectedColor = UIColor(hex: 0x02040E, alpha: 1.0)
        dataSource.titleNormalColor = UIColor(hex: 0x02040E, alpha: 0.4)
        dataSource.titleSelectedFont = UIFont.norFont(size: 24)
        dataSource.titleNormalFont = UIFont.norFont(size: 24)
        dataSource.isTitleColorGradientEnabled = true
        dataSource.isTitleZoomEnabled = false
        dataSource.titles = titles
        dataSource.itemWidth = UIScreen.ScreenW/2
        dataSource.itemSpacing = 0
        return dataSource
    }()

}

extension SPMainViewController: JXSegmentedViewDelegate {
    //点击标题栏
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {

        if index == 0 {
            self.albumBtn.isHidden = false
            self.cameraBtn.isHidden = true
            headerImgView.image = UIImage(named: "album_bg")
            headerImgView.backgroundColor = UIColor.hex(hexString: "FF6854")
        }else{
            self.albumBtn.isHidden = true
            self.cameraBtn.isHidden = false
            headerImgView.image = UIImage(named: "camera_bg")
            headerImgView.backgroundColor = UIColor.hex(hexString: "00CA7C")
        }
    }
}

extension SPMainViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SPMainTableViewCell", for: indexPath) as! SPMainTableViewCell
        if let title = dataList[indexPath.row]["title"], let detail = dataList[indexPath.row]["detail"] {
            cell.nameLabel.text = title
            cell.detailLabel.text = detail
        }
        cell.selectionStyle = .none
        return cell
    }
    
}

extension SPMainViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let imgList = SPImageListViewController()
        if indexPath.row == 0 {
            imgList.titleString = "History".localized()
        }else{
            imgList.titleString = "Deleted".localized()
        }
        self.navigationController?.pushViewController(imgList, animated: true)
    }
}


