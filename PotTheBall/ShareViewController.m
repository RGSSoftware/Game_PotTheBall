//
//  ShareViewController.m
//  PotTheBall
//
//  Created by PC on 7/12/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import "ShareViewController.h"
#import "ScreenDetact.h"
#import <Social/Social.h>

@interface ShareViewController ()

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]];
    
}

-(void)viewDidLayoutSubviews{
    self.overlayView.layer.cornerRadius = 20;
    
    for (UIView *view in self.shareButtons) {
        view.layer.cornerRadius = view.bounds.size.width/2;
    }
}

-(void)handleTap:(UIGestureRecognizer *)gestureRecognizer{
    if (!CGRectContainsPoint(self.overlayView.frame,[gestureRecognizer locationInView:self.view])) {
        [self close:nil];
    }
}

- (IBAction)shareWithFacebook:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"Facebook_Config"] objectForKey:@"shareMessage"]];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Sorry"
                                    
                                                                       message:@"You can't send a message right now, make sure your device has an internet connection and you have at least one Facebook account setup."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];

    }
}

- (IBAction)shareWithTwitter:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"Twitter_Config"] objectForKey:@"shareMessage"]];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Sorry"
                                    
                                                                       message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)shareWithEmail:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
        [composeViewController setMailComposeDelegate:self];
        [composeViewController setMessageBody:[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"Email_Config"] objectForKey:@"shareMessage"] isHTML:NO];
        [self presentViewController:composeViewController animated:YES completion:nil];
    } else {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Sorry"

                                                                       message:@"You can't send an email right now, make sure your device has an internet connection and you have at least one Email account setup."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    //Add an alert in case of failure
    [self dismissViewControllerAnimated:YES completion:^{
        if (error) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Email error. Please try again."
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
    
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
