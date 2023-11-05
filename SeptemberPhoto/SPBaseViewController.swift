//
//  SPBaseViewController.swift
//  SeptemberPhoto
//
//  Created by Eric on 2023/9/21.
//

import UIKit

class SPBaseViewController: UIViewController {

    var titleString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let backItem = UIBarButtonItem(customView: backButton)
        let titleItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.leftBarButtonItems = [backItem, titleItem]
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = self.titleString
        label.font = UIFont.norFont(size: 22)
        label.textColor = .black
        return label
    }()

    lazy var backButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "back_icon"), for: .normal)
        btn.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        btn.addTarget(self, action: #selector(didClickBackBtn), for: .touchUpInside)
        return btn
    }()
    
    @objc func didClickBackBtn(){
        self.navigationController?.popViewController(animated: true)
    }

}
