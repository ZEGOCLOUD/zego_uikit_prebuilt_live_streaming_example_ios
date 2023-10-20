//
//  PKButton.swift
//  ZegoUIKitPrebuiltLiveStreamingDemo
//
//  Created by zego on 2023/10/19.
//

import UIKit
import ZegoUIKitPrebuiltLiveStreaming
import Toast_Swift

class PKButton: UIButton {
    
    weak var controller: UIViewController? 

    override init(frame: CGRect) {
        super.init(frame: frame)
        ZegoLiveStreamingManager.shared.addLiveManagerDelegate(self)
        self.setTitle("PK", for: .normal)
        self.addTarget(self, action: #selector(pkButtonClick), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func pkButtonClick(_ sender: UIButton) {
        switch ZegoLiveStreamingManager.shared.pkState {
        case .isNoPK:
            sender.setTitle("Cancel", for: .normal)
            var userIDTextField:UITextField = UITextField()
            let pkAlterView: UIAlertController = UIAlertController(title: "request pk", message: nil, preferredStyle: .alert)
            let sureAction: UIAlertAction = UIAlertAction(title: "sure", style: .default) { [weak self] action in
                guard let userID = userIDTextField.text else {
                    return
                }
                ZegoLiveStreamingManager.shared.sendPKBattleRequest(anotherHostUserID: userID, callback: { errorCode, requestID in
                    if errorCode != 0 {
                        sender.setTitle("PK", for: .normal)
                        self?.controller?.view.makeToast("send pkBattle fail:\(errorCode)",duration: 1.0, position: .center)
                    }
                })
            }
            let cancelAction: UIAlertAction = UIAlertAction(title: "cancel ", style: .cancel) { action in
                sender.setTitle("PK", for: .normal)
            }
            pkAlterView.addTextField { textField in
                userIDTextField = textField
                userIDTextField.placeholder = "userID"
            }
            pkAlterView.addAction(sureAction)
            pkAlterView.addAction(cancelAction)
            controller?.present(pkAlterView, animated: true)
        case .isRequestPK:
            ZegoLiveStreamingManager.shared.cancelPKBattleRequest(customData: nil) { errorCode, requestID in
                sender.setTitle("PK", for: .normal)
            }
        case .isStartPK:
            ZegoLiveStreamingManager.shared.stopPKBattle()
            sender.setTitle("PK", for: .normal)
        }
    }

}

extension PKButton: ZegoLiveStreamingManagerDelegate {
    func onPKStarted(roomID: String, userID: String) {
        self.setTitle("End", for: .normal)
    }
    
    func onPKEnded() {
        self.setTitle("PK", for: .normal)
    }
    
    func onMixerStreamTaskFail(errorCode: Int) {
        if ZegoLiveStreamingManager.shared.pkState == .isStartPK {
            self.pkButtonClick(self)
        }
    }
    
    func onOutgoingPKRequestTimeout(requestID: String, anotherHost: ZegoUIKitUser) {
        self.setTitle("PK", for: .normal)
    }
    
    
    func onOutgoingPKRequestRejected(reason: Int, anotherHostUser: ZegoUIKitUser) {
        self.setTitle("PK", for: .normal)
    }
}
