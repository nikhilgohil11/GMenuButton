//
//  GMenuButton.h
//  GMenuButton
//
//  Created by Nikhil Gohil on 13/01/16.
//  Copyright © 2016 Nikhil Gohil. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AnimatedMenuButton;
@protocol GMenuButtonDelegate <NSObject>
@optional
- (void)itemClicked:(int)index;
- (void)menuButtonClicked;
@end

@interface AnimatedMenuButton : UIButton

@property (nonatomic, strong, readonly) UIScrollView *contentView;
@property (nonatomic, strong, readonly) UIView *backgroundView;
@property (nonatomic, strong, readonly) UIView *parentView;
@property (nonatomic) int clickedButtonIndex;
@property (nonatomic) bool deafultAlignment;
@property (nonatomic, strong) UIColor *primaryColor;
@property (nonatomic, strong) UIColor *secondaryColor;
@property (nonatomic, strong) NSMutableArray *itemViews;
@property (nonatomic, weak) id <GMenuButtonDelegate> delegate;
@property(nonatomic) bool fixedContentSize;

- (instancetype)initWithFrame:(CGRect)rect Images:(NSMutableArray *)items withParentView:(UIView *)parent;
- (void)closeMenu;
@end
