//
//  ViewController.swift
//  ZegoUIKitPrebuiltLiveStreamingWithPKBattle
//
//  Created by zego on 2023/10/20.
//

import UIKit
import ZegoUIKit
import ZegoUIKitPrebuiltLiveStreaming
import ZegoUIKitSignalingPlugin
import Toast_Swift

class ViewController: UIViewController {
    
    let appID: UInt32 = <#YourAppID#>
    let appSign: String = <#YourAppSign#>
    let liveManager = ZegoLiveStreamingManager.shared
    var pkButton: PKButton?
    
    var userID: String?
    var userName: String?
    
    weak var uikitLiveVC: ZegoUIKitPrebuiltLiveStreamingVC?
    
    
    @IBOutlet weak var liveIDTextField: UITextField! {
        didSet {
            let roomID: UInt32 = arc4random() % 999999
            liveIDTextField.text = String(format: "%d", roomID)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let localUserID = UserDefaults.standard.string(forKey: "localUserID") {
            userID = localUserID
        } else {
            userID = String(format: "%d", arc4random() % 999999)
            UserDefaults.standard.set(userID, forKey: "localUserID")
        }
        self.userName = String(format: "n_%@", self.userID!)
        liveManager.addLiveManagerDelegate(self)
    }
    
    
    @IBAction func startLiveClick(_ sender: Any) {
        let config: ZegoUIKitPrebuiltLiveStreamingConfig = ZegoUIKitPrebuiltLiveStreamingConfig.host(enableCoHosting: true)
        let liveVC: ZegoUIKitPrebuiltLiveStreamingVC = ZegoUIKitPrebuiltLiveStreamingVC(self.appID, appSign: self.appSign, userID: self.userID ?? "", userName: self.userName ?? "", liveID: self.liveIDTextField.text ?? "", config: config)
        uikitLiveVC = liveVC
        liveVC.modalPresentationStyle = .fullScreen
        liveVC.delegate = self
        liveVC.addButtonToBottomMenuBar(createRequestPKButton(), role: .host)
        self.present(liveVC, animated: true, completion: nil)
    }
    
    func createRequestPKButton() -> UIButton {
        pkButton = PKButton(type: .custom)
        pkButton!.controller = self.uikitLiveVC
        pkButton!.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        pkButton!.titleLabel?.textColor = UIColor.white
        pkButton!.layer.masksToBounds = true
        pkButton!.layer.cornerRadius = 18
        pkButton!.bounds = CGRect(x: 0, y: 0, width: 100, height: 40)
        pkButton!.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        return pkButton!
    }
    
    
    @IBAction func watchLiveClick(_ sender: Any) {
        let config: ZegoUIKitPrebuiltLiveStreamingConfig = ZegoUIKitPrebuiltLiveStreamingConfig.audience(enableCoHosting: true)
        let liveVC: ZegoUIKitPrebuiltLiveStreamingVC = ZegoUIKitPrebuiltLiveStreamingVC(self.appID, appSign: self.appSign, userID: self.userID ?? "", userName: self.userName ?? "", liveID: self.liveIDTextField.text ?? "", config: config)
        liveVC.modalPresentationStyle = .fullScreen
        liveVC.delegate = self
        self.present(liveVC, animated: true, completion: nil)
    }

}

extension ViewController: ZegoUIKitPrebuiltLiveStreamingVCDelegate, ZegoLiveStreamingManagerDelegate {
    
    func onMixerStreamTaskFail(errorCode: Int) {
        self.view.makeToast("mixer stream fail:\(errorCode)", position: .center)
    }
    
    func onOutgoingPKRequestTimeout(requestID: String, anotherHost: ZegoUIKitUser) {
        uikitLiveVC?.view.makeToast("send pk timeout", position: .center)
    }
    
    
    func onOutgoingPKRequestRejected(reason: Int, anotherHostUser: ZegoUIKitUser) {
        uikitLiveVC?.view.makeToast("send pk is rejected",position: .center)
    }
    
    func getPKBattleForegroundView(_ parentView: UIView, userInfo: ZegoUIKitUser) -> UIView? {
        let view = UIView()
        let button: MutePKUserButton = MutePKUserButton()
        button.frame = CGRect(x: 30, y: 30, width: 80, height: 40)
        view.addSubview(button)
        return view
    }
    
    func getPKBattleTopView(_ parentView: UIView, userList: [ZegoUIKitUser]) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.red
        return view
    }
    
    func getPKBattleBottomView(_ parentView: UIView, userList: [ZegoUIKitUser]) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.blue
        return view
    }
}

