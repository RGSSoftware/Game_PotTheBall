//
//  GameOverViewController.h
//  PotTheBall
//
//  Created by PC on 7/10/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainGameBoardViewController.h"


@interface GameOverViewController : UIViewController

@property int score;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *highScoreLabel;
@property (weak, nonatomic) IBOutlet UIView *scoreBubbleView;

@property (nonatomic)GameMode gameMode;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *MenuButtons;

- (IBAction)share:(id)sender;
- (IBAction)restart:(id)sender;
- (IBAction)home:(id)sender;
- (IBAction)leaderboard:(id)sender;
@end
