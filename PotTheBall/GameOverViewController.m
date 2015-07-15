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

@interface GameOverViewController ()

@end

@implementation GameOverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    
    if ([AdHelper shouldShowRewardAfterGameOver]) {
        [self performSegueWithIdentifier:@"fromGameOverToRewards" sender:self];
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.scoreLabel.text = NSStringFromInt(self.score);
}
-(void)viewDidLayoutSubviews{
    
    for (UIView *view in self.MenuButtons) {
        view.layer.cornerRadius = view.bounds.size.width/2;
    }
    
    self.scoreBubbleView.layer.cornerRadius = self.scoreBubbleView.bounds.size.height/2;
    
}


- (IBAction)share:(id)sender {
}

- (IBAction)restart:(id)sender {
    [self performSegueWithIdentifier:@"unwindFromGameOverMenuToGameBoard" sender:self];
}

- (IBAction)home:(id)sender {
    [self performSegueWithIdentifier:@"unwindFromGameOverMenuToMainMenu" sender:self];
}

- (IBAction)leaderboard:(id)sender {
    [self presentViewController:[[GameKitHelper sharedGameKitHelper] leaderboardViewController] animated:YES completion:nil];
}
@end
