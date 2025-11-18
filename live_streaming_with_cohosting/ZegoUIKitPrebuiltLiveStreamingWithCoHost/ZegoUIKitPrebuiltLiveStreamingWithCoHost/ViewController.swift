//
//  ViewController.swift
//  ZegoUIKitPrebuiltLiveStreamingWithCoHost
//
//  Created by zego on 2022/11/22.
//

import UIKit
import ZegoUIKit
import ZegoUIKitPrebuiltLiveStreaming
import ZegoUIKitSignalingPlugin

class ViewController: UIViewController {
    
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
        let config = ZegoUIKitPrebuiltLiveStreamingConfig.host(enableSignalingPlugin: true)
        let audioVideoConfig = ZegoLiveStreamingAudioVideoViewConfig()
        audioVideoConfig.useVideoViewAspectFill = useVideoAspectFill
        config.audioVideoViewConfig = audioVideoConfig
        config.enableCoHosting = true
        let liveVC = ZegoUIKitPrebuiltLiveStreamingVC(KeyCenter.appID, appSign: KeyCenter.appSign, userID: self.userID, userName: self.userName ?? "", liveID: self.liveIDTextField.text ?? "", config: config)
        liveVC.modalPresentationStyle = .fullScreen
        self.present(liveVC, animated: true, completion: nil)
    }
    
    @IBAction func watchLiveButtonClick(_ sender: Any) {
        let config = ZegoUIKitPrebuiltLiveStreamingConfig.audience(enableSignalingPlugin: true)
        let audioVideoConfig = ZegoLiveStreamingAudioVideoViewConfig()
        audioVideoConfig.useVideoViewAspectFill = useVideoAspectFill
        config.audioVideoViewConfig = audioVideoConfig
        config.enableCoHosting = true
        let liveVC = ZegoUIKitPrebuiltLiveStreamingVC(KeyCenter.appID, appSign: KeyCenter.appSign, userID: self.userID, userName: self.userName ?? "", liveID: self.liveIDTextField.text ?? "", config: config)
        liveVC.modalPresentationStyle = .fullScreen
        self.present(liveVC, animated: true, completion: nil)
    }
    
    @IBAction func useVideoAspectFillClick(_ sender: Any) {
        useVideoAspectFill = !useVideoAspectFill
    }
    
}

