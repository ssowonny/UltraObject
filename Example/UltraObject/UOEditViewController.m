//
//  UOEditViewController.m
//  UltraObject
//
//  Created by Sungwon Lee on 8/18/15.
//  Copyright (c) 2015 Sungwon Lee. All rights reserved.
//

#import "UOEditViewController.h"
#import "UOPost.h"

@interface UOEditViewController ()
@property (nonatomic, weak) IBOutlet UITextField *contentTextField;
@end

@implementation UOEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self bindPost];
}

- (IBAction)doneButtonPressed:(id)sender {
    [self savePost];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private

- (void)savePost {
    [_post edit:^(UOMutablePost *post) {
        post.content = _contentTextField.text;
    }];
}

- (void)bindPost {
    _contentTextField.text = _post.content;
}

@end
