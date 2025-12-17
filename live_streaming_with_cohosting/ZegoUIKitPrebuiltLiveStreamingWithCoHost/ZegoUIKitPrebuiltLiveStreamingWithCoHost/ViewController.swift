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
    
    // UI Elements
    let liveIDTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.placeholder = "Live ID"
        return textField
    }()
    
    let useVideoAspectFillLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.text = "useVideoAspectFill"
        return label
    }()
    
    let liveIDLabel: UILabel = {
        let label = UILabel()
        label.text = "LiveID"
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    let startLiveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start a live", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        return button
    }()
    
    let watchLiveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Watch a live", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        return button
    }()
    
    let useVideoAspectFillSwitch: UISwitch = {
        let toggleSwitch = UISwitch()
        toggleSwitch.isOn = true
        return toggleSwitch
    }()
    
    let versionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }()
    
    var isUseVideoAspectFill: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.userName = String(format: "n_%@", self.userID)
        
        // Initialize UI elements
        setupUI()
        
        // Set initial live ID
        let liveID: UInt32 = arc4random() % 999999
        liveIDTextField.text = String(format: "%d", liveID)
        
        // Set initial aspect fill status
        useVideoAspectFillSwitch.setOn(true, animated: true)
        
        // Add button actions
        startLiveButton.addTarget(self, action: #selector(startLiveButtonClick(_:)), for: .touchUpInside)
        watchLiveButton.addTarget(self, action: #selector(watchLiveButtonClick(_:)), for: .touchUpInside)
        useVideoAspectFillSwitch.addTarget(self, action: #selector(useVideoAspectFillClick(_:)), for: .valueChanged)
        
        // Get version number and PrebuiltUseForWhere
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        let useForWhere = Bundle.main.infoDictionary?["PrebuiltUseForWhere"] as? String ?? ""
        versionLabel.text = "Ver: \(version ?? "") (\(build ?? "")) \(useForWhere)"
    }
    
    func setupUI() {
        // Add UI elements to view
        [liveIDTextField, useVideoAspectFillLabel, liveIDLabel, startLiveButton, watchLiveButton, useVideoAspectFillSwitch, versionLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        // Set constraints
        NSLayoutConstraint.activate([
            // useVideoAspectFillLabel
            useVideoAspectFillLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 65),
            useVideoAspectFillLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 193),

            // useVideoAspectFillSwitch
            useVideoAspectFillSwitch.leadingAnchor.constraint(equalTo: useVideoAspectFillLabel.trailingAnchor, constant: 65),
            useVideoAspectFillSwitch.centerYAnchor.constraint(equalTo: useVideoAspectFillLabel.centerYAnchor),
            
            // liveIDLabel
            liveIDLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 99),
            liveIDLabel.topAnchor.constraint(equalTo: useVideoAspectFillSwitch.bottomAnchor, constant: 33),
            
            // liveIDTextField
            liveIDTextField.leadingAnchor.constraint(equalTo: liveIDLabel.trailingAnchor, constant: 18),
            liveIDTextField.centerYAnchor.constraint(equalTo: liveIDLabel.centerYAnchor),
            liveIDTextField.widthAnchor.constraint(equalToConstant: 97),
            liveIDTextField.heightAnchor.constraint(equalToConstant: 34),
            
            // startLiveButton
            startLiveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startLiveButton.topAnchor.constraint(equalTo: liveIDTextField.bottomAnchor, constant: 48),
            startLiveButton.widthAnchor.constraint(equalToConstant: 93),
            startLiveButton.heightAnchor.constraint(equalToConstant: 31),
            
            // watchLiveButton
            watchLiveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            watchLiveButton.topAnchor.constraint(equalTo: startLiveButton.bottomAnchor, constant: 19),
            watchLiveButton.widthAnchor.constraint(equalToConstant: 102),
            watchLiveButton.heightAnchor.constraint(equalToConstant: 31),
            
            // versionLabel
            versionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            versionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    @IBAction func useVideoAspectFillClick(_ sender: Any) {
        if let toggleSwitch = sender as? UISwitch {
            isUseVideoAspectFill = toggleSwitch.isOn
        }
    }

    @IBAction func startLiveButtonClick(_ sender: Any) {
        let config = ZegoUIKitPrebuiltLiveStreamingConfig.host(enableSignalingPlugin: true)
        let audioVideoConfig = ZegoLiveStreamingAudioVideoViewConfig()
        audioVideoConfig.useVideoViewAspectFill = isUseVideoAspectFill
        config.audioVideoViewConfig = audioVideoConfig
        config.enableCoHosting = true
        let liveVC = ZegoUIKitPrebuiltLiveStreamingVC(KeyCenter.appID, appSign: KeyCenter.appSign, userID: self.userID, userName: self.userName ?? "", liveID: self.liveIDTextField.text ?? "", config: config)
        liveVC.modalPresentationStyle = .fullScreen
        self.present(liveVC, animated: true, completion: nil)
    }
    
    @IBAction func watchLiveButtonClick(_ sender: Any) {
        let config = ZegoUIKitPrebuiltLiveStreamingConfig.audience(enableSignalingPlugin: true)
        let audioVideoConfig = ZegoLiveStreamingAudioVideoViewConfig()
        audioVideoConfig.useVideoViewAspectFill = isUseVideoAspectFill
        config.audioVideoViewConfig = audioVideoConfig
        config.enableCoHosting = true
        let liveVC = ZegoUIKitPrebuiltLiveStreamingVC(KeyCenter.appID, appSign: KeyCenter.appSign, userID: self.userID, userName: self.userName ?? "", liveID: self.liveIDTextField.text ?? "", config: config)
        liveVC.modalPresentationStyle = .fullScreen
        self.present(liveVC, animated: true, completion: nil)
    }
    
}

