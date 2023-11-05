//
//  SPMainTableViewCell.swift
//  SeptemberPhoto
//
//  Created by Eric on 2023/9/21.
//

import UIKit

class SPMainTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(detailLabel)
        self.contentView.addSubview(arrowImg)
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(28)
            make.top.equalTo(20)
        }
        
        arrowImg.snp.makeConstraints { make in
            make.height.width.equalTo(40)
            make.right.equalTo(-28)
            make.centerY.equalTo(self.contentView)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.left.equalTo(28)
            make.bottom.equalTo(-20)
            make.right.equalTo(arrowImg.snp.left).offset(-8)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var arrowImg : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "right_arrow_icon")
        return imgView
    }()
    
    lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.norFont(size: 24)
        label.textColor = .black
        label.text = "--"
        return label
    }()
    
    lazy var detailLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.norFont(size: 18)
        label.textColor = UIColor(hex: 0x02040E, alpha: 0.4)
        label.text = "--"
        label.minimumScaleFactor = 12.0 / 18.0
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        return label
    }()

}
