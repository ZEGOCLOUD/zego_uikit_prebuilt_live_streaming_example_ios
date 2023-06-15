//
//  ViewController.swift
//  ZegoUIKitPrebuiltLiveStreaming
//
//  Created by zego on 2022/8/22.
//

import UIKit
import ZegoUIKit
import ZegoUIKitPrebuiltLiveStreaming

class ViewController: UIViewController {
    
    let appID: UInt32 = <#YourAppID#>
    let appSign: String = <#YourAppSign#>
    
    @IBOutlet weak var roomIDTextField: UITextField! {
        didSet {
            let roomID: UInt32 = arc4random() % 999999
            roomIDTextField.text = String(format: "%d", roomID)
        }
    }
    
    let userID: String = String(format: "%d", arc4random() % 999999)
    var userName: String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.userName = String(format: "n_%@", self.userID)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func startLive(_ sender: Any) {
        let config: ZegoUIKitPrebuiltLiveStreamingConfig = ZegoUIKitPrebuiltLiveStreamingConfig.host()
        let liveVC: ZegoUIKitPrebuiltLiveStreamingVC = ZegoUIKitPrebuiltLiveStreamingVC(self.appID, appSign: self.appSign, userID: self.userID, userName: self.userName ?? "", liveID: self.roomIDTextField.text ?? "", config: config)
        liveVC.modalPresentationStyle = .fullScreen
        self.present(liveVC, animated: true, completion: nil)
    }
    
    @IBAction func watchLive(_ sender: Any) {
        let config: ZegoUIKitPrebuiltLiveStreamingConfig = ZegoUIKitPrebuiltLiveStreamingConfig.audience()
        let liveVC: ZegoUIKitPrebuiltLiveStreamingVC = ZegoUIKitPrebuiltLiveStreamingVC(self.appID, appSign: self.appSign, userID: self.userID, userName: self.userName ?? "", liveID: self.roomIDTextField.text ?? "", config: config)
        liveVC.modalPresentationStyle = .fullScreen
        self.present(liveVC, animated: true, completion: nil)
    }

}

