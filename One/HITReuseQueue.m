//
//  HITReuseQueue.m
//  One
//
//  Created by Lolo on 16/4/1.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import "HITReuseQueue.h"

typedef NSString  ReuseIdentifier;
typedef NSString  ClassName;
typedef NSMutableSet ItemSet;

typedef NSMutableDictionary<ReuseIdentifier*,ItemSet*> ItemSetDictionary;
typedef NSMutableDictionary<ReuseIdentifier*,UINib*> NibDictionary;
typedef NSMutableDictionary<ReuseIdentifier*,ClassName*> ClassDictionary;
typedef NSMutableDictionary<ReuseIdentifier*,UIStoryboard*> StoryboardDictionary;
@interface HITReuseQueue()

@property(nonatomic,strong)ItemSetDictionary* unusedItemSetDictionary;
@property(nonatomic,strong)ItemSetDictionary* usedItemSetDictionary;

@property(nonatomic,strong)NibDictionary* registeredNibDictionary;
@property(nonatomic,strong)ClassDictionary* registeredClassDictionary;
@property(nonatomic,strong)StoryboardDictionary* registeredStoryboardDictionary;

@end

@implementation HITReuseQueue


+ (instancetype)queue{
    static HITReuseQueue* _reuseQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _reuseQueue = [[HITReuseQueue alloc]init];
    });
    return _reuseQueue;
}

#pragma mark - Memory Warning

- (instancetype)init{
    self = [super init];
    if (self) {
        [self subscribeMemoryWarningNotification];
    }
    return self;
}

- (void)dealloc{
    [self unsubscibeMemoryWarningNotification];
}

- (void)subscribeMemoryWarningNotification{
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(removeAllUnusedItems)
                                                name:UIApplicationDidReceiveMemoryWarningNotification
                                              object:nil];
}

- (void)unsubscibeMemoryWarningNotification{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)removeAllUnusedItems {
    [self.unusedItemSetDictionary removeAllObjects];
}


#pragma mark - Gettes

- (ItemSetDictionary*)unusedItemSetDictionary{
    if (_unusedItemSetDictionary == nil) {
        _unusedItemSetDictionary = [NSMutableDictionary new];
    }
    return _unusedItemSetDictionary;
}

- (ItemSetDictionary*)usedItemSetDictionary{
    if (_usedItemSetDictionary == nil) {
        _usedItemSetDictionary = [NSMutableDictionary new];
    }
    return _usedItemSetDictionary;
}

- (NibDictionary*)registeredNibDictionary{
    if (_registeredNibDictionary == nil) {
        _registeredNibDictionary = [NSMutableDictionary new];
    }
    return _registeredNibDictionary;
}

- (ClassDictionary*)registeredClassDictionary{
    if (_registeredClassDictionary == nil) {
        _registeredClassDictionary = [NSMutableDictionary new];
    }
    return _registeredClassDictionary;
}

- (StoryboardDictionary*)registeredStoryboardDictionary{
    if (_registeredStoryboardDictionary == nil) {
        _registeredStoryboardDictionary = [NSMutableDictionary new];
    }
    return _registeredStoryboardDictionary;
}


- (ItemSet*)unusedItemSetWithIdentifier:(ReuseIdentifier*)identifier{
    ItemSet* unusedItemSet = self.unusedItemSetDictionary[identifier];
    if (unusedItemSet == nil) {
        unusedItemSet = [ItemSet new];
        self.unusedItemSetDictionary[identifier] = unusedItemSet;
    }
    return unusedItemSet;
}

- (ItemSet*)usedItemSetWithIdentifier:(ReuseIdentifier*)identifier{
    ItemSet* usedItemSet = self.usedItemSetDictionary[identifier];
    if (usedItemSet == nil) {
        usedItemSet = [ItemSet new];
        self.usedItemSetDictionary[identifier] = usedItemSet;
    }
    return usedItemSet;
}


#pragma mark - Registers

- (void)registerNib:(UINib *)nib forItemReuseIdentifier:(NSString *)identifier{
    
    NSAssert(nib!=nil, @"try to rigster nib file,but nib is nil");
    self.registeredNibDictionary[identifier] = nib;
}

- (void)registerClass:(Class)class forItemReuseIdentifier:(NSString *)identifier{
    NSAssert(class!=nil, @"try to rigster class,but class is nil");
    NSString* className = NSStringFromClass(class);
    self.registeredClassDictionary[identifier] = className;
}

- (void)registerStoryboard:(UIStoryboard *)storyboard forItemReuseIdentifier:(NSString *)identifier{
    self.registeredStoryboardDictionary[identifier] = storyboard;
}

- (void)enqueueReusableItem:(id<HITReusableItem>)item{
    NSAssert(item!=nil,@"enqueue fail,item is nil");
    if (![item respondsToSelector:@selector(reuseIdentifier)]) {
        return;
    }else if ( item.reuseIdentifier == nil ){
        return;
    }
    
    [[self usedItemSetWithIdentifier:item.reuseIdentifier]removeObject:item];
    [[self unusedItemSetWithIdentifier:item.reuseIdentifier]addObject:item];

}

- (id<HITReusableItem>)dequeueReusableItemWithIdentifier:(NSString *)identifier{
    NSAssert(identifier!=nil,@"dequeue fail,identifier is nil");
    
    //1. get unused item
    id<HITReusableItem> item = [[self unusedItemSetWithIdentifier:identifier]anyObject];
    if (item != nil) {
        [[self unusedItemSetWithIdentifier:item.reuseIdentifier]removeObject:item];
        [[self usedItemSetWithIdentifier:item.reuseIdentifier]addObject:item];
        if ([item respondsToSelector:@selector(prepareForReuse)]) {
            [item prepareForReuse];
        }
    }
    //2. get new item from registered class or nib
    if (item == nil) {
        item = [self createReusableItemWithIdentifier:identifier];
    }
    
    return item;
}

- (id<HITReusableItem>)createReusableItemWithIdentifier:(NSString*)identifier{
    
    id reusableItem = nil;
    
    reusableItem = [self createReusableItemFromStoryboardWithIdentifier:identifier];
    
    if (reusableItem == nil) {
        reusableItem = [self createReusableItemFromNibWithIdentifier:identifier];
    }
    if (reusableItem == nil) {
        reusableItem = [self createReusableItemFromClassWithIdentifier:identifier];
    }
    return reusableItem;

}

- (id<HITReusableItem>)createReusableItemFromStoryboardWithIdentifier:(NSString*)identifier{
    id reusableItem = nil;
    id storyboard = nil;
    storyboard = self.registeredStoryboardDictionary[identifier];
    if (storyboard == nil) {
        return nil;
    }else if ([storyboard isKindOfClass:[UIStoryboard class]]){
        reusableItem = [(UIStoryboard*)storyboard instantiateViewControllerWithIdentifier:identifier];
        if ([reusableItem respondsToSelector:@selector(setReuseIdentifier:)]) {
            [reusableItem setReuseIdentifier:identifier];
        }else{
            return nil;
        }
    }
    return reusableItem;
}


- (id<HITReusableItem>)createReusableItemFromNibWithIdentifier:(NSString*)identifier{
    
    id reusableItem = nil;
    id nibObject = nil;
    
    nibObject = self.registeredNibDictionary[identifier];
    if (nibObject == nil) {
        return nil;
    }else if ( [nibObject isKindOfClass:[UINib class]] ){
        
        NSArray* objects = [(UINib*)nibObject instantiateWithOwner:reusableItem options:nil];
        reusableItem = [objects lastObject];
        if ([reusableItem respondsToSelector:@selector(setReuseIdentifier:)]) {
            [reusableItem setReuseIdentifier:identifier];
        }else{
            return nil;
        }
        
    }
    return reusableItem;
}

- (id<HITReusableItem>)createReusableItemFromClassWithIdentifier:(NSString*)identifier{
    
    id reusableItem = nil;
    id classObject = nil;
    
    classObject = self.registeredClassDictionary[identifier];
    if (classObject == nil) {
        return nil;
    }else if ( [classObject isKindOfClass:[NSString class]] ){
        Class class = NSClassFromString(classObject);
        reusableItem = [class alloc];
        
        if ([reusableItem respondsToSelector:@selector(initWithReuseIdentifier:)]) {
            reusableItem = [reusableItem initWithReuseIdentifier:identifier];
        } else {
            reusableItem = [reusableItem init];
            if ([reusableItem respondsToSelector:@selector(setReuseIdentifier:)]) {
                [reusableItem setReuseIdentifier:identifier];
            }else{
                return nil;
            }
        }
    }
    return reusableItem;
}


@end
