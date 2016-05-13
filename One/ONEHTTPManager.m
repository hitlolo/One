//
//  ONEHTTPManager.m
//  One
//
//  Created by Lolo on 16/4/15.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import "ONEHTTPManager.h"


static NSString* const gallery_url = @"http://v3.wufazhuce.com:8000/api/hp/more/%@";
static NSString* const gallery_url_bymonth = @"http://v3.wufazhuce.com:8000/api/hp/bymonth/%@";

static NSString* const reading_index = @"http://v3.wufazhuce.com:8000/api/reading/index";
static NSString* const reading_essay = @"http://v3.wufazhuce.com:8000/api/essay/%@";
static NSString* const reading_serial = @"http://v3.wufazhuce.com:8000/api/serialcontent/%@";
static NSString* const reading_question = @"http://v3.wufazhuce.com:8000/api/question/%@";

static NSString* const reading_comment = @"http://v3.wufazhuce.com:8000/api/comment/praiseandtime/%@/%@/%@";

static NSString* const reading_related = @"http://v3.wufazhuce.com:8000/api/related/%@/%@";

static NSString* const reading_essay_bymonth = @"http://v3.wufazhuce.com:8000/api/essay/bymonth/%@";
static NSString* const reading_serial_bymonth = @"http://v3.wufazhuce.com:8000/api/serial/bymonth/%@";
static NSString* const reading_question_bymonth = @"http://v3.wufazhuce.com:8000/api/question/bymonth/%@";

static NSString* const reading_article_bymonth = @"http://v3.wufazhuce.com:8000/api/%@/bymonth/%@";

static NSString* const reading_serial_contents = @"http://v3.wufazhuce.com:8000/api/serial/list/%@";

@interface ONEHTTPManager ()
@property(nonatomic,strong)AFHTTPSessionManager* defaultManager;
@end

@implementation ONEHTTPManager

+ (instancetype)sharedManager{
    static ONEHTTPManager* _manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[ONEHTTPManager alloc]init];
    });
    return _manager;
}


- (instancetype)init{
    self = [super init];
    if (self) {
        NSURLSessionConfiguration* configure = [NSURLSessionConfiguration defaultSessionConfiguration];
        configure.timeoutIntervalForRequest = 5;
        configure.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
        _defaultManager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configure];
        
    }
    return self;
}


- (void)fetchPaintingsFromLastOne:(NSString *)paintingID completionHandler:(completionHandler)handler{
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:gallery_url,paintingID]];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
    [[self.defaultManager dataTaskWithRequest:request completionHandler:handler]resume];

}

- (void)fetchPaintingsByMonth:(NSString *)selectedMonth completionHandler:(completionHandler)handler{
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:gallery_url_bymonth,selectedMonth]];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
    [[self.defaultManager dataTaskWithRequest:request completionHandler:handler]resume];
    
}

- (void)fetchReadingIndexWithCompletionHandler:(completionHandler)handler{
    
    NSURL* url = [NSURL URLWithString:reading_index];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
    [[self.defaultManager dataTaskWithRequest:request completionHandler:handler]resume];

}


- (void)fetchArticleWithType:(ONEContentType)type articleID:(NSString *)articleID completionHandler:(completionHandler)handler{
    
    if (type == Essay) {
        [self fetchReadingEssayWithID:articleID completionHandler:handler];
    }
    else if (type == Serial){
        [self fetchReadingSerialWithID:articleID completionHandler:handler];
    }
    else{
        [self fetchReadingQuestionWithID:articleID completionHandler:handler];
    }

}


- (void)fetchReadingEssayWithID:(NSString *)essayID completionHandler:(completionHandler)handler{
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:reading_essay,essayID]];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
    [[self.defaultManager dataTaskWithRequest:request completionHandler:handler]resume];

}

- (void)fetchReadingSerialWithID:(nonnull NSString*)serialID completionHandler:(nullable completionHandler)handler{
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:reading_serial,serialID]];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
    [[self.defaultManager dataTaskWithRequest:request completionHandler:handler]resume];

}


- (void)fetchReadingQuestionWithID:(NSString *)questionID completionHandler:(completionHandler)handler{
    

    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:reading_question,questionID]];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
    [[self.defaultManager dataTaskWithRequest:request completionHandler:handler]resume];
}

- (void)fetchCommentWithReadingType:(ONEContentType)type articleID:(NSString *)articleID commentID:(NSString *)commentID completionHandler:(nullable completionHandler)handler{

    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:reading_comment,[self readingType:type],articleID,commentID]];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
    [[self.defaultManager dataTaskWithRequest:request completionHandler:handler]resume];
}

- (void)fetchRelatedArticleWithReadingType:(ONEContentType)type articleID:(NSString *)articleID completionHandler:(completionHandler)handler{
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:reading_related,[self readingType:type],articleID]];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
    [[self.defaultManager dataTaskWithRequest:request completionHandler:handler]resume];
}


- (void)fetchArticleByMonthWithType:(ONEContentType)type selectedMonth:(nonnull NSString*)selectedMonth completionHadnler:(nullable completionHandler)handler{
    
    NSString* typeString = [self readingTypeForByMonth:type];
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:reading_article_bymonth,typeString,selectedMonth]];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
    [[self.defaultManager dataTaskWithRequest:request completionHandler:handler]resume];
}

- (void)fetchSerialContentListWithSerialID:(nonnull NSString*)serialID completionHandler:(nullable completionHandler)handler{
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:reading_serial_contents,serialID]];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
    [[self.defaultManager dataTaskWithRequest:request completionHandler:handler]resume];
    
}


- (NSString*)readingType:(ONEContentType)type{
    switch (type) {
        case Essay:
            return @"essay";
            break;
        case Serial:
            return @"serial";
            break;
        case Question:
            return @"question";
            break;
        default:
            return nil;
            break;
    }
}

- (NSString*)readingTypeForByMonth:(ONEContentType)type{
    switch (type) {
        case Essay:
            return @"essay";
            break;
        case Serial:
            return @"serialcontent";
            break;
        case Question:
            return @"question";
            break;
        default:
            return nil;
            break;
    }
}
@end
