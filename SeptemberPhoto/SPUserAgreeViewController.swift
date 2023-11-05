//
//  SPUserAgreeViewController.swift
//  SeptemberPhoto
//
//  Created by Eric on 2023/9/20.
//

import UIKit
import Localize_Swift

enum AgreePageType {
    case userAgreement
    case privatePolicy
}

class SPUserAgreeViewController: SPBaseViewController {
    
    var type : AgreePageType = .userAgreement
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.hex(hexString: "#00CA7C")
        view.addSubview(contentLabel)
        let height = 54 + UIScreen.statusBarH
        contentLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.lessThanOrEqualTo(self.view)
            make.top.equalToSuperview().offset(height)
        }
        let lang = Localize.currentLanguage() == "en" ? "En" : "Cn"
        var path : URL?
        if type == .userAgreement {
            titleString = "'User Agreement'".localized()
            path = Bundle.main.url(forResource: "UserAgreement" + lang, withExtension: "txt")
        }else {
            titleString = "'Privacy Policy'".localized()
            path = Bundle.main.url(forResource: "PrivacyPolicy" + lang, withExtension: "txt")
        }
        
        do {
            let data = try Data(contentsOf: path!)
            let string = String(data: data,encoding:.utf8)!
            contentLabel.text = string
        } catch {
            
        }
        
    }
    
    lazy var contentLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.norFont(size: 16)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 10 / 16
        label.textColor = .black
        return label
    }()
}
