//
//  MainMenuViewController.h
//  PotTheBall
//
//  Created by PC on 6/28/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GameKit;

@interface MainMenuViewController : UIViewController <GKGameCenterControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *timeButton;
@property (weak, nonatomic) IBOutlet UIButton *arcadeButton;
@property (weak, nonatomic) IBOutlet UIButton *testButton;

@property (weak, nonatomic) IBOutlet UIButton *bonuseButton;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIButton *gameCenterButton;
@property (weak, nonatomic) IBOutlet UIButton *settingButton;
@property (weak, nonatomic) IBOutlet UIButton *ballcountbutton;

- (IBAction)showLeaderboard:(id)sender;

- (IBAction)reportScore:(UIButton *)sender;
- (IBAction)rate:(id)sender;
- (IBAction)moreGames:(id)sender;

- (IBAction)playTimeAttack:(id)sender;
- (IBAction)playArcade:(id)sender;
@end
