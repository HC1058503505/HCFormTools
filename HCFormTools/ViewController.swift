//
//  ViewController.swift
//  HCFormTools
//
//  Created by UltraPower on 2017/6/14.
//  Copyright © 2017年 UltraPower. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var pieCharV: HCPieChartView = {
        let pieChartView = HCPieChartView(frame: CGRect(x: 0, y: 20, width: self.view.bounds.width, height: 400))
        pieChartView.backgroundColor = UIColor.orange
        pieChartView.dataList = [2.5,3.6,4.36,56.12,7.85]
        return pieChartView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.addSubview(pieCharV)
        pieCharV.centerP = pieCharV.center
        let addBtn:UIButton = UIButton(type: .custom)
        addBtn.setTitle("添加数据", for: .normal)
        addBtn.setTitleColor(UIColor.white, for: .normal)
        addBtn.backgroundColor = UIColor.orange
        addBtn.frame = CGRect(x: 20, y: pieCharV.frame.maxY + 20, width: 40, height: 60)
        addBtn.sizeToFit()
        addBtn.addTarget(self, action: #selector(ViewController.addBtnAction), for: .touchUpInside)
        view.addSubview(addBtn)
        
        
        let delBtn:UIButton = UIButton(type: .custom)
        delBtn.setTitle("删除数据", for: .normal)
        delBtn.setTitleColor(UIColor.white, for: .normal)
        delBtn.backgroundColor = UIColor.orange
        delBtn.frame = CGRect(x: 20, y: addBtn.frame.maxY + 20, width: 40, height: 60)
        delBtn.sizeToFit()
        delBtn.addTarget(self, action: #selector(ViewController.delBtnAction), for: .touchUpInside)
        view.addSubview(delBtn)
        
    }
    
    func addBtnAction() {
        pieCharV.dataList.append(32.58)
    }
    
    func delBtnAction() {
        if (!pieCharV.dataList.isEmpty) {
            pieCharV.dataList.removeLast()
        }
    }
}

