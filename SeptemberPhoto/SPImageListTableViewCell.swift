//
//  SPImageListTableViewCell.swift
//  SeptemberPhoto
//
//  Created by Eric on 2023/9/25.
//

import UIKit

class SPImageListTableViewCell: UITableViewCell {
    
    var popArtImgs : [UIImage] = []
    weak var currentVC : SPBaseViewController?
    var data : [String : Any]?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(dateLabel)
        self.contentView.addSubview(collectionView)
        
        dateLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-16)
        }
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }

    lazy var dateLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.norFont(size: 18)
        label.textColor = .black
        label.text = "--"
        return label
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
        collectionView.delegate = self
        collectionView.register(SPCreateCell.self, forCellWithReuseIdentifier: "SPCreateCell")
        return collectionView
        
    }()

}

extension SPImageListTableViewCell : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popArtImgs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SPCreateCell", for: indexPath) as! SPCreateCell
        if popArtImgs.count > 0, indexPath.row < popArtImgs.count{
            cell.imgView.image = popArtImgs[indexPath.row]
        }
        return cell
    }
    
}

extension SPImageListTableViewCell : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if popArtImgs.count > 0, indexPath.item < popArtImgs.count{
            let image = popArtImgs[indexPath.item]
            let create = SPCreateViewController()
            create.resultImage = image
            create.titleString = self.currentVC?.titleString ?? ""
            if let data = self.data, let paths = data["paths"] as? [String], paths.count > indexPath.item {
                let path = paths[indexPath.item]
                create.pngPath = path
            }
            self.currentVC?.navigationController?.pushViewController(create, animated: true)
        }
    }
    
}


