//
//  StoreViewController.m
//  PotTheBall
//
//  Created by PC on 7/2/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import "StoreViewController.h"
#import "ScreenDetact.h"
#import "AdHelper.h"
@interface StoreViewController ()

@end

@implementation StoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    if (IS_IPAD) {
        
        [self.powerBallImage setImage:[UIImage imageNamed:@"powerBall_IPad"]];
        
        [self.videoButton setImage:[UIImage imageNamed:@"playVideo_IPad"] forState:UIControlStateNormal];
        [self.facebookButton setImage:[UIImage imageNamed:@"facebook_IPad"] forState:UIControlStateNormal];
        [self.twitterButton setImage:[UIImage imageNamed:@"twitter_IPad"] forState:UIControlStateNormal];
        
        [self.backArrow  setImage:[UIImage imageNamed:@"backArrow_IPad"] forState:UIControlStateNormal];

        self.lineView.layer.cornerRadius = 2;

    } else {

        self.lineView.layer.cornerRadius = 1;

    }
    
    self.purchaseButton.layer.cornerRadius = self.purchaseButton.frame.size.height/2;
    
    
    self.videoButton.layer.cornerRadius = self.videoButton.bounds.size.width/2;
    self.facebookButton.layer.cornerRadius = self.facebookButton.bounds.size.width/2;
    
    self.twitterButton.layer.cornerRadius = self.twitterButton.bounds.size.width/2;
    
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)showStoreInventory:(id)sender {
}

- (IBAction)showVideo:(id)sender {
}

- (IBAction)showFacebook:(id)sender {
       
}
- (IBAction)showTwitter:(id)sender {
}
@end
