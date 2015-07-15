//
//  AdHelper.h
//  PotTheBall
//
//  Created by PC on 7/8/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <GoogleMobileAds/GoogleMobileAds.h>
#import <iAd/iAd.h>

#import <CommonCrypto/CommonDigest.h>
#import <AdSupport/AdSupport.h>
#import <Chartboost/Chartboost.h>
#import <Chartboost/CBNewsfeed.h>

static NSString *const interstitialAdUnitID = @"ca-app-pub-3940256099942544/4411468910";


@interface AdHelper : NSObject <GADInterstitialDelegate, ADInterstitialAdDelegate, ChartboostDelegate>

+ (instancetype)sharedManager;

-(void)showInterstitialfromViewController:(UIViewController *)vc;

-(void)showFullScreenAd;

-(void)loadAdNetworks;

+(BOOL)shouldShowInterstitialOnStartUp;
+(BOOL)shouldShowChartboostInterstitialOnStartUp;
+(BOOL)shouldShowAdmobInterstitialOnStartUp;


+(BOOL)shouldShowInterstitialOnEnterForeground;
+(BOOL)shouldShowAdmobInterstitialOnEnterForeground;
+(BOOL)shouldShowChartboostInterstitialOnEnterForeground;

+(BOOL)shouldShowRewardAfterGameOver;

-(void)showAdmobInterstitial;
-(void)showChartboostInterstitial;
-(void)showIAdsInterstitial;

-(void)showMoreGames;

-(void)showRewardVideoWithSuccessBlock:(void (^)(BOOL success))successBlock;
@end
