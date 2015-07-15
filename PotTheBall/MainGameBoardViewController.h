//
//  ViewController.h
//  PotTheBall
//
//  Created by PC on 6/1/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GameState) {
    GameStatePrepareStart,
    GameStatePlaying
};

typedef NS_ENUM(NSUInteger, GameMode) {
    GameModeTimeAttack,
    GameModeArcade
};

@interface MainGameBoardViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *ball;
@property (weak, nonatomic) IBOutlet UIImageView *ring;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (nonatomic)GameState gameState;
@property (nonatomic)GameMode gameMode;


@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreStaticLabel;
@property (weak, nonatomic) IBOutlet UILabel *waveLabel;
@property (weak, nonatomic) IBOutlet UILabel *waveStaticLabel;
@property (weak, nonatomic) IBOutlet UILabel *countDownLabel;
@property (weak, nonatomic) IBOutlet UILabel *countDownStaticLabel;


- (IBAction)startGame:(id)sender;
- (IBAction)restartGame:(id)sender;

- (IBAction)home:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *bonusBalls;

- (IBAction)activateBonus:(id)sender;

@end

