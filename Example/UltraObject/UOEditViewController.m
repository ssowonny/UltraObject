//
//  UOEditViewController.m
//  UltraObject
//
//  Created by Sungwon Lee on 8/18/15.
//  Copyright (c) 2015 Sungwon Lee. All rights reserved.
//

#import "UOEditViewController.h"
#import "UOPost.h"

static NSUInteger __latestPostID = 100;

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
    if (_post.id) {
        [_post edit:^(UOMutablePost *post) {
            post.content = _contentTextField.text;
        }];
    } else {
        [UOPost newWithJSON:@{@"id": @(__latestPostID ++),
                              @"content": _contentTextField.text,
                              @"user": @{@"id": @100, @"name": @"Guybrush Threepwood"}}];
    }
}

- (void)bindPost {
    _contentTextField.text = _post.content;
}

@end
