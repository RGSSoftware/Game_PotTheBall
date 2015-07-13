//
//  StoreInventoryViewController.m
//  PotTheBall
//
//  Created by PC on 7/2/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import "StoreInventoryViewController.h"
#import "ScreenDetact.h"
#import "IAPStore.h"

#import <MBProgressHUD/MBProgressHUD.h>

@interface StoreInventoryViewController ()

@end

@implementation StoreInventoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]];
    
    static NSNumberFormatter *currencyFormatter = nil;
    if (currencyFormatter == nil) {
        currencyFormatter = [NSNumberFormatter new];
        currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    }
    
    for (UIView *view in self.allViews) {
        view.hidden = YES;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading Store Inventory...";
    
    [[IAPStore sharedManager] loadProductsWithCompletionBlock:^(NSDictionary *products, NSError *error) {
        
        
        
        NSArray *productIdentifiers = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"IPA_ProductIdentifiers"];
        
        for (int i = 0; i < self.priceButtons.count; i++) {
            for (UIButton *priceButton in self.priceButtons) {
                if (priceButton.tag == i) {
                    SKProduct *product = (SKProduct *)[products objectForKey:productIdentifiers[i]];
                    currencyFormatter.locale = product.priceLocale;
                    [priceButton setTitle:[currencyFormatter stringFromNumber:@(product.price.floatValue)] forState:UIControlStateNormal];
                }
            }
        }
        
        for (UIView *view in self.allViews) {
            view.hidden = NO;
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
   
    
}

-(void)handleTap:(UIGestureRecognizer *)gestureRecognizer{
    if (!CGRectContainsPoint(self.overlayView.frame,[gestureRecognizer locationInView:self.view])) {
        [self close:nil];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.overlayView.layer.cornerRadius = 20;
    
    if (IS_IPAD) {
        for (UIImageView *imageView in self.powerBallImages) {
            [imageView setImage:[UIImage imageNamed:@"powerBallInventory_IPad"]];
        }
        
        [self.closeButton setImage:[UIImage imageNamed:@"close_IPad"] forState:UIControlStateNormal];
    }
    
    for (UIView *view in self.priceButtons) {
        view.layer.cornerRadius = view.frame.size.height/2;
    }
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)buyBonuses:(id)sender {
    if ([SKPaymentQueue canMakePayments]) {
        UIButton *priceButton = (UIButton *)sender;
        
        NSArray *productIdentifiers = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"IPA_ProductIdentifiers"];
        [[IAPStore sharedManager] buyProductWithProductIdentifier:productIdentifiers[priceButton.tag]];
    } else {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:@"This account has restricted payment access."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                         }];
        
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    
}
@end
