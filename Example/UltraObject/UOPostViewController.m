//
//  UOPostViewController.m
//  UltraObject
//
//  Created by Sungwon Lee on 8/17/15.
//  Copyright (c) 2015 Sungwon Lee. All rights reserved.
//

#import "UOPostViewController.h"
#import "UOEditViewController.h"
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
    [_post addObservingTarget:self action:@selector(onPostEvent:)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self bindPost];
}

- (void)onPostEvent:(UOEvent *)event {
    if (event.type == UOEventTypeUpdate) {
        [self bindPost];
    }
}

- (IBAction)editButtonPressed:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Edit Post" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *editAction = [UIAlertAction actionWithTitle:@"Edit Content" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self editPost];
    }];
    UIAlertAction *destroyAction = [UIAlertAction actionWithTitle:@"Remove Post" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self destroyPost];
    }];
    
    [alertController addAction:editAction];
    [alertController addAction:destroyAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EditPost"]) {
        UOEditViewController *editViewController = segue.destinationViewController;
        editViewController.post = _post;
    }
}

#pragma mark - Private

- (void)bindPost {
    _contentLabel.text = _post.content;
    _userNameLabel.text = _post.user.name;
}

- (void)editPost {
    [self performSegueWithIdentifier:@"EditPost" sender:self];
}

- (void)destroyPost {
    [_post destroy];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
