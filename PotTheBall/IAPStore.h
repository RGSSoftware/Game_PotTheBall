//
//  IAPStore.h
//  PotTheBall
//
//  Created by PC on 7/6/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <StoreKit/StoreKit.h>

@interface IAPStore : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@property (nonatomic, strong)NSMutableSet *productIdentifiers;
@property (nonatomic) NSMutableDictionary *products;




+ (instancetype)sharedManager;

-(NSNumber *)priceForProductIdentifier:(NSString *)productIdentifier;

-(void)loadProductsWithCompletionBlock:(void (^)(NSDictionary *products, NSError *error))completionBlock;
-(void)buyProductWithProductIdentifier:(NSString *)productIdentifier;
@end
