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
#import <RevMobAds/RevMobAds.h>
static NSString *const interstitialAdUnitID = @"ca-app-pub-3940256099942544/4411468910";


@interface AdHelper : NSObject <GADInterstitialDelegate, ADInterstitialAdDelegate, ChartboostDelegate, RevMobAdsDelegate>

+ (instancetype)sharedManager;

-(void)showInterstitialfromViewController:(UIViewController *)vc;

-(void)showFullScreenAd;

-(void)loadAdNetworks;

+(BOOL)shouldShowInterstitialOnStartUp;
+(BOOL)shouldShowRemobInterstitialOnStartUp;
+(BOOL)shouldShowChartboostInterstitialOnStartUp;
+(BOOL)shouldShowAdmobInterstitialOnStartUp;
+(BOOL)shouldShowIAdsInterstitialOnStartUp;

+(BOOL)shouldShowInterstitialOnEnterForeground;
+(BOOL)shouldShowAdmobInterstitialOnEnterForeground;
+(BOOL)shouldShowChartboostInterstitialOnEnterForeground;
+(BOOL)shouldShowRemobInterstitialOnEnterForeground;
+(BOOL)shouldShowIAdsInterstitialOnEnterForeground;


-(void)showAdmobInterstitial;
-(void)showChartboostInterstitial;
-(void)showIAdsInterstitial;
-(void)showRemobInterstitial;

-(void)showRevmobRewardVideo;


-(void)showRewardVideoWithSuccessBlock:(void (^)(BOOL success))successBlock;
@end
