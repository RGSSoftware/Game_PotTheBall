//
//  UIView+RemoveConstraints.m
//  PotTheBall
//
//  Created by PC on 7/10/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import "UIView+RemoveConstraints.h"

@implementation UIView (RemoveConstraints)
- (void)removeAllConstraints
{
    UIView *superview = self.superview;
    while (superview != nil) {
        for (NSLayoutConstraint *c in superview.constraints) {
            if (c.firstItem == self || c.secondItem == self) {
                [superview removeConstraint:c];
            }
        }
        superview = superview.superview;
    }
    
    [self removeConstraints:self.constraints];
    self.translatesAutoresizingMaskIntoConstraints = YES;
}
@end
