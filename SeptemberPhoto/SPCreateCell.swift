//
//  SPCreateCell.swift
//  SeptemberPhoto
//
//  Created by Eric on 2023/9/21.
//

import UIKit

class SPCreateCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.random
        
        self.contentView.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    lazy var imgView : UIImageView = {
        let imgView = UIImageView()
        return imgView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
