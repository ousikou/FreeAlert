//
//  ViewController.swift
//  FreeAlertSample
//
//  Created by wangzh on 2018/02/09.
//  Copyright © 2018年 cn.feilang. All rights reserved.
//

import UIKit
import FreeAlert

class ViewController: UIViewController {
    var tbVC: SampleTableVIewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showImageAlert(_ sender: Any) {
        // Create Customized View
        let imgView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 300, height: 150))
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage.init(named: "test")
    
        // Show Alert
        FreeAlert.shared.show(in: self,
                              alertTitle: "Image Alert",
                              alertMessage: "I'm a alert with UIImageView",
                              additionView: imgView,
                              okInfo: ("Ok", {
                                    print("Ok Button Tapped.")
                                }), cancelInfo: ("Cancel", {
                                    print("Cancel Button Tapped.")
                                }),tapDismissEnable: true)
    }
    
    @IBAction func showTableVIewAlert(_ sender: Any) {
        
        tbVC = SampleTableVIewController(nibName: "SampleTableVIewController", bundle: nil)
        tbVC.view.frame = CGRect(x: 0, y: 0, width: 300, height: 120)
        
        // Show Alert
        FreeAlert.shared.show(in: self,
                              alertTitle: "TableView Alert",
                              alertMessage: "I'm a TableView alert",
                              additionView: tbVC.view,
                              okInfo: ("Ok", {
                                print("Ok Button Tapped.")
                              }), cancelInfo: ("Cancel", {
                                print("Cancel Button Tapped.")
                              }),tapDismissEnable: true)
//        self.present(tbVC, animated: true, completion: nil)
    }
    
    @IBAction func showNormalAlert(_ sender: Any) {
        // Show Alert
        FreeAlert.shared.show(in: self,
                              alertTitle: "Normal Alert",
                              alertMessage: "I'm a Normal alert",
                              additionView: nil,
                              okInfo: ("Ok", {
                                print("Ok Button Tapped.")
                              }), cancelInfo: ("Cancel", {
                                print("Cancel Button Tapped.")
                              }),tapDismissEnable: true)
    }
    
    
}

