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

#import "NSString+RGSInt.h"

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
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.overlayView animated:YES];
    hud.labelText = @"Loading Store Inventory...";
    
    [[IAPStore sharedManager] loadProductsWithCompletionBlock:^(NSDictionary *products, NSError *error) {
        
       
        NSDictionary *productsCount = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Store_Products"];
        
        for (int i = 0; i < self.priceButtons.count; i++) {
            for (UIButton *priceButton in self.priceButtons) {
                if (priceButton.tag == i) {
                    SKProduct *product = (SKProduct *)[products objectForKey:[[productsCount objectForKey:NSStringFromInt(i)] objectForKey:@"ProductIdentifiers"]];
                    currencyFormatter.locale = product.priceLocale;
                    [priceButton setTitle:[currencyFormatter stringFromNumber:@(product.price.floatValue)] forState:UIControlStateNormal];
                }
            }
            
            for (UILabel *countLabel in self.countLabels) {
                if (countLabel.tag == i) {
                    countLabel.text = [[productsCount objectForKey:NSStringFromInt(i)] objectForKey:@"count"];
                }
            }
        }
        
        for (UIView *view in self.allViews) {
            view.hidden = NO;
        }
        
        [MBProgressHUD hideHUDForView:self.overlayView animated:YES];
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
    
    for (UIView *view in self.priceButtons) {
        view.layer.cornerRadius = view.frame.size.height/2;
    }
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)buyBonuses:(id)sender {
    NSDictionary *productsCount = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Store_Products"];
    
    if ([SKPaymentQueue canMakePayments]) {
        UIButton *priceButton = (UIButton *)sender;
        
        [[IAPStore sharedManager] buyProductWithProductIdentifier:[[productsCount objectForKey:NSStringFromInt((int)priceButton.tag)] objectForKey:@"ProductIdentifiers"]];
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
