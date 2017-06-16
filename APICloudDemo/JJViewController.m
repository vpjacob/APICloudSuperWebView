//
//  JJViewController.m
//  APICloudDemo
//
//  Created by 刘毅 on 2017/6/16.
//  Copyright © 2017年 vpjacob. All rights reserved.
//

#import "JJViewController.h"

@interface JJViewController ()

@end

@implementation JJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
}

    - (void)viewWillAppear:(BOOL)animated{
        [super viewWillAppear:animated];
        [self.navigationController setNavigationBarHidden:NO];
    }
    - (void)viewWillDisappear:(BOOL)animated{
        [super viewWillDisappear:animated];
        [self.navigationController setNavigationBarHidden:YES];
    }
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
