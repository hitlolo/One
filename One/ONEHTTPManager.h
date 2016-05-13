//
//  ONEHTTPManager.h
//  One
//
//  Created by Lolo on 16/4/15.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

typedef void(^completionHandler)(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error);

@interface ONEHTTPManager : NSObject

+ (nonnull instancetype)sharedManager;

- (void)fetchPaintingsFromLastOne:(nonnull NSString*)paintingID completionHandler:(nullable completionHandler)handler;
- (void)fetchPaintingsByMonth:(nonnull NSString*)selectedMonth completionHandler:(nullable completionHandler)handler;


- (void)fetchArticleWithType:(ONEContentType)type  articleID:(nonnull NSString*)articleID completionHandler:(nullable completionHandler)handler;
- (void)fetchArticleByMonthWithType:(ONEContentType)type selectedMonth:(nonnull NSString*)selectedMonth completionHadnler:(nullable completionHandler)handler;
- (void)fetchReadingIndexWithCompletionHandler:(nullable completionHandler)handler;
- (void)fetchReadingEssayWithID:(nonnull NSString*)essayID completionHandler:(nullable completionHandler)handler;
- (void)fetchReadingSerialWithID:(nonnull NSString*)serialID completionHandler:(nullable completionHandler)handler;
- (void)fetchReadingQuestionWithID:(nonnull NSString*)questionID completionHandler:(nullable completionHandler)handler;


- (void)fetchCommentWithReadingType:(ONEContentType)type  articleID:(nonnull NSString*)articleID commentID:(nonnull NSString*)commentID completionHandler:(nullable completionHandler)handler;

- (void)fetchRelatedArticleWithReadingType:(ONEContentType)type articleID:(nonnull NSString*)articleID completionHandler:(nullable completionHandler)handler;

- (void)fetchSerialContentListWithSerialID:(nonnull NSString*)serialID completionHandler:(nullable completionHandler)handler;
@end
