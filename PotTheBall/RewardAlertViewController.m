//
//  RewardAlertViewController.m
//  PotTheBall
//
//  Created by PC on 7/13/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import "RewardAlertViewController.h"
#import "AdHelper.h"

@interface RewardAlertViewController ()

@end

@implementation RewardAlertViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]];
    
}

-(void)viewDidLayoutSubviews{
    self.overlayView.layer.cornerRadius = 20;
}
-(void)handleTap:(UIGestureRecognizer *)gestureRecognizer{
    if (!CGRectContainsPoint(self.overlayView.frame,[gestureRecognizer locationInView:self.view])) {
        [self close:nil];
    }
}

- (IBAction)showVideo:(id)sender {
    [[AdHelper sharedManager] showRewardVideoWithSuccessBlock:^(BOOL success) {
        if (success) {
            //give 1 power ball
            double count = [[NSUbiquitousKeyValueStore defaultStore] doubleForKey:@"BonusBallsCount"];
            [[NSUbiquitousKeyValueStore defaultStore] setDouble:count + 1 forKey:@"BonusBallsCount"];
            [[NSUbiquitousKeyValueStore defaultStore] synchronize];
        }
    }];
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
