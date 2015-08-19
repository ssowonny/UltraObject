//
//  UOPostsViewController.m
//  UltraObject
//
//  Created by Sungwon Lee on 8/18/15.
//  Copyright (c) 2015 Sungwon Lee. All rights reserved.
//

#import "UOPostsViewController.h"
#import "UOPostViewController.h"
#import "UOEditViewController.h"
#import "UOPost.h"
#import "UOUser.h"

@interface UOPostsViewController () {
    NSMutableArray *_posts;
}

@end

@implementation UOPostsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *dummyData = @"{\"posts\":[{\"id\":1,\"content\":\"Hello World\",\"user\":{\"id\":1,\"name\":\"John Doe\"},\"comments\":[]},{\"id\":2,\"content\":\"Hi There\",\"user\":{\"id\":1,\"name\":\"John Doe\"},\"comments\":[]},{\"id\":3,\"content\":\"Party Time\",\"user\":{\"id\":2,\"name\":\"Jane Roe\"},\"comments\":[]},{\"id\":4,\"content\":\"Summer Night\",\"user\":{\"id\":2,\"name\":\"Jane Roe\"},\"comments\":[]}]}";
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[dummyData dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    
    _posts = [UOPost arrayOfModelsFromDictionaries:json[@"posts"]];
    [UOPost addObservingTarget:self action:@selector(onPostEvent:)];
}

- (void)onPostEvent:(UOEvent *)event {
    UOPost *post = event.object;
    if (event.type == UOEventTypeCreate) {
        [_posts insertObject:post atIndex:0];
        [self.tableView reloadData];
        
    } else if([_posts containsObject:post]) {
        if (event.type == UOEventTypeDelete) {
            [_posts removeObject:post];
        }
        [self.tableView reloadData];
    }
}

- (IBAction)newButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"NewPost" sender:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UOPostsTableViewCell" forIndexPath:indexPath];
    UOPost *post = _posts[indexPath.item];
    cell.textLabel.text = post.content;
    cell.detailTextLabel.text = post.user.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UOPost *post = _posts[indexPath.item];
    [self performSegueWithIdentifier:@"ShowPost" sender:post];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowPost"]) {
        UOPostViewController *postViewController = segue.destinationViewController;
        postViewController.post = sender;
    } else if ([segue.identifier isEqualToString:@"ShowPost"]) {
        UOEditViewController *editViewController = segue.destinationViewController;
        editViewController.post = [UOPost new];
    }
}

@end
