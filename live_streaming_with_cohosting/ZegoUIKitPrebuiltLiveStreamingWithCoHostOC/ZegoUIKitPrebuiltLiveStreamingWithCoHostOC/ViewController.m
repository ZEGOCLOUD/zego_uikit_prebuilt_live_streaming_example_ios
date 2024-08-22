//
//  ViewController.m
//  ZegoUIKitPrebuiltLiveStreamingWithCoHostOC
//
//  Created by zego on 2024/5/28.
//

#import "ViewController.h"

@import ZegoUIKit;
@import ZegoUIKitPrebuiltLiveStreaming;
@import ZegoUIKitSignalingPlugin;


@interface ViewController ()<ZegoUIKitPrebuiltLiveStreamingVCDelegate>
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *appSign;
@property (nonatomic, assign) unsigned int appID;

@property (weak, nonatomic) IBOutlet UITextField *roomIDTextField;
@property (weak, nonatomic) IBOutlet UISwitch *aspectFillSwitch;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.userID = [NSString stringWithFormat:@"%u",arc4random() % 99999];
  self.userName = [NSString stringWithFormat:@"name_%@",self.userID];
  self.appID = <#APPID#>;
  self.appSign = @"<#APPSIGN#>";
  self.roomIDTextField.text = [NSString stringWithFormat:@"%u",arc4random() % 99999];
}

- (IBAction)startLive:(id)sender {
  ZegoUIKitPrebuiltLiveStreamingConfig *config = [ZegoUIKitPrebuiltLiveStreamingConfig hostWithEnableSignalingPlugin:YES];
  
  ZegoPrebuiltAudioVideoViewConfig * audioVideoViewConfig = [[ZegoPrebuiltAudioVideoViewConfig alloc] init];
  audioVideoViewConfig.useVideoViewAspectFill = self.aspectFillSwitch.on;
  config.audioVideoViewConfig = audioVideoViewConfig;
  config.enableCoHosting = YES;
  ZegoUIKitPrebuiltLiveStreamingVC * vc = [[ZegoUIKitPrebuiltLiveStreamingVC alloc] init:self.appID appSign:self.appSign userID:self.userID userName:self.userName liveID:self.roomIDTextField.text config:config];
  vc.delegate = self;
  vc.modalPresentationStyle = UIModalPresentationFullScreen;
  [self presentViewController:vc animated:YES completion:^{
    
  }];
}

- (IBAction)watchLive:(id)sender {
  
  ZegoUIKitPrebuiltLiveStreamingConfig *config = [ZegoUIKitPrebuiltLiveStreamingConfig audienceWithEnableSignalingPlugin:YES];
  ZegoPrebuiltAudioVideoViewConfig * audioVideoViewConfig = [[ZegoPrebuiltAudioVideoViewConfig alloc] init];
  audioVideoViewConfig.useVideoViewAspectFill = self.aspectFillSwitch.on;
  config.audioVideoViewConfig = audioVideoViewConfig;
  config.enableCoHosting = YES;
  ZegoUIKitPrebuiltLiveStreamingVC * vc = [[ZegoUIKitPrebuiltLiveStreamingVC alloc] init:self.appID appSign:self.appSign userID:self.userID userName:self.userName liveID:self.roomIDTextField.text config:config];
  vc.delegate = self;
  vc.modalPresentationStyle = UIModalPresentationFullScreen;
  [self presentViewController:vc animated:YES completion:^{
    
  }];
}

#pragma mark - ZegoUIKitPrebuiltLiveStreamingVCDelegate

@end
