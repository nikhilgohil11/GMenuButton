//
//  ViewController.m
//  GMenuButton
//
//  Created by Nikhil Gohil on 17/03/16.
//  Copyright © 2016 Nikhil Gohil. All rights reserved.
//

#import "ViewController.h"
#import "UIView+MaterialDesign.h"
#import "AnimatedMenuButton.h"
const NSTimeInterval MDViewOneAnimationDuration1		= 0.5;

@interface ViewController ()<GMenuButtonDelegate>{
    UIView *backGroundView;
    CGPoint position;
    AnimatedMenuButton *button;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor colorWithRed:33.0/255.0f green:37.0/255.0 blue:46.0/255.0f alpha:1.0f];
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"S" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor colorWithRed:33.0/255.0f green:90.0/255.0f blue:167.0/255.0f alpha:1.0f];
    btn.frame = CGRectMake(0, 0, 40.0, 40.0);
    btn.layer.cornerRadius = 20.0f;
    btn.layer.borderColor = [UIColor colorWithWhite:255.0f alpha:0.5].CGColor;
    btn.layer.borderWidth = 1.0f;
    [arr addObject:btn];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setTitle:@"S" forState:UIControlStateNormal];
    btn1.backgroundColor = [UIColor colorWithRed:33.0/255.0f green:90.0/255.0f blue:167.0/255.0f alpha:1.0f];
    btn1.frame = CGRectMake(0, 0, 40.0, 40.0);
    btn1.layer.cornerRadius = 20.0f;
    btn1.layer.borderColor = [UIColor colorWithWhite:255.0f alpha:0.5].CGColor;
    btn1.layer.borderWidth = 1.0f;
    [arr addObject:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setTitle:@"S" forState:UIControlStateNormal];
    btn2.frame = CGRectMake(0, 0, 40.0, 40.0);
    btn2.backgroundColor = [UIColor colorWithRed:33.0/255.0f green:90.0/255.0f blue:167.0/255.0f alpha:1.0f];
    btn2.layer.cornerRadius = 20.0f;
    btn2.layer.borderWidth = 1.0f;
    btn2.layer.borderColor = [UIColor colorWithWhite:255.0f alpha:0.5].CGColor;
    [arr addObject:btn2];
    
    button = [[AnimatedMenuButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-20, self.view.frame.size.height - 80, 40.0, 40.0) Images:arr withParentView:self.view];
    button.deafultAlignment = true;
    button.delegate = self;
    button.layer.cornerRadius = 20.0f;
    button.layer.borderWidth = 1.0f;
    button.layer.borderColor = [UIColor colorWithWhite:255.0f alpha:0.5].CGColor;
    button.backgroundColor = [UIColor colorWithRed:33.0/255.0f green:90.0/255.0f blue:167.0/255.0f alpha:1.0f];
    button.primaryColor = [UIColor colorWithRed:33.0/255.0f green:90.0/255.0f blue:167.0/255.0f alpha:1.0f];
    button.secondaryColor = [UIColor whiteColor];
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [[button titleLabel] setFont:[UIFont systemFontOfSize:35.0f]];
    [button setTitle:@"+" forState:UIControlStateNormal];
    [self.view addSubview:button];
}


-(void)itemClicked:(int )index{
    NSLog(@"index: %d",index);
    //    [button closeMenu];
}

-(void)menuButtonClicked{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
