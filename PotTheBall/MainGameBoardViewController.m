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
@interface MainGameBoardViewController ()

@property (nonatomic)BOOL isAnimation;

@property (nonatomic, strong)NSMutableArray *balls;
@property (nonatomic, strong)NSArray *ballImagesNames;

@property (nonatomic, strong)NSMutableArray *colorSeg;

@property int topBottomScreenOffset;
@property int leftRightScreenOffset;


@property (nonatomic, strong)NSTimer *countDownTimer;
@property int score;


@property (nonatomic)int currentCountDown;

@end

@implementation MainGameBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    self.ball = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"multi-color"]];
//    self.ball.tag = 0;
    
    
    self.currentCountDown = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    if (self.gameState == GameStatePrepareStart) {
//        for (UIView *view in self.hudComponentViews) {
//            view.hidden = YES;
//        }
        
        self.ball.hidden = YES;
        self.playButton.hidden = NO;
        
    
    [NSTimer bk_scheduledTimerWithTimeInterval:0.3 block:^(NSTimer *timer) {
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
        
        double rads = DEGREES_TO_RADIANS(-45);
        CGAffineTransform transform = CGAffineTransformRotate(self.ring.transform, rads);
        CGAffineTransform scaleTrans  = CGAffineTransformScale(transform,
                                                               .70, .70);
        [UIView animateWithDuration:.5 animations:^{
            self.ring.transform = scaleTrans;
            
        }];
        
        //    [self rotateColorSegRightTurns:1];
        [self rotateColorSegLeftTurns:1];
    

            } repeats:NO];
        
    }
    
    
    
    

}


-(void)viewDidAppear:(BOOL)animated{
    if (self.gameState != GameStatePrepareStart) {
        
        
        [self.view addSubview:self.ball];
        
        
        self.balls = [NSMutableArray new];
        [self.balls addObject:self.ball];
        
        
        self.ballImagesNames = @[@"multi-color",
                                 @"green",
                                 @"orange",
                                 @"red",
                                 @"blue"];
        
        self.colorSeg = [@[@(3), @(1), @(4), @(2)] mutableCopy];
        
        
        self.topBottomScreenOffset = CGRectGetHeight(self.ball.frame) * -1;
        self.leftRightScreenOffset = (CGRectGetMinY(self.ball.frame) - CGRectGetMinX(self.ball.frame)) * -1;
        
        self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateCountDownLabel:) userInfo:nil repeats:YES];
        
        
    }
    
    
}

-(void)viewDidLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    self.bonusBalls.layer.cornerRadius = self.bonusBalls.frame.size.height/2;
    CGRect rect = self.ball.frame;
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGRect rect = self.ball.frame;
        NSLog(@"simple print-----rect------{%@}", NSStringFromCGRect(self.ball.frame));
//        [self.ball removeAllConstraints];
        self.ball = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"multiPlayBall"]];
        self.ball.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2 - CGRectGetWidth(rect)/2, CGRectGetHeight(self.view.frame)/2 - CGRectGetHeight(rect)/2, CGRectGetWidth(rect), CGRectGetHeight(rect));
//        self.ball.frame = rect;
    });

    
    
//    for (NSLayoutConstraint *constraint in self.ball.constraints) {
//    }
//    self.ball.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2 - (56/2), CGRectGetHeight(self.view.frame)/2 - (56/2), 56, 56);
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

- (void)animateFullScale:(UIView *)newBall {
    [UIView mt_animateWithViews:@[newBall]
                       duration:1
                 timingFunction:kMTEaseOutElastic
                     animations:^{
                         newBall.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                         //                             self.organView.alpha = 1;
                         
                         
                     }];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//    super.continueTrackingWithTouch(touch, withEvent: event)
    
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
            
            
            if (ball.tag != 0 && ball.tag != [self.colorSeg[0] integerValue] ) {
                self.score--;
            } else {
                self.score++;
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
            
            if (ball.tag != [self.colorSeg[3] integerValue] && ball.tag != 0) {
                self.score--;
            } else {
                self.score++;
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
            
            if (ball.tag != [self.colorSeg[1] integerValue] && ball.tag != 0) {
                self.score--;
            } else {
                self.score++;
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
            
            if (ball.tag != [self.colorSeg[2] integerValue] && ball.tag != 0) {
                self.score--;
            } else {
                self.score++;
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

-(UIImageView *)newBallImageWithFrame:(CGRect)rect{
    int rand = arc4random_uniform([self.ballImagesNames count]);
    UIImageView *newBall = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.ballImagesNames[rand]]];
    newBall.frame = rect;
    newBall.tag = rand;
    newBall.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5);
    return newBall;
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    self.isAnimation = NO;
}

- (IBAction)printSubViews:(id)sender {
    NSLog(@"simple print-----subView------{%@}", self.view.subviews);
}
- (IBAction)rotate:(id)sender {
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
    
    double rads = DEGREES_TO_RADIANS(-90);
    CGAffineTransform transform = CGAffineTransformRotate(self.ring.transform, rads);
    [UIView animateWithDuration:.5 animations:^{
        self.ring.transform = transform;
    }];

//    [self rotateColorSegRightTurns:1];
    [self rotateColorSegLeftTurns:1];
    NSLog(@"simple print-----after------{%@}", self.colorSeg);
}

-(void)rotateColorSegRightTurns:(int)truns{
    id lastObject;
    for (int i = 0; i < truns; i++) {
        for (int k = self.colorSeg.count; k != 0; k--) {
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
-(void)start{
    
}
- (IBAction)startGame:(id)sender {
    if (self.gameState == GameStatePrepareStart) {
        self.ball.hidden = NO;
        self.playButton.hidden = YES;
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
        
        double rads = DEGREES_TO_RADIANS(45);
        CGAffineTransform transform = CGAffineTransformRotate(self.ring.transform, rads);
        CGAffineTransform scaleTrans  = CGAffineTransformScale(transform,
                                                               1.429, 1.429);
        [UIView animateWithDuration:.5 animations:^{
            self.ring.transform = scaleTrans;
            
        }];
        
            [self rotateColorSegRightTurns:1];
//        [self rotateColorSegLeftTurns:1];

        
        [self.view addSubview:self.ball];
        
        
        self.balls = [NSMutableArray new];
        [self.balls addObject:self.ball];
        
        
        self.ballImagesNames = @[@"multi-color",
                                 @"green",
                                 @"orange",
                                 @"red",
                                 @"blue"];
        
        self.colorSeg = [@[@(3), @(1), @(4), @(2)] mutableCopy];
        
        
        self.topBottomScreenOffset = CGRectGetHeight(self.ball.frame) * -1;
        self.leftRightScreenOffset = (CGRectGetMinY(self.ball.frame) - CGRectGetMinX(self.ball.frame)) * -1;
        
        self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateCountDownLabel:) userInfo:nil repeats:YES];

    }
}

- (IBAction)home:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[GameOverViewController class]]) {
        GameOverViewController *gameOverViewController = (GameOverViewController *)segue.destinationViewController;
        
        gameOverViewController.score = self.score;
    }
}
-(IBAction)unwindToGameBoard:(UIStoryboardSegue *)segue {
}
@end
