//
//  SPImageListViewController.swift
//  SeptemberPhoto
//
//  Created by Eric on 2023/9/25.
//

import UIKit

class SPImageListViewController: SPBaseViewController {
    
    var dataList : [[String : Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = self.titleString == "History".localized() ? UIColor.hex(hexString: "#FACD56") : UIColor.hex(hexString: "5B79FF")
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.dataList = self.getData()
        self.tableView.reloadData()
    }
    
    func getData() -> [[String : Any]]{
        let pngs = self.loadLocalImgs()
        var dataList : [[String : Any]] = []
        for png in pngs {
            var data : [String : Any] = [:]
            let strings = png.components(separatedBy: " ")
            let dateStrings = strings.last?.components(separatedBy: ".")
            let dateString = dateStrings?.first
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd"
            let homeDirectory = NSHomeDirectory()
            let path = self.titleString == "History".localized() ? "Create" : "Deleted"
            let documentPath = homeDirectory + "/Documents/" + path
            let imgUrl = documentPath + "/" + png
            
            if self.titleString == "History".localized() {
                
                let index = dataList.firstIndex(where: { $0["title"] as? String == dateString })
                if let idx = index{
                    var firData = dataList[idx]
                    if var imgs = firData["imgs"] as? [UIImage],let img = UIImage(contentsOfFile: imgUrl),
                       var paths = firData["paths"] as? [String]{
                        imgs.append(img)
                        paths.append(png)
                        firData["imgs"] = imgs
                        firData["paths"] = paths
                        dataList[idx] = firData
                    }
                }else{
                    let date = dateFormat.date(from: dateString ?? "")
                    let interval = date?.timeIntervalSince1970
                    data["time"] = interval
                    data["title"] = dateString
                    if let img = UIImage(contentsOfFile: imgUrl) {
                        let imgs : [UIImage] = [img]
                        let paths : [String] = [png]
                        data["imgs"] = imgs
                        data["paths"] = paths
                    }
                    dataList.append(data)
                }
                
            }else{
                let date = dateFormat.date(from: dateString ?? "") ?? Date()
                let currentDate = Date()
                // 创建一个Calendar对象来执行日期计算
                let calendar = Calendar.current
                // 计算时间差
                let components = calendar.dateComponents([.day], from: currentDate, to: date)

                if let daysDifference = components.day {
                    let leftDays = 30 + daysDifference
                    if leftDays >= 0 {
                        let dateString = "\(leftDays)" + "Days".localized()
                        let index = dataList.firstIndex(where: { $0["title"] as? String == dateString })
                        if let idx = index{
                            var firData = dataList[idx]
                            if var imgs = firData["imgs"] as? [UIImage],let img = UIImage(contentsOfFile: imgUrl),
                               var paths = firData["paths"] as? [String]{
                                imgs.append(img)
                                paths.append(png)
                                firData["imgs"] = imgs
                                firData["paths"] = paths
                                dataList[idx] = firData
                            }
                        
                        }else{
                            data["time"] = daysDifference
                            data["title"] = dateString
                            print("时间戳与当前日期相差 \(daysDifference) 天")
                            if let img = UIImage(contentsOfFile: imgUrl) {
                                let imgs : [UIImage] = [img]
                                let paths : [String] = [png]
                                data["imgs"] = imgs
                                data["paths"] = paths
                            }
                            dataList.append(data)
                        }
                    }else {
                        //删除图片
                        
                    }
                } else {
                    print("无法计算相差天数")
                }
            }
        }
        return dataList.sorted(by: { ($0["time"] as? Int  ?? 0) < ($1["time"] as? Int ?? 0) })
    }
    
    func loadLocalImgs() -> [String]{
        do {
            let fileManager : FileManager = FileManager.default
            let homeDirectory = NSHomeDirectory()
            let path = self.titleString == "History".localized() ? "Create" : "Deleted"
            let documentPath = homeDirectory + "/Documents/" + path
            let directoryURL = URL(fileURLWithPath: documentPath)
            let fileURLs = try fileManager.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            
            var pngFiles: [String] = []
            
            for fileURL in fileURLs {
                if fileURL.pathExtension.lowercased() == "png" {
                    pngFiles.append(fileURL.lastPathComponent)
                }
            }
            return pngFiles
        }catch {
            print("Error: \(error)")
            return []
        }
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.register(SPImageListTableViewCell.self, forCellReuseIdentifier: "SPImageListTableViewCell")
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 107
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
    
}

extension SPImageListViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SPImageListTableViewCell", for: indexPath) as! SPImageListTableViewCell
        if let title = dataList[indexPath.row]["title"] as? String, let imgs = dataList[indexPath.row]["imgs"] as? [UIImage] {
            cell.dateLabel.text = title
            cell.popArtImgs = imgs
            cell.collectionView.reloadData()
            cell.currentVC = self
            cell.data = dataList[indexPath.row]
            cell.backgroundColor = self.titleString == "History".localized() ? UIColor.hex(hexString: "#FACD56") : UIColor.hex(hexString: "5B79FF")
            cell.collectionView.backgroundColor = cell.backgroundColor
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let imgs = dataList[indexPath.row]["imgs"] as? [UIImage] {
            let count = imgs.count
            var row = 0
            if count % 3 == 0 {
                row = count / 3
            }else{
                row = count / 3 + 1
            }
            let height = (row - 1) * 112 + 169
            return CGFloat(height)
        }
        return 1
    }
    
}
