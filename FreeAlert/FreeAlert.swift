//
//  FreeAlert.swift
//  CustomizeAlert
//
//  Created by wangzh on 2018/02/07.
//  Copyright © 2018年 cn.feilang. All rights reserved.
//

import UIKit

typealias ClickBlock = () -> Void
typealias ButtonInfo = (String, ClickBlock)

fileprivate var maxAlertWidth = CGFloat(270)
fileprivate var maxAlertHeight = CGFloat(300)

protocol FreeAlertProtocal {
    
    func show(in vc: UIViewController,
        alertTitle: String,
        alertMessage: String,
        additionView: UIView?,
        okInfo: ButtonInfo? ,
        cancelInfo: ButtonInfo?,
        tapDismissEnable: Bool
        )
    
    func hide()
}

class FreeAlert: UIViewController, FreeAlertProtocal {
    
    static let shared = FreeAlert()
    
    public init() {
        super.init(nibName: "FreeAlert", bundle: nil)
        loadXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: "FreeAlert", bundle: nil)
        loadXib()
    }
    
    func loadXib() {
        let _ = view
        modalPresentationStyle = .custom
        self.setCornerRadius(radius: 10.0)
        resetButtonTitle()
    }
    
    @IBOutlet var containerWidth: NSLayoutConstraint!
    @IBOutlet var additionViewHeight: NSLayoutConstraint!
    @IBOutlet var additionViewContainer: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var container: UIView!
    
    @IBOutlet var maskView: UIView!
    @IBOutlet var doubleOkButton: UIButton!
    @IBOutlet var doubleCancelButton: UIButton!
    @IBOutlet var singleOkButton: UIButton!
    @IBOutlet var backgroundTapGesture: UITapGestureRecognizer!
    
    @IBOutlet var vSeperatorLine: UIView!
    private var doubleOkInfo: ButtonInfo?
    private var doubleCancelInfo: ButtonInfo?
    private var singleOkInfo: ButtonInfo?
    private var additionView: UIView?
    
    func show(in vc: UIViewController,
                    alertTitle: String,
                    alertMessage: String,
                    additionView: UIView?,
                    okInfo: ButtonInfo? ,
                    cancelInfo: ButtonInfo?,
                    tapDismissEnable: Bool = false
        ) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.backgroundTapGesture.isEnabled = tapDismissEnable
            strongSelf.titleLabel.text = alertTitle
            strongSelf.messageLabel.text = alertMessage
            
            if let ok = okInfo, let cancel = cancelInfo {
                strongSelf.doubleOkButton.isHidden = false
                strongSelf.doubleOkButton .setTitle(ok.0, for: .normal)
                
                strongSelf.doubleCancelButton.isHidden = false
                strongSelf.doubleCancelButton .setTitle(cancel.0, for: .normal)
                
                strongSelf.singleOkButton.isHidden = true
                strongSelf.vSeperatorLine.isHidden = false
                strongSelf.doubleOkInfo = okInfo
                strongSelf.doubleCancelInfo = cancelInfo
            } else {
                strongSelf.doubleOkButton.isHidden = true
                strongSelf.doubleCancelButton.isHidden = true
                strongSelf.singleOkButton.isHidden = false
                strongSelf.vSeperatorLine.isHidden = true
                
                strongSelf.singleOkButton.setTitle(okInfo?.0 ?? "OK", for: .normal)
                strongSelf.singleOkInfo = okInfo
            }
            
            if let v = additionView {
                for v in strongSelf.additionViewContainer.subviews {
                    v.removeFromSuperview()
                }
                
                let addtionHeight = min(v.frame.size.height, maxAlertHeight)
                let addtionWidth = min(v.frame.size.width, maxAlertWidth)
                let x = (maxAlertWidth - addtionWidth) / 2
                v.frame = CGRect(x: x, y: 0, width: addtionWidth, height: addtionHeight)
                
                strongSelf.additionViewContainer.addSubview(v)
                strongSelf.additionViewHeight.constant = addtionHeight;
            } else {
                strongSelf.additionViewHeight.constant = 0;
            }
            
            vc.present(strongSelf, animated: false, completion: nil)
        }
    }
    
    func hide() {
        dismissAlert()
    }
   
    @IBAction func doubleOkAction(_ sender: Any) {
        if let ok = self.doubleOkInfo?.1 {
            dismissAlert(block: ok)
            return
        }
        dismissAlert()
    }
    
    @IBAction func doubleCancelAction(_ sender: Any) {
        if let cancel = self.doubleCancelInfo?.1 {
            dismissAlert(block: cancel)
            return
        }
        dismissAlert()
    }
    
    @IBAction func singleOkAction(_ sender: Any) {
        if let ok = self.singleOkInfo?.1 {
            dismissAlert(block: ok)
            return
        }
        dismissAlert()
    }
    
    @IBAction func backgroundTapAction(_ sender: Any) {
        dismissAlert()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.container.alpha = 1.0
        self.maskView.alpha = 0.0
        UIView.animate(withDuration: 0.3) {
            self.maskView.alpha = 0.15
        }
    }
    
    private func dismissAlert(block : @escaping ClickBlock = {}) {
        UIView.animate(withDuration: 0.3, animations: {
            self.maskView.alpha = 0.0
            self.container.alpha = 0.0
        }) { (finished) in
            self.dismiss(animated: false, completion: nil)
            block()
            self.resetButtonTitle()
        }
    }
    
    private func resetButtonTitle() {
        self.doubleOkButton.setTitle("", for: .normal)
        self.doubleCancelButton.setTitle("", for: .normal)
        self.singleOkButton.setTitle("", for: .normal)
    }
}

// Appearance
extension FreeAlert {
    
    static func appearance() -> FreeAlert {
        return FreeAlert.shared
    }
    
    
    func setCornerRadius(radius: CGFloat) {
        self.container.layer.cornerRadius = radius
    }
    
    func setTitleTextColor(color: UIColor) {
        self.titleLabel.textColor = color
    }
    
    func setTitleFont(font: UIFont) {
        self.titleLabel.font = font
    }
    
    func setMessageTitleColor(color: UIColor) {
        self.messageLabel.textColor = color
    }
    
    func setMessageFont(font: UIFont) {
        self.messageLabel.font = font
    }
    
    /// cannot bigger than screen width
    func setPreferredWidth(width: CGFloat) {
        let maxW = min(UIScreen.main.bounds.width, width)
        self.containerWidth.constant = maxW
        maxAlertWidth =  maxW
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
    func showSystemAlert(in viewcontroller: UIViewController) {
        let alert: UIAlertController = UIAlertController(title: "アラート表示", message: "保存してもいいですか？", preferredStyle:  UIAlertControllerStyle.alert)
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in
            print("OK")
        })
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        viewcontroller.present(alert, animated: true) {
            print("\(alert)")
        }
    }
 **/
}
