//
//  SettingViewController.m
//  PotTheBall
//
//  Created by PC on 6/30/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import "SettingViewController.h"
#import "ScreenDetact.h"

typedef enum SettingButton : NSUInteger {
    SettingButtonSound,
    SettingButtonVibration,
} SettingButton;

@interface SettingViewController ()

@end

@implementation SettingViewController

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
    id soundSetting = [[NSUserDefaults standardUserDefaults] objectForKey:@"enableSound"];
    if (soundSetting) {
        self.soundButton.selected = [soundSetting boolValue] ? NO : YES;
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"enableSound"];
    }

    id vibrationSetting = [[NSUserDefaults standardUserDefaults] objectForKey:@"enableVibration"];
    if (vibrationSetting) {
        self.vibrationButton.selected = [vibrationSetting boolValue] ? NO : YES;
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"enableVibration"];
    }
    
    if (IS_IPAD) {
        [self.soundButton setImage:[UIImage imageNamed:@"sound_IPad"] forState:UIControlStateNormal];
        [self.vibrationButton setImage:[UIImage imageNamed:@"vibration_IPad"] forState:UIControlStateNormal];
        
        [self.soundButton setImage:[UIImage imageNamed:@"sound_IPad_selected"] forState:UIControlStateSelected];
        [self.vibrationButton setImage:[UIImage imageNamed:@"vibration_IPad_selected"] forState:UIControlStateSelected];
        
        [self.closeButton setImage:[UIImage imageNamed:@"close_IPad"] forState:UIControlStateNormal];
        
    }
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]];
    
}

-(void)handleTap:(UIGestureRecognizer *)gestureRecognizer{
    if (!CGRectContainsPoint(self.overlayView.frame,[gestureRecognizer locationInView:self.view])) {
        [self close:nil];
    }
}
-(void)viewDidLayoutSubviews{
    self.overlayView.layer.cornerRadius = 20;
    
    self.soundButton.layer.cornerRadius = self.soundButton.bounds.size.width/2;
    self.vibrationButton.layer.cornerRadius = self.vibrationButton.bounds.size.width/2;
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)settingDidChange:(UIButton *)sender {
    if (sender.tag == SettingButtonSound) {
        BOOL enableSound = [[[NSUserDefaults standardUserDefaults] objectForKey:@"enableSound"] boolValue];
        if (!enableSound && sender.selected) {
            [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"enableSound"];
            sender.selected = NO;
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"enableSound"];
            sender.selected = YES;
        }
    } else if (sender.tag == SettingButtonVibration) {
        BOOL enableSound = [[[NSUserDefaults standardUserDefaults] objectForKey:@"enableVibration"] boolValue];
        if (!enableSound && sender.selected) {
            [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"enableVibration"];
            sender.selected = NO;
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"enableVibration"];
            sender.selected = YES;
        }
    }
}


@end
