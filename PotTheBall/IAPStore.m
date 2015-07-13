//
//  IAPStore.m
//  PotTheBall
//
//  Created by PC on 7/6/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import "IAPStore.h"
#import <StoreKit/StoreKit.h>
#import "AppDelegate.h"

@interface IAPStore ()

@property (nonatomic)SKProductsRequest *productRequest;
@property (nonatomic, strong)void(^completionBlock)(NSDictionary *products, NSError *error);
@end

@implementation IAPStore

+ (instancetype)sharedManager {
    
    static IAPStore *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        sharedMyManager.products = [NSMutableDictionary new];
        
    });
    return sharedMyManager;
}
-(NSNumber *)priceForProductIdentifier:(NSString *)productIdentifier{
    
   return [NSNumber numberWithFloat:((SKProduct *)[self.products objectForKey:productIdentifier]).price.floatValue];
}

-(void)loadProductsWithCompletionBlock:(void (^)(NSDictionary *, NSError *))completionBlock{
    self.completionBlock = [completionBlock copy];
    self.productRequest = [[SKProductsRequest alloc]initWithProductIdentifiers:self.productIdentifiers];
    self.productRequest.delegate = self;
    [self.productRequest start];
}

#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    self.productRequest = nil;
    NSLog(@"Loaded list of products...");
    
    NSLog(@"simple print-----result.count------{%lu}", (unsigned long)response.products.count);
    
    
    NSArray * skProducts = response.products;
    for (SKProduct * skProduct in skProducts) {
        
        [self.products setObject:skProduct forKey:skProduct.productIdentifier];
        
        
    }
    
    if (self.completionBlock) {
        self.completionBlock(self.products,nil);
        self.completionBlock = nil;
    }

}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    self.productRequest = nil;
    
    if (self.completionBlock) {
        self.completionBlock(nil, error);
        self.completionBlock = nil;
    }
    
    NSLog(@"Failed to load list of products.");
}


- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction * transaction in transactions) {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                //handle any trasaction here
                
                [self completeTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            
            case SKPaymentTransactionStatePurchasing:
//                [self handlePurchasingTransaction];
                break;

            case SKPaymentTransactionStateDeferred:
                NSLog(@"Deferred...");
                break;
                
            default:
                break;
        }
    };
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"completeTransaction...");
    double count = [[NSUbiquitousKeyValueStore defaultStore] doubleForKey:@"BonusBallsCount"];
    [[NSUbiquitousKeyValueStore defaultStore] setDouble:count + 23 forKey:@"BonusBallsCount"];
    [[NSUbiquitousKeyValueStore defaultStore] synchronize];
    
//    [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"restoreTransaction...");
    
//    [self provideContentForProductIdentifier:transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    NSLog(@"failedTransaction...");
    NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:@"There was an error while processing your transaction. Please try again at a later time."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                         }];
        
        [alert addAction:okAction];
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
-(void)buyProductWithProductIdentifier:(NSString *)productIdentifier{
    [self handlePurchasingTransaction];
    SKMutablePayment * payment = [SKMutablePayment paymentWithProduct:[self.products objectForKey:productIdentifier]];
    payment.simulatesAskToBuyInSandbox = YES;
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
}

- (void)handlePurchasingTransaction
{
    NSLog(@"Purchasing...");
    //show purchansing alert.
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Purchasing"
                                                                   message:@"Please wait while we process your transaction."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                     }];
    
    [alert addAction:okAction];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [((UINavigationController *)appDelegate.window.rootViewController).topViewController presentViewController:alert animated:YES completion:nil];
}

@end
