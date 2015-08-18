//
//  UOPostViewController.m
//  UltraObject
//
//  Created by Sungwon Lee on 8/17/15.
//  Copyright (c) 2015 Sungwon Lee. All rights reserved.
//

#import "UOPostViewController.h"
#import "UOPost.h"
#import "UOUser.h"

@interface UOPostViewController ()
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@property (nonatomic, weak) IBOutlet UILabel *userNameLabel;
@end

@implementation UOPostViewController

- (void)setPost:(UOPost *)post {
    if (_post) {
        [_post removeObservingTarget:self action:@selector(onPostEvent:)];
    }
    _post = post;
    [post addObservingTarget:self action:@selector(onPostEvent:)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self bindPost];
}

- (void)onPostEvent:(UOPost *)post {
    [self bindPost];
}

#pragma mark - Private

- (void)bindPost {
    _contentLabel.text = _post.content;
    _userNameLabel.text = _post.user.name;
}

@end
