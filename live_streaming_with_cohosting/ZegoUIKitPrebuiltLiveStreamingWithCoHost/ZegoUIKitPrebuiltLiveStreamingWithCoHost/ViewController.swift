//
//  ViewController.swift
//  ZegoUIKitPrebuiltLiveStreamingWithCoHost
//
//  Created by zego on 2022/11/22.
//

import UIKit
import ZegoUIKitSDK
import ZegoUIKitPrebuiltLiveStreaming
import ZegoUIKitSignalingPlugin

class ViewController: UIViewController {
    
    let appID: UInt32 = <#YourAppID#>
    let appSign: String = <#YourAppSign#>
    
    let userID: String = String(format: "%d", arc4random() % 999999)
    var userName: String?
    
    @IBOutlet weak var liveIDTextField: UITextField! {
        didSet {
            let liveID: UInt32 = arc4random() % 999999
            liveIDTextField.text = String(format: "%d", liveID)
        }
    }
    
    @IBOutlet weak var useVideoAspectFillLabel: UILabel! {
        didSet {
            if useVideoAspectFill {
                useVideoAspectFillLabel.text = "true"
            } else {
                useVideoAspectFillLabel.text = "false"
            }
        }
    }
    var useVideoAspectFill: Bool = true {
        didSet {
            if useVideoAspectFill {
                useVideoAspectFillLabel.text = "true"
            } else {
                useVideoAspectFillLabel.text = "false"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.userName = String(format: "n_%@", self.userID)
    }

    @IBAction func startLiveButtonClick(_ sender: Any) {
        let config: ZegoUIKitPrebuiltLiveStreamingConfig = ZegoUIKitPrebuiltLiveStreamingConfig.host(enableCoHosting: true)
        let audioVideoConfig = ZegoPrebuiltAudioVideoViewConfig()
        audioVideoConfig.useVideoViewAspectFill = useVideoAspectFill
        config.audioVideoViewConfig = audioVideoConfig
        let liveVC: ZegoUIKitPrebuiltLiveStreamingVC = ZegoUIKitPrebuiltLiveStreamingVC(self.appID, appSign: self.appSign, userID: self.userID, userName: self.userName ?? "", liveID: self.liveIDTextField.text ?? "", config: config)
        liveVC.modalPresentationStyle = .fullScreen
        self.present(liveVC, animated: true, completion: nil)
    }
    
    @IBAction func watchLiveButtonClick(_ sender: Any) {
        let config: ZegoUIKitPrebuiltLiveStreamingConfig = ZegoUIKitPrebuiltLiveStreamingConfig.audience(enableCoHosting: true)
        let audioVideoConfig = ZegoPrebuiltAudioVideoViewConfig()
        audioVideoConfig.useVideoViewAspectFill = useVideoAspectFill
        config.audioVideoViewConfig = audioVideoConfig
        let liveVC: ZegoUIKitPrebuiltLiveStreamingVC = ZegoUIKitPrebuiltLiveStreamingVC(self.appID, appSign: self.appSign, userID: self.userID, userName: self.userName ?? "", liveID: self.liveIDTextField.text ?? "", config: config)
        liveVC.modalPresentationStyle = .fullScreen
        self.present(liveVC, animated: true, completion: nil)
    }
    
    @IBAction func useVideoAspectFillClick(_ sender: Any) {
        useVideoAspectFill = !useVideoAspectFill
    }
    
}

