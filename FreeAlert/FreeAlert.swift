//
//  FreeAlert.swift
//  CustomizeAlert
//
//  Created by wangzh on 2018/02/07.
//  Copyright © 2018年 cn.feilang. All rights reserved.
//

import UIKit

public typealias ClickBlock = () -> Void
public typealias ButtonInfo = (String, ClickBlock)

fileprivate var maxAlertWidth = CGFloat(270)
fileprivate var maxAlertHeight = CGFloat(300)

let errorPrefix = "FreeAlert Error:"

public protocol FreeAlertProtocal {
    
    /// - Parameters:
    ///   - vc: If you have the given controller that you want present alert from, otherwise alert will present from the top controller of current application
    ///   - alertTitle: Title of your alert
    ///   - alertMessage: Message of you alert
    ///   - additionView: Your customize view that will show between message area and button area, if nil just show as system alert
    ///   - okInfo: The button title and action for your first button(buttonTitle: String, buttonAction: ClickBlock)
    ///   - cancelInfo: The button title and action for your second button(buttonTitle: String, buttonAction: ClickBlock)
    ///   - tapDismissEnable: If true, alert will dismiss when you tap the shadow area around alert
    func show(in vc: UIViewController?,
        alertTitle: String,
        alertMessage: String,
        additionView: UIView?,
        okInfo: ButtonInfo? ,
        cancelInfo: ButtonInfo?,
        tapDismissEnable: Bool
        )
    
    func hide()
}

public class FreeAlert: UIViewController, FreeAlertProtocal {
    
    public static let shared = FreeAlert()
    
    private init() {
        let bundle = Bundle(for: FreeAlert.classForCoder())
        super.init(nibName: "FreeAlert", bundle: bundle)
        loadXib()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(nibName: "FreeAlert", bundle: nil)
    }
    
    func loadXib() {
        let _ = view
        modalPresentationStyle = .custom
        self.setCornerRadius(radius: 10.0)
        self.maskView.alpha = 0.15
        resetViews()
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
    
    public func show(in vc: UIViewController? = nil,
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
                
                let addtionHeight = min(v.frame.size.height, maxAlertHeight)
                let addtionWidth = min(v.frame.size.width, maxAlertWidth)
                let x = (maxAlertWidth - addtionWidth) / 2
                v.frame = CGRect(x: x, y: 0, width: addtionWidth, height: addtionHeight)
                
                strongSelf.additionViewHeight.constant = addtionHeight;
                self?.view.layoutIfNeeded()
                
                strongSelf.additionViewContainer.addSubview(v)
            } else {
                strongSelf.additionViewHeight.constant = 0;
                self?.view.layoutIfNeeded()
            }
            
            if let givenVC = vc {
                if givenVC is FreeAlert {
                    // TODO:
                    debugPrint("\(errorPrefix) cannot present alert more than one")
                    return
                }
                givenVC.present(strongSelf, animated: false, completion: nil)
            } else {
                self?.topViewController?.present(strongSelf, animated: false, completion: nil)
            }
        }
    }
    
    public func hide() {
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
    
    override public func viewDidAppear(_ animated: Bool) {
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
            self.resetViews()
        }
    }
    
    private func resetViews() {
        self.doubleOkButton.setTitle("", for: .normal)
        self.doubleCancelButton.setTitle("", for: .normal)
        self.singleOkButton.setTitle("", for: .normal)
        
        for v in self.additionViewContainer.subviews {
            v.removeFromSuperview()
        }
    }
    
    // Get the top viewcontroller in current application
    var topViewController: UIViewController? {
        get {
            if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
                var resultVC = getTopVC(from: rootVC)
                while true  {
                    if let presented = resultVC?.presentedViewController {
                        resultVC = presented
                    } else {
                        break
                    }
                }
                return resultVC
            }
            return nil
        }
    }
    
    func getTopVC(from controller: UIViewController) -> UIViewController? {
        if controller is FreeAlert {
            // TODO:
            debugPrint("\(errorPrefix) cannot present alert more than one")
            return nil
        }
        
        if controller is UINavigationController {
            let nv = controller as! UINavigationController
            if let topOfNav = nv.topViewController {
                // TODO:
                debugPrint("\(errorPrefix) Current Navigation With out rootcontrollers")
                return topOfNav
            }
            return nil
        }
        
        if controller is UITabBarController {
            let tv = controller as! UITabBarController
            if let selectedVC = tv.selectedViewController {
                // TODO:
                debugPrint("\(errorPrefix) Current UITabBarController With out rootcontrollers")
                return selectedVC
            }
            return nil
        }
        
        return controller
    }
}

// Appearance
extension FreeAlert {
    
    public static func appearance() -> FreeAlert {
        return FreeAlert.shared
    }
    
    
    public func setCornerRadius(radius: CGFloat) {
        self.container.layer.cornerRadius = radius
    }
    
    public func setTitleTextColor(color: UIColor) {
        self.titleLabel.textColor = color
    }
    
    public func setTitleFont(font: UIFont) {
        self.titleLabel.font = font
    }
    
    public func setMessageTitleColor(color: UIColor) {
        self.messageLabel.textColor = color
    }
    
    public func setMessageFont(font: UIFont) {
        self.messageLabel.font = font
    }
    
    /// cannot bigger than screen width
    public func setPreferredWidth(width: CGFloat) {
        let maxW = min(UIScreen.main.bounds.width, width)
        self.containerWidth.constant = maxW
        maxAlertWidth =  maxW
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
