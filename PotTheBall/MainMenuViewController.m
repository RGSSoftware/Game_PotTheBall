//
//  MainMenuViewController.m
//  PotTheBall
//
//  Created by PC on 6/28/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import "MainMenuViewController.h"

#import "ScreenDetact.h"

#import "UIColor+RGSColorWithHexString.h"
#import "UIImage+RGSinitWithColor.h"

#import "UIView+RGSConstraint.h"
#import "UIView+RGSFrame.h"

#import "GameKitHelper.h"

#import "NSString+RGSInt.h"

#import "MainGameBoardViewController.h"
#import "AdHelper.h"


@interface MainMenuViewController ()

@property GameMode isPlayGameMode;

@end

@implementation MainMenuViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.testButton.layer.cornerRadius = self.testButton.bounds.size.width /2;
    self.testButton.layer.masksToBounds = YES;
    
     [self.view sendSubviewToBack:self.topView];
    [self.view sendSubviewToBack:self.middleView];
   
}

-(void)viewWillAppear:(BOOL)animated{
//    self.topView.frame = self.middleView.frame;
//    [self.topView setFrameOriginY:CGRectGetMinY(self.topView.frame) - 200];
    
    
    [self.ballcountbutton setTitle:NSStringFromInt([[NSUbiquitousKeyValueStore defaultStore] doubleForKey:@"BonusBallsCount"])  forState:UIControlStateNormal];
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
    
    double rads = DEGREES_TO_RADIANS(10);
    CGAffineTransform transform = CGAffineTransformRotate(self.topView.transform, rads);
    self.topView.transform =  CGAffineTransformMakeRotation(rads);
    
}
-(void)viewDidAppear:(BOOL)animated{
    
}
-(void)viewDidLayoutSubviews{
    
    
    self.bonuseButton.layer.cornerRadius = self.bonuseButton.frame.size.height/2;
    self.bonuseButton.layer.borderWidth = 2;

    self.arcadeButton.layer.cornerRadius = self.arcadeButton.bounds.size.width/2;
    self.timeButton.layer.cornerRadius = self.timeButton.bounds.size.width/2;

    self.timeButton.layer.masksToBounds = YES;
    self.arcadeButton.layer.masksToBounds = YES;
    
    
//    self.topView.frame = self.middleView.frame;
//    [self.topView setFrameOriginY:CGRectGetMinY(self.topView.frame) - 200];
//    
//    
//    
//    #define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
//    
//    double rads = DEGREES_TO_RADIANS(-90);
//    CGAffineTransform transform = CGAffineTransformRotate(self.topView.transform, rads);
//    self.topView.transform =  CGAffineTransformMakeRotation(rads);
    
    self.bonuseButton.layer.borderColor = [UIColor colorWithHexString:@"515D6D"].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[MainGameBoardViewController class]]) {
        MainGameBoardViewController *gameBoardViewController = (MainGameBoardViewController *)segue.destinationViewController;
        gameBoardViewController.gameMode = self.isPlayGameMode;
        gameBoardViewController.gameState = GameStatePrepareStart;
    }
}

- (IBAction)showLeaderboard:(id)sender {
    [self presentViewController:[[GameKitHelper sharedManager] leaderboardViewController] animated:YES completion:nil];
}

- (IBAction)rate:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/app/%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"App_ID"]]]];
}

- (IBAction)moreGames:(id)sender {
    [[AdHelper sharedManager] showMoreGames];
}

- (IBAction)playTimeAttack:(id)sender {
    self.isPlayGameMode = GameModeTimeAttack;
    [self performSegueWithIdentifier:@"toMainGameBoard" sender:self];
}

- (IBAction)playArcade:(id)sender {
    self.isPlayGameMode = GameModeArcade;
    [self performSegueWithIdentifier:@"toMainGameBoard" sender:self];
}

-(IBAction)unwindToMainMenu:(UIStoryboardSegue *)segue {
}


@end
