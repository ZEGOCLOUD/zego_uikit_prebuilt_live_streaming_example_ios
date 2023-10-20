//
//  MutePKUserButton.swift
//  ZegoUIKitPrebuiltLiveStreamingDemo
//
//  Created by zego on 2023/10/9.
//

import UIKit
import ZegoUIKitPrebuiltLiveStreaming

class MutePKUserButton: UIButton, ZegoLiveStreamingManagerDelegate {

    override init(frame: CGRect) {
        super.init(frame: frame)
        ZegoLiveStreamingManager.shared.addLiveManagerDelegate(self)
        self.setTitle("mute", for: .normal)
        self.setTitle("unMute", for: .selected)
        self.addTarget(self, action: #selector(muteButtonClick), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func muteButtonClick(_ sender: UIButton) {
        let pkUserMuted: Bool = ZegoLiveStreamingManager.shared.isAnotherHostMuted
        ZegoLiveStreamingManager.shared.muteAnotherHostAudio(!pkUserMuted, callback: nil)
    }
    
    func onOtherHostMuted(userID: String, mute: Bool) {
        self.isSelected = mute
    }

}
