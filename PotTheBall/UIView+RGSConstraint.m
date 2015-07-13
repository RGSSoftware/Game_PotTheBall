//
//  UIView+RGSConstraint.m
//  PotTheBall
//
//  Created by PC on 6/28/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import "UIView+RGSConstraint.h"

@implementation UIView (RGSConstraint)

-(NSLayoutConstraint *)constraintWidth{
    for (NSLayoutConstraint *constraint in self.constraints) {
        if (constraint.firstAttribute == 7) {
            return constraint;
        }
    }
    return nil;
}

-(NSLayoutConstraint *)constraintHeight{
    for (NSLayoutConstraint *constraint in self.constraints) {
        if (constraint.firstAttribute == 8) {
            return constraint;
            
        }
    }
    return nil;
}

@end
