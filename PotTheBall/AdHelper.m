//
//  AdHelper.m
//  PotTheBall
//
//  Created by PC on 7/8/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import "AdHelper.h"

#import <BlocksKit/BlocksKit.h>


@interface AdHelper ()
@property(nonatomic, strong) GADInterstitial *interstitial;
@property BOOL didRqeuestAdMobInterstitial;
@property (nonatomic, strong)UIViewController *presentFromViewController;
@property BOOL presentInTopMostViewControler;

@property(nonatomic, strong) ADInterstitialAd *iAdInterstitial;

@property(nonatomic, strong) UIView *adPlaceholderView;
@property BOOL requestingAd;

@property BOOL testMode;

@property (nonatomic, strong)void(^rewardVideoSuccess)(BOOL success);
@end

@implementation AdHelper

+ (instancetype)sharedManager {
    
    static AdHelper *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];

        sharedMyManager.interstitial = [sharedMyManager createAndLoadInterstitial];
        sharedMyManager.didRqeuestAdMobInterstitial = NO;
        
        
        sharedMyManager.testMode = NO;
    });
    return sharedMyManager;
}

- (UIViewController*)topViewController {
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

- (void)showInterstitial:(UIViewController *)vc {
    
    [self.interstitial presentFromRootViewController:vc];
    self.didRqeuestAdMobInterstitial = NO;
    
}

- (GADInterstitial *)createAndLoadInterstitial {
    GADInterstitial *interstitial;
    if (![[[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"Ad_Config"] objectForKey:@"Admob_Config"] objectForKey:@"interstitialAdUnitID"] isEqualToString:@""]) {
//        NSString *string = [[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"Ad_Config"] objectForKey:@"Admob_Config"] objectForKey:@"interstitialAdUnitID"];
        interstitial = [[GADInterstitial alloc] initWithAdUnitID:@""];
        
        interstitial.delegate = self;
        GADRequest *request = [GADRequest request];
        
        request.testDevices = @[
                                @"TestDevices"  // Eric's iPod Touch
                                ];
        [interstitial loadRequest:request];
    }
    
    return interstitial;
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    self.interstitial = [self createAndLoadInterstitial];
}
- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error{
    
}

-(void)interstitialDidReceiveAd:(GADInterstitial *)ad{
    if (self.didRqeuestAdMobInterstitial == YES) {
        
        if (self.presentFromViewController == nil && self.presentInTopMostViewControler == YES) {
            [self showInterstitial:[self topViewController]];
            
        } else if (self.presentFromViewController){
            [self showInterstitial:self.presentFromViewController];
        }
    }
}


-(void)loadAdNetworks{
    if (![[[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"Ad_Config"] objectForKey:@"Chatboost_Config"] objectForKey:@"appId"] isEqualToString:@""] &&
        ![[[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"Ad_Config"] objectForKey:@"Chatboost_Config"] objectForKey:@"appSignature"] isEqualToString:@""]) {
        [Chartboost startWithAppId:[[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"Ad_Config"] objectForKey:@"Chatboost_Config"] objectForKey:@"appId"]
                      appSignature:[[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"Ad_Config"] objectForKey:@"Chatboost_Config"] objectForKey:@"appSignature"]
                          delegate:self];
        [Chartboost cacheMoreApps:CBLocationMainMenu];
        [Chartboost cacheInterstitial:CBLocationGameOver];
        [Chartboost cacheInterstitial:CBLocationPause];
        if ([[[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"Ad_Config"] objectForKey:@"Chatboost_Config"] objectForKey:@"showRewardVideos"] boolValue]) {
            
            [Chartboost cacheRewardedVideo:CBLocationIAPStore];
        }
        
    }
}

+(BOOL)shouldShowInterstitialOnStartUp{
    if (![[NSUbiquitousKeyValueStore defaultStore] objectForKey:@"showAds"]) {
        
        return [[[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"Ad_Config"] objectForKey:@"Interstitial"] objectForKey:@"showOnStartUp"] boolValue];
    }
    return NO;
}

+(BOOL)shouldShowAdmobInterstitialOnStartUp{
    return [[[[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"Ad_Config"] objectForKey:@"Admob_Config"] objectForKey:@"Interstitial"] objectForKey:@"showOnStartUp"] boolValue] ;
}

+(BOOL)shouldShowChartboostInterstitialOnStartUp{
    return [[[[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"Ad_Config"] objectForKey:@"Chatboost_Config"] objectForKey:@"Interstitial"] objectForKey:@"showOnStartUp"] boolValue] ;
}


+(BOOL)shouldShowInterstitialOnEnterForeground{
    if (![[NSUbiquitousKeyValueStore defaultStore] objectForKey:@"showAds"]) {
        return [[[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"Ad_Config"] objectForKey:@"Interstitial"] objectForKey:@"showOnEnterForeground"] boolValue];
    }
    return NO;
    
}

+(BOOL)shouldShowAdmobInterstitialOnEnterForeground{
    return [[[[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"Ad_Config"] objectForKey:@"Admob_Config"] objectForKey:@"Interstitial"] objectForKey:@"showOnEnterForeground"] boolValue] ;
}

+(BOOL)shouldShowChartboostInterstitialOnEnterForeground{
    return [[[[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"Ad_Config"] objectForKey:@"Chatboost_Config"] objectForKey:@"Interstitial"] objectForKey:@"showOnEnterForeground"] boolValue] ;
}
+(BOOL)shouldShowRewardAfterGameOver{
    if ([Chartboost hasRewardedVideo:CBLocationIAPStore]) {
        return [[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"Ad_Config"] objectForKey:@"showRewardAfterGameOver"] boolValue];
    }
    return NO;
}

+(BOOL)shouldShowInterstitialOnGameOver{
    if (![[NSUbiquitousKeyValueStore defaultStore] objectForKey:@"showAds"]) {
        
        return [[[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"Ad_Config"] objectForKey:@"Interstitial"] objectForKey:@"showOnGameOver"] boolValue];
    }
    return NO;
    
}

+(BOOL)shouldShowAdmobInterstitialOnGameOver{
    return [[[[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"Ad_Config"] objectForKey:@"Admob_Config"] objectForKey:@"Interstitial"] objectForKey:@"showOnGameOver"] boolValue] ;
}

+(BOOL)shouldShowChartboostInterstitialOnGameOver{
    return [[[[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"Ad_Config"] objectForKey:@"Chatboost_Config"] objectForKey:@"Interstitial"] objectForKey:@"showOnGameOver"] boolValue] ;
}


-(void)showAdmobInterstitial{
    self.didRqeuestAdMobInterstitial = YES;
    
    self.presentInTopMostViewControler = YES;
    
    if ([self.interstitial isReady]) {
        
        [self showInterstitial:[self topViewController]];
    }
}

-(void)showChartboostInterstitial{
    [Chartboost showInterstitial:CBLocationStartup];
}
-(void)showChartboostGameOverInterstitial{
    [Chartboost showInterstitial:CBLocationGameOver];
}
-(void)showChartboostPauseInterstitial{
    [Chartboost showInterstitial:CBLocationPause];
}

-(void)showRewardVideoWithSuccessBlock:(void (^)(BOOL))successBlock{
    self.rewardVideoSuccess = successBlock;
    if (self.testMode) {
        if (successBlock) {
            successBlock(YES);
            successBlock = nil;
        }
    } else {
        if ([[[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"Ad_Config"] objectForKey:@"Chatboost_Config"] objectForKey:@"showRewardVideos"] boolValue]) {
            
            [Chartboost showRewardedVideo:CBLocationIAPStore];
        }
        
    }
    
}

- (void)didFailToLoadRewardedVideo:(CBLocation)location
                         withError:(CBLoadError)error{
    NSLog(@"simple print-----locaction------{%@}", location);
    
    NSLog(@"simple print-----error------{%lu}", (unsigned long)error);
}

- (void)didCompleteRewardedVideo:(CBLocation)location
                      withReward:(int)reward{
    if (self.rewardVideoSuccess) {
        self.rewardVideoSuccess(YES);
        self.rewardVideoSuccess = nil;
    }
    
}
-(void)showMoreGames{
    [Chartboost showMoreApps:CBLocationMainMenu];
}


@end
