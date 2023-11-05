//
//  SPStartViewController.swift
//  SeptemberPhoto
//
//  Created by Eric on 2023/9/20.
//

import UIKit
import SnapKit
import ActiveLabel
import Localize_Swift

class SPStartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(bgImg)
        bgImg.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        
        self.view.addSubview(agreement)
        agreement.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalToSuperview().offset(-32)
        }
        
        self.view.addSubview(createBtn)
        createBtn.snp.makeConstraints { make in
            make.left.equalTo(46)
            make.right.equalTo(-46)
            make.bottom.equalTo(agreement.snp.top).offset(-13)
            make.height.equalTo(57)
        }
        
        self.view.addSubview(desLabel)
        desLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalTo(createBtn.snp.top).offset(-68)
        }
        
    }
    
    @objc func didClickCreateBtn(){
        let main = SPMainViewController()
        self.navigationController?.pushViewController(main, animated: true)
    }

    lazy var bgImg : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "startBg")
        return imgView
    }()
    
    lazy var desLabel : UILabel = {
        let label = UILabel()
        label.text = "Start Description".localized()
        label.numberOfLines = 0
        label.font = UIFont.norFont(size: 16)
        label.textColor = .black
        return label
    }()
    
    lazy var createBtn : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.hex(hexString: "#00CA7C")
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 57/2
        btn.layer.borderWidth = 2
        btn.layer.borderColor = UIColor.black.cgColor
        btn.titleLabel?.textColor = .black
        btn.setTitle("Create Now".localized(), for: .normal)
        btn.addTarget(self, action: #selector(didClickCreateBtn), for: .touchUpInside)
        return btn
    }()
    
    lazy var agreement : ActiveLabel = {
        let label = ActiveLabel()
        let patten1 = "'User Agreement'".localized()
        let patten2 = "'Privacy Policy'".localized()
        let customType1 = ActiveType.custom(pattern: "\\" + patten1)
        let customType2 = ActiveType.custom(pattern: "\\" + patten2)
        label.enabledTypes.append(customType1)
        label.enabledTypes.append(customType2)
        label.customize { label in
            label.textColor = .black
            label.numberOfLines = 0
            label.customColor[customType1] = .white
            label.customColor[customType2] = .white
            label.text = "Agreement description".localized()
            label.font = UIFont.norFont(size: 14)
            label.numberOfLines = 2
        }
        label.textAlignment = .left
        
        label.handleCustomTap(for: customType1) { [weak self] _ in
            guard let `self` = self else { return }
            
            let user = SPUserAgreeViewController()
            user.type = .userAgreement
            self.navigationController?.pushViewController(user, animated: true)
        }
        
        label.handleCustomTap(for: customType2) { [weak self] _ in
            guard let `self` = self else { return }
            let policy = SPUserAgreeViewController()
            policy.type = .privatePolicy
            self.navigationController?.pushViewController(policy, animated: true)
        }
        
        return label
    }()

}
