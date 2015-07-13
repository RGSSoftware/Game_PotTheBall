//
//  RewardAlertViewController.h
//  PotTheBall
//
//  Created by PC on 7/13/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RewardAlertViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *overlayView;

- (IBAction)showVideo:(id)sender;
- (IBAction)close:(id)sender;

@end
