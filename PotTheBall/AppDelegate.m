//
//  AppDelegate.m
//  PotTheBall
//
//  Created by PC on 6/1/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import "AppDelegate.h"
#import "IAPStore.h"
#import "GameNavigationController.h"

#import "NSString+RGSInt.h"

#import "AdHelper.h"

#import <BlocksKit/BlocksKit.h>

#import <AudioToolbox/AudioServices.h>

@interface AppDelegate ()
@property BOOL enteringFromForeground;


@property BOOL isshowingAd;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[SKPaymentQueue defaultQueue] addTransactionObserver:[IAPStore sharedManager]];
    
    NSMutableArray *productIdentifiers = [NSMutableArray new];
    
    NSDictionary *products = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Store_Products"];
    
    for (int i = 0; i < products.count; i++) {
        [productIdentifiers addObject:[[products objectForKey:NSStringFromInt(i)] objectForKey:@"ProductIdentifiers"]];
    }
    
    [IAPStore sharedManager].productIdentifiers = [[NSSet setWithArray:productIdentifiers] mutableCopy];
    

    id count = [[NSUbiquitousKeyValueStore defaultStore] objectForKey:@"BonusBallsCount"];
    if (!count) {
        [[NSUbiquitousKeyValueStore defaultStore] setDouble:7 forKey:@"BonusBallsCount"];
        [[NSUbiquitousKeyValueStore defaultStore] synchronize];

    }

    NSLog(@"simple print--lunach---bonus count------{%f}", [[NSUbiquitousKeyValueStore defaultStore] doubleForKey:@"BonusBallsCount"]);
    
    [[AdHelper sharedManager] loadAdNetworks];
    
    if ([AdHelper shouldShowInterstitialOnStartUp]) {
        if ([AdHelper shouldShowAdmobInterstitialOnStartUp]) {
            [[AdHelper sharedManager] showAdmobInterstitial];
        }
        if ([AdHelper shouldShowChartboostInterstitialOnStartUp]) {
            [[AdHelper sharedManager] showChartboostInterstitial];
        }
        
    }
    
    return YES;
}



- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[SKPaymentQueue defaultQueue] addTransactionObserver:[IAPStore sharedManager]];
    
//    self.enteringFromForeground = YES;
    
    if ([AdHelper shouldShowInterstitialOnEnterForeground]) {
        [NSTimer bk_scheduledTimerWithTimeInterval:0.1 block:^(NSTimer *timer) {
            
            if ([AdHelper shouldShowAdmobInterstitialOnEnterForeground]) {
                [[AdHelper sharedManager] showAdmobInterstitial];
            }
            if ([AdHelper shouldShowChartboostInterstitialOnEnterForeground]) {
                [[AdHelper sharedManager] showChartboostPauseInterstitial];
            }
            
        } repeats:NO];
        
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[SKPaymentQueue defaultQueue] addTransactionObserver:[IAPStore sharedManager]];
    
    
    
}

@end
