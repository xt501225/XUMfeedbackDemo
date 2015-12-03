//
//  ViewController.m
//  XUMfeedbackDemo
//
//  Created by 敏杰 倪 on 15/12/3.
//  Copyright © 2015年 LingQi. All rights reserved.
//

#import "ViewController.h"
#import "XUMFeedbackViewController.h"

@interface ViewController ()<XUMFeedbackViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)feedbackAction:(id)sender
{
    XUMFeedbackViewController *feedbackVC = [XUMFeedbackViewController new];
    feedbackVC.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:feedbackVC];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)didDismissXUMFeedbackViewController:(XUMFeedbackViewController *)vc
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
