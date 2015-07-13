//
//  SettingViewController.h
//  PotTheBall
//
//  Created by PC on 6/30/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *overlayView;
@property (weak, nonatomic) IBOutlet UIButton *soundButton;
@property (weak, nonatomic) IBOutlet UIButton *vibrationButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
- (IBAction)close:(id)sender;
- (IBAction)settingDidChange:(UIButton *)sender;
@end
