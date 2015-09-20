//
//  ViewController.m
//  PotTheBall
//
//  Created by PC on 6/1/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import "MainGameBoardViewController.h"

#import <UIView+MTAnimation.h>


#import "UIView+RGSFrame.h"


#import "NSString+RGSInt.h"

#import <BlocksKit/BlocksKit.h>
#import "UIView+RemoveConstraints.h"

#import "GameOverViewController.h"

#import <BlocksKit/BlocksKit.h>

#import <AudioToolbox/AudioServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

typedef NS_ENUM(NSUInteger, RingSegment) {
    RingSegmentUp,
    RingSegmentRight,
    RingSegmentDown,
    RingSegmentLeft
};


static BOOL isBallPowerBall(UIView* ball)
{
    if (ball.tag == 0) {
        return YES;
    }
    return NO;
    
}


const int startingCountDown = 45;
const int bonusTime = 4;


#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
@interface MainGameBoardViewController ()

@property (nonatomic)BOOL isAnimation;

@property (nonatomic, strong)NSMutableArray *balls;
@property (nonatomic, strong)NSArray *ballImagesNames;

@property (nonatomic, strong)NSMutableArray *colorSeg;

@property int topBottomScreenOffset;
@property int leftRightScreenOffset;

@property (nonatomic, strong)NSTimer *countDownTimer;
@property (nonatomic, strong)NSTimer *bonusDownTimer;
@property int score;

@property (nonatomic)int currentCountDown;
@property (nonatomic)int bonusCountDown;
@property (nonatomic)BOOL isBonusActivate;

@property (nonatomic)BOOL isViewWillAppear;

@property NSDictionary *currentlevel;
@property int currentlevelNumber;
@property int currentTurnCount;

@property int currentWave;

@property (nonatomic, strong)NSDictionary *levels;

@property (nonatomic, strong)AVAudioPlayer *player;
@property (nonatomic, strong)AVAudioPlayer *failPlayer;

@end

@implementation MainGameBoardViewController
#pragma mark - View Handles
- (void)viewDidLoad {
    [super viewDidLoad];
    self.ballImagesNames = @[@"multiPlayBall",
                             @"green",
                             @"orange",
                             @"red",
                             @"blue"];
    
    self.colorSeg = [@[@(3), @(1), @(4), @(2)] mutableCopy];
    
    self.isBonusActivate = NO;
    self.isViewWillAppear = NO;
    
    NSError *soundError = nil;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"success" ofType:@"wav"]] error:&soundError];
    [self.player setVolume:1];

    if(self.player == nil)
        NSLog(@"%@",soundError);
    
    self.failPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"fail" ofType:@"wav"]] error:&soundError];
    [self.failPlayer setVolume:1];
    
    if(self.failPlayer == nil)
        NSLog(@"%@",soundError);

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.isAnimation = NO;
    self.isViewWillAppear = YES;
    
    for (UIView *view in self.balls) {
        [view removeFromSuperview];
    }
    
    NSDictionary *imageData = [self randBallImage];
    self.ball.image = [imageData objectForKey:@"image"];
    self.ball.tag = [[imageData objectForKey:@"tag"] integerValue];
    
    
    if (self.gameState == GameStatePrepareStart) {
        
        if (self.gameMode == GameModeTimeAttack) {
            [self initTimeMode];
            
        } else if (self.gameMode == GameModeArcade){
            [self initArcadeMode];
        }
        
        self.ball.hidden = YES;
        self.playButton.hidden = NO;
        
    
    [NSTimer bk_scheduledTimerWithTimeInterval:0.3 block:^(NSTimer *timer) {
        
        [self initRingState];
    

            } repeats:NO];
    }
    
        [self.bonusBalls setTitle:NSStringFromInt([[NSUbiquitousKeyValueStore defaultStore] doubleForKey:@"BonusBallsCount"]) forState:UIControlStateNormal];
    
}

-(void)viewDidLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    
    if (self.isViewWillAppear) {
        self.bonusBalls.layer.cornerRadius = self.bonusBalls.frame.size.height/2;

        CGRect rect = self.ball.frame;
        int tag = (int)self.ball.tag;
        
        self.ball = [[UIImageView alloc] initWithImage:self.ball.image];
        self.ball.tag = tag;
        self.ball.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2 - CGRectGetWidth(rect)/2, CGRectGetHeight(self.view.frame)/2 - CGRectGetHeight(rect)/2, CGRectGetWidth(rect), CGRectGetHeight(rect));
        
        self.isViewWillAppear = NO;
    }
}

#pragma mark - Ball Creation
-(NSDictionary *)randBallImage{
    if (self.isBonusActivate) {
        return @{@"tag" : @(0), @"image" : [UIImage imageNamed:self.ballImagesNames[0]]};

    } else {
        int rand = arc4random_uniform(15);
        
        if (rand == 9) {
            return @{@"tag" : @(0), @"image" : [UIImage imageNamed:self.ballImagesNames[0]]};
            
        } else {
            rand = arc4random_uniform((int)[self.ballImagesNames count] - 1);
            rand++;
            
            return @{@"tag" : @(rand), @"image" : [UIImage imageNamed:self.ballImagesNames[rand]]};
        }

    }
}

-(UIImageView *)newBallImageWithFrame:(CGRect)rect{
    NSDictionary *imageData = [self randBallImage];
    UIImageView *newBall = [[UIImageView alloc] initWithImage:[imageData objectForKey:@"image"]];
    newBall.frame = rect;
    newBall.tag = [[imageData objectForKey:@"tag"] integerValue];
    newBall.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5);
    return newBall;
}

#pragma mark - Touch Handles

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    
    CGPoint previousl = [touch previousLocationInView:self.view];
    CGPoint currentl = [touch locationInView:self.view];
    
    int xx = currentl.y - previousl.y;
    if (xx < 0) {
        xx = xx * -1;
    }
    
    int yy = currentl.x - previousl.x;
    if (yy < 0) {
        yy = yy * -1;
    }
    
    if (!self.isAnimation) {
        
        if (currentl.x > previousl.x - xx &&
            currentl.x < previousl.x + xx &&
            currentl.y < previousl.y) {
            
            UIView *ball = self.balls[0];
            [self.balls removeObjectAtIndex:0];
            
            
            if ([self isBall:ball matchRingSegment:RingSegmentUp] && !isBallPowerBall(ball)) {
                [self handleUserError];
            } else {
                [self handleUserSuccess];
            }
            self.scoreLabel.text = [NSString stringWithFormat:@"%d", self.score];
            
            UIImageView *newBall = [self newBallImageWithFrame:ball.frame];
            
            [self.balls addObject:newBall];
            
            [self animateFullScale:newBall];
            
            [self.view insertSubview:newBall belowSubview:ball];
            
            if (!self.isAnimation) {
                
                self.isAnimation = YES;
                
                
                [UIView animateWithDuration:.5 animations:^{
                    
                    [ball setFrameOriginY:self.topBottomScreenOffset];
                    ball.alpha = 0;
                } completion:^(BOOL finished) {
                    if (finished) {
                        [ball removeFromSuperview];
                    }
                }];
                
            }
            NSLog(@"-----top------");
            
        } else if (currentl.y > previousl.y - yy &&
                   currentl.y < previousl.y + yy &&
                   currentl.x < previousl.x) {
            
            UIView *ball = self.balls[0];
            [self.balls removeObjectAtIndex:0];
            
            
            if ([self isBall:ball matchRingSegment:RingSegmentLeft] && !isBallPowerBall(ball) ) {
                 [self handleUserError];
            } else {
                [self handleUserSuccess];
                
            }

            self.scoreLabel.text = [NSString stringWithFormat:@"%d", self.score];
            
            
            UIImageView *newBall = [self newBallImageWithFrame:ball.frame];
            [self.balls addObject:newBall];
            [self animateFullScale:newBall];
            
            [self.view insertSubview:newBall belowSubview:ball];
            
            if (!self.isAnimation) {
                
                self.isAnimation = YES;
                
                
                [UIView animateWithDuration:.5 animations:^{
                    [ball setFrameOriginX:self.leftRightScreenOffset];
                    ball.alpha = 0;
                } completion:^(BOOL finished) {
                    if (finished) {
                        [ball removeFromSuperview];
                    }
                }];
                
            }
            
            
            NSLog(@"-----left------");
            
        } else if (currentl.y > previousl.y - yy &&
                   currentl.y < previousl.y + yy &&
                   currentl.x > previousl.x) {
            
            UIView *ball = self.balls[0];
            [self.balls removeObjectAtIndex:0];
            
            if ([self isBall:ball matchRingSegment:RingSegmentRight] && !isBallPowerBall(ball) ) {
                [self handleUserError];
            } else {
                [self handleUserSuccess];
                
            }
            self.scoreLabel.text = [NSString stringWithFormat:@"%d", self.score];
            
            
            UIImageView *newBall = [self newBallImageWithFrame:ball.frame];
            [self.balls addObject:newBall];
            [self animateFullScale:newBall];
            
            [self.view insertSubview:newBall belowSubview:ball];
            
            if (!self.isAnimation) {
                
                self.isAnimation = YES;
               
                
                [UIView animateWithDuration:.5 animations:^{
                    
                    [ball setFrameOriginX:CGRectGetWidth([UIScreen mainScreen].bounds) + (self.leftRightScreenOffset * -1)];
                    ball.alpha = 0;
                } completion:^(BOOL finished) {
                    if (finished) {
                        [ball removeFromSuperview];
                    }
                }];
                
            }
            
            NSLog(@"-----right------");
            
        } else if (currentl.x > previousl.x - xx &&
                   currentl.x < previousl.x + xx &&
                   currentl.y > previousl.y) {
            
            UIView *ball = self.balls[0];
            [self.balls removeObjectAtIndex:0];
            
            if ([self isBall:ball matchRingSegment:RingSegmentDown] && !isBallPowerBall(ball) ) {
                [self handleUserError];
              } else {
                [self handleUserSuccess];
            }
            self.scoreLabel.text = [NSString stringWithFormat:@"%d", self.score];
            
            
            UIImageView *newBall = [self newBallImageWithFrame:ball.frame];
            [self.balls addObject:newBall];
            [self animateFullScale:newBall];
            
            [self.view insertSubview:newBall belowSubview:ball];
            
            if (!self.isAnimation) {
                
                self.isAnimation = YES;
                
                [UIView animateWithDuration:.5 animations:^{
                    
                    [ball setFrameOriginY:CGRectGetHeight([UIScreen mainScreen].bounds) + CGRectGetHeight(self.ball.frame)];
                    ball.alpha = 0;
                } completion:^(BOOL finished) {
                    if (finished) {
                        [ball removeFromSuperview];
                    }
                }];
                
            }
            
            NSLog(@"-----bottom------");
            
        }

    }
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (!self.isBonusActivate) {
        
        if (self.isAnimation) {
            
            if (self.gameMode == GameModeTimeAttack) {
                if (self.currentTurnCount != [[self.currentlevel objectForKey:@"turnCount"] integerValue]) {
                    self.currentTurnCount++;
                    
                    [self rotateRing];
                } else {
                    [self incrementTimeLevel];
                }
            } else if (self.gameMode == GameModeArcade){
                if (self.score != 0) {
                    self.currentTurnCount++;

                    [self rotateRing];
                } else {
                    [self incrementWaveLevel];

                }
            }
            
        }
    } else {
        if (self.gameMode == GameModeArcade){
            if (self.score != 0) {
                self.currentTurnCount++;
            
            } else {
                [self incrementWaveLevel];
                
            }
        }

    }
    
     self.isAnimation = NO;
}


#pragma mark - Rotation

- (IBAction)rotate:(id)sender {
    
    double rads = DEGREES_TO_RADIANS(-90);
    CGAffineTransform transform = CGAffineTransformRotate(self.ring.transform, rads);
    [UIView animateWithDuration:.5 animations:^{
        self.ring.transform = transform;
    }];

//    [self rotateColorSegRightTurns:1];
    [self rotateColorSegLeftTurns:1];
}

-(void)rotateRingRightTurns:(int)truns{
    double rads = DEGREES_TO_RADIANS(90 * truns);
    CGAffineTransform transform = CGAffineTransformRotate(self.ring.transform, rads);
    [UIView animateWithDuration:.3 animations:^{
        self.ring.transform = transform;
    }];
}

-(void)rotateRingLeftTurns:(int)truns{
    double rads = DEGREES_TO_RADIANS(-90 * truns);
    CGAffineTransform transform = CGAffineTransformRotate(self.ring.transform, rads);
    [UIView animateWithDuration:.3 animations:^{
        self.ring.transform = transform;
    }];
}

-(void)rotateColorSegRightTurns:(int)truns{
    id lastObject;
    for (int i = 0; i < truns; i++) {
        for (int k = (int)self.colorSeg.count; k != 0; k--) {
            if (k == self.colorSeg.count) {
                lastObject = self.colorSeg.lastObject;
            } else if (k - 1 == 0){
                id object = self.colorSeg[0];
                self.colorSeg[1] = object;
                self.colorSeg[0] = lastObject;
            } else {
                id object = self.colorSeg[k - 1];
                self.colorSeg[k] = object;
            }
        }
    }
}

-(void)rotateColorSegLeftTurns:(int)truns{
    id firstObject;
    for (int i = 0; i < truns; i++) {
        for (int k = 0; k < self.colorSeg.count; k++) {
            if (k == 0) {
                firstObject = self.colorSeg[0];
            } else if (k == self.colorSeg.count - 1){
                id object = [self.colorSeg lastObject];
                self.colorSeg[[self.colorSeg indexOfObject:self.colorSeg.lastObject] - 1] = object;
                self.colorSeg[self.colorSeg.count - 1] = firstObject;
            } else {
                id object = self.colorSeg[k];
                self.colorSeg[k - 1] = object;
            }
        }
    }
}


#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[GameOverViewController class]]) {
        GameOverViewController *gameOverViewController = (GameOverViewController *)segue.destinationViewController;
        
        if (self.gameMode == GameModeTimeAttack) {
            gameOverViewController.score = self.score;
        } else if (self.gameMode == GameModeArcade) {
            gameOverViewController.score = self.currentTurnCount - 1;
        }
        
        gameOverViewController.gameMode = self.gameMode;
        
    }
}
-(IBAction)unwindToGameBoard:(UIStoryboardSegue *)segue {
}


#pragma mark - Navigation
- (IBAction)home:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - Helpers ()
- (void)animateFullScale:(UIView *)newBall {
    [UIView mt_animateWithViews:@[newBall]
                       duration:1
                 timingFunction:kMTEaseOutElastic
                     animations:^{
                         newBall.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                     }];
}

- (IBAction)startGame:(id)sender {
    if (self.gameState == GameStatePrepareStart) {
        self.gameState = GameStatePlaying;
        self.ball.hidden = NO;
        self.playButton.hidden = YES;

        
        double rads = DEGREES_TO_RADIANS(45);
        CGAffineTransform transform = CGAffineTransformRotate(self.ring.transform, rads);
        CGAffineTransform scaleTrans  = CGAffineTransformScale(transform,
                                                               1.429, 1.429);
        [UIView animateWithDuration:.3 animations:^{
            self.ring.transform = scaleTrans;
            
        }];
        
        [self rotateColorSegRightTurns:1];
        
        [self.view addSubview:self.ball];
        
        
        self.balls = [NSMutableArray new];
        [self.balls addObject:self.ball];
        
        
        self.topBottomScreenOffset = CGRectGetHeight(self.ball.frame) * -1;
        self.leftRightScreenOffset = (CGRectGetMinY(self.ball.frame) - CGRectGetMinX(self.ball.frame)) * -1;
        
        
        
        self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateCountDownLabel:) userInfo:nil repeats:YES];
        
    }
}

- (IBAction)restartGame:(id)sender {
    self.isAnimation = NO;
    [self.countDownTimer invalidate];

    if (self.gameState != GameStatePrepareStart) {
        self.gameState = GameStatePrepareStart;
        if (self.gameMode == GameModeTimeAttack) {
        
            [self initTimeMode];
            
        } else if (self.gameMode == GameModeArcade) {
            
            [self initArcadeMode];
        }
        
        self.ball.hidden = YES;
        self.playButton.hidden = NO;
        
        [self initRingState];
        
        for (UIView *view in self.balls) {
            [view removeFromSuperview];
        }
        
        CGRect rect = self.ball.frame;
        int tag = (int)self.ball.tag;
        
        self.ball = [[UIImageView alloc] initWithImage:self.ball.image];
        self.ball.tag = tag;
        self.ball.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2 - CGRectGetWidth(rect)/2, CGRectGetHeight(self.view.frame)/2 - CGRectGetHeight(rect)/2, CGRectGetWidth(rect), CGRectGetHeight(rect));
       
    }
    
}

- (void)updateCountDownLabel:(NSTimer *)timer{
    if (self.currentCountDown != 0) {
        self.currentCountDown--;
        
        self.countDownLabel.text = NSStringFromInt(self.currentCountDown);
    } else {
        [timer invalidate];
        
        //gmae over
        
        [self performSegueWithIdentifier:@"toGameOverScreen" sender:self];
    }
}

- (IBAction)activateBonus:(id)sender {
    if (self.gameState != GameStatePrepareStart) {
        if ([[NSUbiquitousKeyValueStore defaultStore] doubleForKey:@"BonusBallsCount"] > 0) {
            double count = [[NSUbiquitousKeyValueStore defaultStore] doubleForKey:@"BonusBallsCount"];
            [[NSUbiquitousKeyValueStore defaultStore] setDouble:count - 1 forKey:@"BonusBallsCount"];
            
            [self.bonusBalls setTitle:NSStringFromInt([[NSUbiquitousKeyValueStore defaultStore] doubleForKey:@"BonusBallsCount"]) forState:UIControlStateNormal];
            [[NSUbiquitousKeyValueStore defaultStore] synchronize];
            
            self.bonusCountDown = self.bonusCountDown + bonusTime;
            self.isBonusActivate = YES;
            [((UIView *)self.balls[0]) removeFromSuperview];
            self.balls[0] = [self newBallImageWithFrame:((UIView *)self.balls[0]).frame];
            [self.view addSubview:self.balls[0]];
            [self animateFullScale:self.balls[0]];
            self.bonusDownTimer = [NSTimer bk_scheduledTimerWithTimeInterval:1 block:^(NSTimer *timer) {
                if (self.bonusCountDown != 0) {
                    self.bonusCountDown--;
                    
                    self.isBonusActivate = YES;
                    
                    
                } else {
                    self.isBonusActivate = NO;
                    [self.bonusDownTimer invalidate];
                    
                }
                
            } repeats:YES];
        }
    }
}

- (void)rotateRing {
    if (![[self.currentlevel objectForKey:@"rotationProbability"] isKindOfClass:[NSNull class]]) {
        int rand = arc4random_uniform((int)[[self.currentlevel objectForKey:@"rotationProbability"] integerValue]);
        if (rand == 0) {
            int randRotation = arc4random_uniform(3) + 1;
            
            if (arc4random_uniform(2) == 0) {
                [self rotateRingLeftTurns:randRotation];
                [self rotateColorSegLeftTurns:randRotation];
            } else {
                [self rotateRingRightTurns:randRotation];
                [self rotateColorSegRightTurns:randRotation];
            }
        }
        
    }
}

- (void)incrementWaveLevel {
    self.currentlevelNumber++;
    self.currentlevel = [self.levels objectForKey:@(self.currentlevelNumber)];
    
    self.currentCountDown = [[self.currentlevel objectForKey:@"countDown"] intValue];
    self.countDownLabel.text = NSStringFromInt(self.currentCountDown);
    
    self.score = [[self.currentlevel objectForKey:@"turnCount"] intValue];
    self.scoreLabel.text = NSStringFromInt([[self.currentlevel objectForKey:@"turnCount"] intValue]);
    
    self.currentWave++;
    self.waveLabel.text = NSStringFromInt(self.currentWave);
}

- (void)incrementTimeLevel {
    if (self.currentTurnCount == [[self.currentlevel objectForKey:@"turnCount"] integerValue]) {
        self.currentTurnCount = 1;
        self.currentlevelNumber++;
        self.currentlevel = [self.levels objectForKey:@(self.currentlevelNumber)];
    }
}

- (void)initArcadeMode {
    self.waveLabel.hidden = NO;
    self.waveStaticLabel.hidden = NO;
    
    self.scoreStaticLabel.text = @"Balls";
    
    self.levels = @{ @(1) : @{@"turnCount":@(5),
                              @"rotationProbability": [NSNull new],
                              @"countDown" : @(6)
                              },
                     @(2) : @{@"turnCount":@(8),
                              @"rotationProbability":@(3),
                              @"countDown" : @(5)
                              },
                     @(3) : @{@"turnCount":@(10),
                              @"rotationProbability":@(2),
                              @"countDown" : @(6)
                              },
                     @(4) : @{@"turnCount":@(15),
                              @"rotationProbability":@(1),
                              @"countDown" : @(10)
                              },
                     @(5) : @{@"turnCount":@(15),
                              @"rotationProbability":@(0),
                              @"countDown" : @(11)
                              },
                     @(6) : @{@"turnCount":@(13),
                              @"rotationProbability":@(0),
                              @"countDown" : @(8)
                              },
                     @(7) : @{@"turnCount":@(11),
                              @"rotationProbability":@(0),
                              @"countDown" : @(6)
                              },
                     @(8) : @{@"turnCount":@(10),
                              @"rotationProbability":@(0),
                              @"countDown" : @(5)
                              },
                     @(9) : @{@"turnCount":@(12),
                               @"rotationProbability":@(3),
                               @"countDown" : @(8)
                               },
                     @(10) : @{@"turnCount":@(13),
                               @"rotationProbability":@(2),
                               @"countDown" : @(8)
                               },
                     @(11) : @{@"turnCount":@(11),
                               @"rotationProbability":@(0),
                               @"countDown" : @(8)
                               },
                     @(12) : @{@"turnCount":@(10),
                               @"rotationProbability":@(0),
                               @"countDown" : @(5)
                               },
                     @(13) : @{@"turnCount":@(9),
                               @"rotationProbability":@(0),
                               @"countDown" : @(4)
                               },
                     @(14) : @{@"turnCount":@(8),
                               @"rotationProbability":@(0),
                               @"countDown" : @(4)
                               },
                     @(15) : @{@"turnCount":@(5),
                               @"rotationProbability":@(0),
                               @"countDown" : @(2)
                               },
                     @(16) : @{@"turnCount":@(7),
                               @"rotationProbability":@(0),
                               @"countDown" : @(3)
                               },
                     @(17) : @{@"turnCount":@(8),
                               @"rotationProbability":@(0),
                               @"countDown" : @(4)
                               },
                     @(18) : @{@"turnCount":@(10),
                               @"rotationProbability":@(0),
                               @"countDown" : @(5)
                               },
                     @(19) : @{@"turnCount":@(11),
                               @"rotationProbability":@(0),
                               @"countDown" : @(7)
                               },
                     @(20) : @{@"turnCount":@(13),
                              @"rotationProbability":@(0),
                              @"countDown" : @(8)
                              },
                     @(21) : @{@"turnCount":@(12),
                               @"rotationProbability":@(0),
                               @"countDown" : @(4)
                               },
                     };

    
    self.currentlevelNumber = 1;
    self.currentlevel = [self.levels objectForKey:@(self.currentlevelNumber)];
    self.currentTurnCount = 1;
    
    self.currentCountDown = [[self.currentlevel objectForKey:@"countDown"] intValue];
    self.countDownLabel.text = NSStringFromInt(self.currentCountDown);
    
    self.score = [[self.currentlevel objectForKey:@"turnCount"] intValue];
    self.scoreLabel.text = NSStringFromInt([[self.currentlevel objectForKey:@"turnCount"] intValue]);
    
    
    self.currentWave = 1;
    self.waveLabel.text = NSStringFromInt(self.currentWave);
}

- (void)initTimeMode {
    self.waveLabel.hidden = YES;
    self.waveStaticLabel.hidden = YES;
    
    self.scoreStaticLabel.text = @"Points";
    
    self.levels = @{ @(1) : @{@"turnCount":@(5),
                              @"rotationProbability": [NSNull new]
                              },
                     @(2) : @{@"turnCount":@(8),
                              @"rotationProbability":@(3)
                              },
                     @(3) : @{@"turnCount":@(10),
                              @"rotationProbability":@(2)
                              },
                     @(4) : @{@"turnCount":@(20),
                              @"rotationProbability":@(1)
                              },
                     @(5) : @{@"turnCount":@(INT_MAX),
                              @"rotationProbability":@(1)
                              },
                     };
    self.currentlevelNumber = 1;
    self.currentlevel = [self.levels objectForKey:@(self.currentlevelNumber)];
    self.currentTurnCount = 1;
    
    self.currentCountDown = startingCountDown;
    self.countDownLabel.text = NSStringFromInt(self.currentCountDown);
    self.score = 0;
    self.scoreLabel.text = [NSString stringWithFormat:@"%d", self.score];
}

- (void)initRingState {
    double rads = DEGREES_TO_RADIANS(-45);
    CGAffineTransform transform = CGAffineTransformRotate(self.ring.transform, rads);
    CGAffineTransform scaleTrans  = CGAffineTransformScale(transform,
                                                           .70, .70);
    [UIView animateWithDuration:.4 animations:^{
        self.ring.transform = scaleTrans;
        
    }];
    
  
    [self rotateColorSegLeftTurns:1];
}

-(BOOL)isBall:(UIView *)ball matchRingSegment:(RingSegment)ringSegment{
    
    if (ball.tag != [self.colorSeg[ringSegment] integerValue]) {
        return YES;
    }
    return NO;
}

- (void)handleUserError {
    id soundSetting = [[NSUserDefaults standardUserDefaults] objectForKey:@"enableSound"];
    if (soundSetting) {
        if ([soundSetting boolValue]) {
            NSError *soundError = nil;
            self.failPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"fail" ofType:@"wav"]] error:&soundError];
            [self.failPlayer setVolume:1];
            
            if(self.failPlayer == nil)
                NSLog(@"%@",soundError);
            [self.failPlayer play];
        }
    }
    
    id vibrationSetting = [[NSUserDefaults standardUserDefaults] objectForKey:@"enableVibration"];
    if (vibrationSetting) {
        if ([vibrationSetting boolValue]) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
    }
    
    if (self.gameMode == GameModeTimeAttack) {
        self.score--;
    } else if (self.gameMode == GameModeArcade) {
        //game over
        [self.countDownTimer invalidate];
        
        [self performSegueWithIdentifier:@"toGameOverScreen" sender:self];
    }
}

- (void)handleUserSuccess {
    id soundSetting = [[NSUserDefaults standardUserDefaults] objectForKey:@"enableSound"];
    if (soundSetting) {
        if ([soundSetting boolValue]) {
            
            [self.player play];
        }
    }
    
    if (self.gameMode == GameModeTimeAttack) {
        self.score++;
    } else if (self.gameMode == GameModeArcade) {
        self.score--;
    }
}

@end
