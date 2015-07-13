//
//  ShareViewController.h
//  PotTheBall
//
//  Created by PC on 7/12/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MessageUI/MessageUI.h>

@interface ShareViewController : UIViewController <MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *overlayView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *shareButtons;

- (IBAction)shareWithFacebook:(id)sender;
- (IBAction)shareWithTwitter:(id)sender;
- (IBAction)shareWithEmail:(id)sender;

- (IBAction)close:(id)sender;
@end
