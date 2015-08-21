# UltraObject

[![CI Status](http://img.shields.io/travis/Sungwon Lee/UltraObject.svg?style=flat)](https://travis-ci.org/ssowonny/UltraObject)
[![Version](https://img.shields.io/cocoapods/v/UltraObject.svg?style=flat)](http://cocoapods.org/pods/UltraObject)
[![License](https://img.shields.io/cocoapods/l/UltraObject.svg?style=flat)](http://cocoapods.org/pods/UltraObject)
[![Platform](https://img.shields.io/cocoapods/p/UltraObject.svg?style=flat)](http://cocoapods.org/pods/UltraObject)

Ultra Object is event based model framework. It helps you to manage
objects easily. Especially if you're using RESTful api, this can be
a good solution for creating, updating and destroying objects while
applying the changes to views and controllers.

Ultra Object also helps you to apply mutable/immutable pattern.

## Usage

### Basic declaration

```objc
#import "UltraObject.h"

@interface TodoObject : UOObject
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSDate *date;
@end
```

### Create, update and destroy object

```objc
- (IBAction)createButtonPressed {
    NSString *content = self.contentTextField.text;
    [TodoObject new:@{@"id": @(++__uniqueID), @"content": content}];
}

- (IBAction)updateButtonPressed {
    [self.todoObject edit:^(TodoObject *object) {
        object.content = self.contentTextField.text;
    }];
}

- (IBAction)deleteButtonPressed {
    [self.todoObject destroy];
}
```

### Object observing

You can easily notified if the object is modified via object observing.

#### Basic observing with selector

```objc
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.todoObject addObserverWithTarget:self action:@selector(onTodoEvent:)];
}

- (void)onTodoEvent:(UOEvent *) {
    if (event.type == UOEventTypeUpdate) {
        TodoObject *object = event.object;
        self.contentLabel.text = object.content;
    }
}
```

#### Simple observing with block

```objc
[self.todoObject addObserverWithTarget:self block:^(UOEvent *)event {
    NSLog(@"%@", event.object);
}];
```

#### Observe all events for specific object class

You will be informed of every events for any objects of the class.

```objc
[TodoObject addObserverWithTarget:self action:@selector(onTodoEvent:)];
```

#### Observe object array

You can set object array delegate to receive events for relevent
objects. The mutable array will be automatically modified according to
event type. For instance, `destroy` or `update` event will affect the
mutable array by removing or updating data.

You can also decide whether inserting newly created object to the array
or not, or even insertion position for it.

```objc
- (void)viewDidLoad {
    [super viewDidLoad];

    NSMutableArray *todoObjects = [TodoObject arrayOfModelsFromDictionaries:jsonArray];
    [todoObjects setObjectArrayDelegate:self class:TodoObject.class];
}

- (void)objectArray:(NSMutableArray *)array didReceiveEvent:(UOEvent *)event {
    [self.tableView reloadData];
}

- (NSUInteger)objectArray:(NSMutableArray *)array indexOfNewObject:(TodoObject *)object {
    return 0;
}
```

### Load objects from json

Ultra Object uses [JSONModel](https://github.com/icanzilb/JSONModel).
Please read [JSONModel#Basic Usage](https://github.com/icanzilb/JSONModel#basic-usage)
section for loading objects from json.

### Immutable objects

If you want to make objects immutable for safety, you can define mutable
object by subclassing original object and making it conforms to
`UOMutableObject` protocol.

Original object should define associated object for attributes to load
json properly.

```objc
@interface TodoObject : UOObject
@property (nonatomic, readonly) NSString *content;
@end

@interface MutableTodoObject : UOObject
@property (nonatomic, readwrite) NSString *content;
@end
```

```objc
@interface TodoObject ()
@property (nonatomic, strong) NSString *content;
@end

@implementation TodoObject
@end

@implementation MutableTodoObject
@dynamic content;
@end
```

`edit:` method will pass mutable object.

```objc
[self.todoObject edit:^(MutableTodoObject *)mutableObject {
    mutableObject.content = @"New content";
}];
```

### Example Project

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

Ultra Object supports iOS 7.0+.

## Installation

UltraObject is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "UltraObject"
```

## Author

Sungwon Lee, ssowonny@gmail.com

## Contribution

Please fork it, edit, add specs and submit a pull request.

## License

UltraObject is available under the MIT license. See the LICENSE file for more info.
