//
//  StoreInventoryViewController.h
//  PotTheBall
//
//  Created by PC on 7/2/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreInventoryViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *overlayView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *priceButtons;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *powerBallImages;
- (IBAction)close:(id)sender;
- (IBAction)buyBonuses:(id)sender;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *allViews;
@end
