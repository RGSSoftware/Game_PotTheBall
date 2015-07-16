//
//  GameOverViewController.m
//  PotTheBall
//
//  Created by PC on 7/10/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import "GameOverViewController.h"

#import "NSString+RGSInt.h"

#import "MainGameBoardViewController.h"
#import "GameKitHelper.h"

#import "AdHelper.h"

#import <BlocksKit/BlocksKit.h>

@interface GameOverViewController ()

@end

@implementation GameOverViewController


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.destinationViewController isKindOfClass:[MainGameBoardViewController class]]) {
        MainGameBoardViewController *gameBoardViewController = (MainGameBoardViewController *)segue.destinationViewController;
        gameBoardViewController.gameState = GameStatePrepareStart;
    }
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    [NSTimer bk_scheduledTimerWithTimeInterval:0.1 block:^(NSTimer *timer) {
        if ([AdHelper shouldShowInterstitialOnGameOver]) {
            if ([AdHelper shouldShowAdmobInterstitialOnGameOver]) {
                [[AdHelper sharedManager] showAdmobInterstitial];
            }
            if ([AdHelper shouldShowChartboostInterstitialOnGameOver]) {
                [[AdHelper sharedManager] showChartboostGameOverInterstitial];
            }
            
        }
//    } repeats:NO];
   
    if ([AdHelper shouldShowRewardAfterGameOver]) {
        [self performSegueWithIdentifier:@"fromGameOverToRewards" sender:self];
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.scoreLabel.text = NSStringFromInt(self.score);
    self.messageLabel.text = @"TRAIN MORE!";
    
    int highScore;
    if (self.gameMode == GameModeTimeAttack) {
        highScore = [[GameKitHelper sharedManager] timeModeHighScore];
        if (self.score > highScore) {
            [[GameKitHelper sharedManager] reportTimeModeHighScore:self.score];
            highScore = self.score;
            self.messageLabel.text = @"AWESOME!";
        }
        
    } else if (self.gameMode == GameModeArcade) {
        highScore = [[GameKitHelper sharedManager] arcadeModeHighScore];
        if (self.score > highScore) {
            [[GameKitHelper sharedManager] reportArcadeModeHighScore:self.score];
            highScore = self.score;
            self.messageLabel.text = @"AWESOME!";
        }
       
    }
    self.highScoreLabel.text = NSStringFromInt(highScore);
    
    
}
-(void)viewDidLayoutSubviews{
    
    for (UIView *view in self.MenuButtons) {
        view.layer.cornerRadius = view.bounds.size.width/2;
    }
    
    self.scoreBubbleView.layer.cornerRadius = self.scoreBubbleView.bounds.size.height/2;
    
}

- (IBAction)restart:(id)sender {
    [self performSegueWithIdentifier:@"unwindFromGameOverMenuToGameBoard" sender:self];
}

- (IBAction)home:(id)sender {
    [self performSegueWithIdentifier:@"unwindFromGameOverMenuToMainMenu" sender:self];
}

- (IBAction)leaderboard:(id)sender {
    if (self.gameMode == GameModeTimeAttack) {
        [self presentViewController:[[GameKitHelper sharedManager] timeModeleaderboardViewController] animated:YES completion:nil];
    } else if (self.gameMode == GameModeArcade) {
        [self presentViewController:[[GameKitHelper sharedManager] arcadeModeleaderboardViewController] animated:YES completion:nil];
    }
}
@end
