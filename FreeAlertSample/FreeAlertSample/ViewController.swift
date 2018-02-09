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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showImageAlert(_ sender: Any) {
        let imgView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 300, height: 150))
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage.init(named: "test")
    
        FreeAlert.shared.show(in: self, alertTitle: "Image Alert", alertMessage: "Im a alert with UIImageView", additionView: imgView, okInfo: ("Ok", {
            print("Ok Button Tapped.")
        }), cancelInfo: ("Cancel", {
            print("Cancel Button Tapped.")
        }))
    }
    
}

