//
//  GMenuButton.m
//  GMenuButton
//
//  Created by Nikhil Gohil on 13/01/16.
//  Copyright © 2016 Nikhil Gohil. All rights reserved.
//

#import "AnimatedMenuButton.h"
#import "UIView+MaterialDesign.h"

const NSTimeInterval MDViewOneAnimationDuration		= 0.5;

@interface AnimatedMenuButton(){
    CGPoint position;
    CGRect menuFrame;
    CGPoint centerPoint;
}
-(void)ShowRingAndPumpUp:(UIButton*)sender;
@end

@implementation AnimatedMenuButton

- (instancetype)initWithFrame:(CGRect)rect Images:(NSMutableArray *)items withParentView:(UIView *)parent{
    if (self = [super initWithFrame:rect]) {
        
        self.tag = -1;
        
        self.clickedButtonIndex = 0;
        
        menuFrame = rect;
        
        centerPoint = self.center;
        _contentView = [[UIScrollView alloc] init];
        _contentView.alwaysBounceHorizontal = YES;
        _contentView.alwaysBounceVertical = NO;
        _contentView.bounces = YES;
        _contentView.clipsToBounds = NO;
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.showsVerticalScrollIndicator = NO;
        [_contentView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        
        _primaryColor = [UIColor redColor];
        _secondaryColor = [UIColor whiteColor];
        
        _parentView = parent;
        
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.parentView.frame.size.height - self.frame.size.height*3, self.parentView.frame.size.width, self.frame.size.height*3)];
        
        [self.backgroundView addSubview:self.contentView];
        
        _itemViews = items;
        
        [self addTarget:self action:@selector(showDetailsAction:event:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)showItems {
    CGFloat topPadding = self.backgroundView.frame.size.height - (self.frame.size.height*2);
    CGFloat leftPadding = self.frame.origin.x;
    __block CGFloat width =0;
    __block CGPoint point = CGPointMake(self.backgroundView.frame.size.width - (leftPadding + (self.frame.size.width/2)),(self.frame.size.width + self.frame.size.width/2));
    [self.itemViews enumerateObjectsUsingBlock:^(UIButton *view, NSUInteger idx, BOOL *stop) {
        if(self.deafultAlignment){
            if(idx == 0){
                view.center = CGPointMake(self.center.x + ((point.x - self.center.x)/3),point.y);
            }
            
            if (idx == 1) {
                view.center = CGPointMake(self.center.x + (((point.x - self.center.x)/3)*2),point.y);
            }
            
            if ((self.itemViews.count-1) == idx){
                view.center = point;
            }
        }else{
            CGRect frame = CGRectMake(leftPadding + self.frame.size.width*(idx+1) + leftPadding*(idx+1), topPadding, self.frame.size.width, self.frame.size.height);
            view.frame = frame;
            width = view.frame.origin.x + view.frame.size.width;
        }
    }];
    
    __block int count = 1;
    [self.itemViews enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
        [button setTag:count];
        count++;
        [button addTarget:self action:@selector(itemClicked:event:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
    }];
    
    CGFloat initDelay = 0.1f;
    
    [self.itemViews enumerateObjectsUsingBlock:^(UIButton *view, NSUInteger idx, BOOL *stop) {
        view.layer.transform = CATransform3DMakeScale(0.3, 0.3, 0.3);
        view.alpha = 0;
        [self animateSpringWithView:view idx:idx initDelay:initDelay];
    }];
    if(self.fixedContentSize){
        width = self.frame.size.width;
        self.contentView.alwaysBounceHorizontal = NO;
        self.contentView.bounces = NO;
    }else{
        width = width + (self.frame.size.width/2);
    }
    self.contentView.contentSize = CGSizeMake(width,self.contentView.frame.size.height);
}



- (void)hideItems {
    
    CGFloat initDelay = 0.1f;
    
    [self.itemViews enumerateObjectsUsingBlock:^(UIButton *view, NSUInteger idx, BOOL *stop) {
        view.alpha = 1;
        view.layer.transform = CATransform3DIdentity;
        [self animateSpringWithView:view idx:idx initDelay:initDelay];
    }];
    
    self.contentView.contentSize = CGSizeMake(0, 0);
    
    [self.itemViews enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
        button.selected = false;
        [button removeFromSuperview];
    }];
}


#pragma mark - Show

- (void)animateSpringWithViewClose:(UIButton *)view idx:(NSUInteger)idx initDelay:(CGFloat)initDelay {
    [UIView animateWithDuration:0.25
                          delay:(initDelay + idx*0.1f)
         usingSpringWithDamping:10
          initialSpringVelocity:50
                        options:0
                     animations:^{
                         view.layer.transform = CATransform3DMakeScale(0.3, 0.3, 1);
                         view.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (void)animateSpringWithView:(UIButton *)view idx:(NSUInteger)idx initDelay:(CGFloat)initDelay {
    [UIView animateWithDuration:0.5
                          delay:(initDelay + idx*0.1f)
         usingSpringWithDamping:10
          initialSpringVelocity:50
                        options:0
                     animations:^{
                         view.layer.transform = CATransform3DIdentity;
                         view.alpha = 1;
                     }
                     completion:^(BOOL finished){
                     }];
}


- (void)itemClicked:(UIButton *)sender event:(UIEvent *)event {
    [self disableUserInterAction];
    [self ShowRingAndPumpUpForItem:sender];
    self.clickedButtonIndex = (int)sender.tag;
}

-(void)ShowRingAndPumpUpForItem:(UIButton*)sender{
    
    
    UIBezierPath *movePath = [UIBezierPath bezierPath];
    [movePath moveToPoint:sender.center];
    [movePath addLineToPoint:CGPointMake(40.0f, sender.center.y)];
    
    CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveAnim.duration = 0.5f;
    moveAnim.path                = movePath.CGPath;
    moveAnim.removedOnCompletion = NO;
    
    CGRect pathFrame = CGRectMake(-CGRectGetMidX(sender.bounds), -CGRectGetMidY(sender.bounds), sender.bounds.size.width, sender.bounds.size.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pathFrame cornerRadius:sender.layer.cornerRadius];
    
    // accounts for left/right offset and contentOffset of scroll view
    CGPoint shapePosition = [self.contentView convertPoint:sender.center fromView:self.contentView];
    
    CAShapeLayer *circleShape = [CAShapeLayer layer];
    circleShape.path = path.CGPath;
    circleShape.position = shapePosition;
    circleShape.fillColor = [UIColor clearColor].CGColor;
    circleShape.opacity = 0;
    circleShape.strokeColor = [UIColor whiteColor].CGColor;
    circleShape.lineWidth = 2.0f;
    
    [self.contentView.layer addSublayer:circleShape];
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.duration = 0.125;
    anim.repeatCount = 1;
    anim.autoreverses = YES;
    anim.removedOnCompletion = YES;
    anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)];
    [sender.layer addAnimation:anim forKey:nil];
    
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(2.5, 2.5, 1)];
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @1;
    alphaAnimation.toValue = @0;
    
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.animations = @[scaleAnimation, alphaAnimation];
    animation.duration = 0.30f;
    animation.delegate = self;
    [animation setValue:@"groupAnimationItem" forKey:@"animationName"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [circleShape addAnimation:animation forKey:@"groupAnimationItem"];
}


- (void)showDetailsAction:(UIButton *)sender event:(UIEvent *)event {
    [self disableUserInterAction];
    if (self.delegate) {
        [self.delegate menuButtonClicked];
    }
    if (!self.selected) {
        position = sender.center;
        [self.parentView insertSubview:self.backgroundView belowSubview:self];
        position = CGPointMake(self.backgroundView.frame.size.width/2, self.backgroundView.frame.size.height/2);
        [self ShowRingAndPumpUp:self];

    }else{
        self.clickedButtonIndex = 0;
        [self ShowRingAndPumpUp:self];
    }
}

- (void)closeMenu{
    [self disableUserInterAction];
    self.clickedButtonIndex = 0;
    [self ShowRingAndPumpUp:self];
}

-(void)enableUserInteraction{
    self.userInteractionEnabled = true;
    [self.itemViews enumerateObjectsUsingBlock:^(UIButton *view, NSUInteger idx, BOOL *stop) {
        view.userInteractionEnabled = true;
    }];
}

-(void)disableUserInterAction{
    self.userInteractionEnabled = false;
    [self.itemViews enumerateObjectsUsingBlock:^(UIButton *view, NSUInteger idx, BOOL *stop) {
        view.userInteractionEnabled = false;
    }];
}

-(void)ShowRingAndPumpUp:(UIButton*)sender{
    
    UIBezierPath *movePath = [UIBezierPath bezierPath];
    [movePath moveToPoint:sender.center];
    [movePath addLineToPoint:CGPointMake(40.0f, sender.center.y)];

    CGRect pathFrame = CGRectMake(-CGRectGetMidX(sender.bounds), -CGRectGetMidY(sender.bounds), sender.bounds.size.width, sender.bounds.size.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pathFrame cornerRadius:sender.layer.cornerRadius];
    
    // accounts for left/right offset and contentOffset of scroll view
    CGPoint shapePosition = [self.parentView convertPoint:self.center fromView:self.parentView];
    
    CAShapeLayer *circleShape = [CAShapeLayer layer];
    circleShape.path = path.CGPath;
    circleShape.position = shapePosition;
    circleShape.fillColor = [UIColor clearColor].CGColor;
    circleShape.opacity = 0;
    if (sender.selected) {
        circleShape.strokeColor = self.secondaryColor.CGColor;
    }else{
        circleShape.strokeColor = self.primaryColor.CGColor;
    }
    circleShape.lineWidth = 2.0f;
    
    [self.parentView.layer addSublayer:circleShape];
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.duration = 0.125;
    anim.repeatCount = 1;
    anim.autoreverses = YES;
    anim.removedOnCompletion = YES;
    anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)];
    [sender.layer addAnimation:anim forKey:nil];
    
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(2.5, 2.5, 1)];
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @1;
    alphaAnimation.toValue = @0;
    
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.animations = @[scaleAnimation, alphaAnimation];
    animation.duration = 0.30f;
    animation.delegate = self;
    animation.removedOnCompletion = YES;
    if (sender.selected) {
        [animation setValue:@"groupAnimationFinished" forKey:@"animationName"];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [circleShape addAnimation:animation forKey:@"groupAnimationFinished"];
    }else{
        [animation setValue:@"groupAnimation" forKey:@"animationName"];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [circleShape addAnimation:animation forKey:@"groupAnimation"];
    }
}


- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)finished
{
    if (finished)
    {
        NSString *animationName = [animation valueForKey:@"animationName"];
        if ([animationName isEqualToString:@"groupAnimation"])
        {
            [self animateCenterButton:self];
            [self.backgroundView mdInflateAnimatedFromPoint:position backgroundColor:self.primaryColor duration:MDViewOneAnimationDuration completion:^{
                self.contentView.frame = CGRectMake(0, 0, self.backgroundView.frame.size.width, self.backgroundView.frame.size.width);
                self.center = CGPointMake(self.backgroundView.frame.origin.x + (self.frame.size.width*1.5),self.backgroundView.center.y);
                [self.layer removeAllAnimations];
                [self showItems];
                [self enableUserInteraction];
            }];
        }else if([animationName isEqualToString:@"groupAnimationFinished"]){
            [self hideItems];
            [self animateCenterButton:self];
        }else if([animationName isEqualToString:@"groupAnimationItem"]){

            [self hideItems];
            [self animateCenterButton:self];
        }else if ([animationName isEqualToString:@"DisplacemnetAnimation"]){
            if (self.selected) {
                self.center = centerPoint;
                [self hideItems];
                [self.backgroundView mdDeflateAnimatedToPoint:position backgroundColor:[UIColor clearColor] duration:MDViewOneAnimationDuration completion:^{
                    NSLog(@"animationDidStop mdDeflateAnimatedToPoint");

                    self.contentView.frame = CGRectMake(0, 0, self.backgroundView.frame.size.width, self.backgroundView.frame.size.width);
                    [self.backgroundView removeFromSuperview];
                    [self.layer removeAllAnimations];
                    self.selected = false;
                    [self enableUserInteraction];
                    
                }];
            }else{
                self.center = CGPointMake(self.backgroundView.frame.origin.x + (self.frame.size.width*1.5),self.backgroundView.center.y);
                self.selected = true;
                [self.layer removeAllAnimations];
                [self showItems];
                [self enableUserInteraction];
            }
        }else if ([animationName isEqualToString:@"DisplacemnetAnimationFinished"]){
            self.center = centerPoint;
            [self.backgroundView mdDeflateAnimatedToPoint:position backgroundColor:[UIColor clearColor] duration:MDViewOneAnimationDuration completion:^{

                self.contentView.frame = CGRectZero;
                [self.backgroundView removeFromSuperview];
                [self.layer removeAllAnimations];
                self.selected = false;
                [self enableUserInteraction];
                if (self.delegate) {
                    [self.delegate itemClicked:self.clickedButtonIndex];
                }
            }];
        }
    }
}

-(void) animateCenterButton:(UIButton*) btn{
    
    CGPoint origCenter;
    CGRect origFrame;
    origFrame  = btn.frame;
    origCenter = btn.center;
    
    if (btn.selected) {
        UIBezierPath *movePath = [UIBezierPath bezierPath];
        [movePath moveToPoint:origCenter];
        [movePath addLineToPoint:centerPoint];
        
        CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        moveAnim.path                = movePath.CGPath;
        moveAnim.removedOnCompletion = NO;
        moveAnim.duration = 0.5f;
        /**
         * Setup rotation animation
         */
        
        CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        rotateAnimation.duration = 0.25f;
        rotateAnimation.fromValue = [NSNumber numberWithFloat:0];
        rotateAnimation.toValue = [NSNumber numberWithFloat:2 * M_PI];
        rotateAnimation.repeatCount = 2;
        rotateAnimation.removedOnCompletion = NO;
        /**
         * Setup and add all animations to the group
         */
        CAAnimationGroup *group = [CAAnimationGroup animation];
        
        [group setAnimations:[NSArray arrayWithObjects:moveAnim, rotateAnimation, nil]];
        
        group.fillMode            = kCAFillModeForwards;
        group.removedOnCompletion = NO;
        group.duration            = 0.5f;
        group.delegate            = self;
        
        [group setValue:@"DisplacemnetAnimationFinished" forKey:@"animationName"];

        /**
         * ...and go
         */
        [btn.layer addAnimation:group forKey:@"DisplacemnetAnimationFinished"];
        
    }else{
        
        UIBezierPath *movePath = [UIBezierPath bezierPath];
        
        [movePath moveToPoint:btn.center];
        [movePath addLineToPoint:CGPointMake(self.backgroundView.frame.origin.x + (self.frame.size.width*1.5),self.backgroundView.center.y)];
        
        CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        
        moveAnim.path                = movePath.CGPath;
        moveAnim.removedOnCompletion = NO;
        moveAnim.duration = 0.5f;
        
        /**
         * Setup rotation animation
         */
        
        CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        rotateAnimation.duration = 0.25f;
        rotateAnimation.fromValue = [NSNumber numberWithFloat:0];
        rotateAnimation.toValue = [NSNumber numberWithFloat:-(2 * M_PI)];
        rotateAnimation.repeatCount = 2;
        rotateAnimation.removedOnCompletion = NO;
        /**
         * Setup and add all animations to the group
         */
        CAAnimationGroup *group = [CAAnimationGroup animation];
        
        [group setAnimations:[NSArray arrayWithObjects:moveAnim, rotateAnimation, nil]];
        
        group.fillMode            = kCAFillModeForwards;
        group.removedOnCompletion = NO;
        group.duration            = 0.5f;
        group.delegate            = self;
        
        [group setValue:@"DisplacemnetAnimation" forKey:@"animationName"];
        
        /**
         * ...and go
         */
        [btn.layer addAnimation:group forKey:@"DisplacemnetAnimation"];
    }
}


@end
