//
//  StoreViewController.h
//  PotTheBall
//
//  Created by PC on 7/2/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *backArrow;
@property (weak, nonatomic) IBOutlet UIImageView *powerBallImage;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UIButton *purchaseButton;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
- (IBAction)back:(id)sender;

- (IBAction)showStoreInventory:(id)sender;

- (IBAction)showVideo:(id)sender;
- (IBAction)showFacebook:(id)sender;
- (IBAction)showTwitter:(id)sender;
@end
