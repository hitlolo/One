//
//  ONEArticle.h
//  One
//
//  Created by Lolo on 16/4/30.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ONEArticle <NSObject>

@required
- (NSString*)articleToHTML;
- (NSString*)articleCommentNumber;
- (NSString*)articlePraiseNumber;
- (ONEContentType)articleType;
@end

@protocol ONEArticleDescription <NSObject>

- (NSString*)articleID;
- (NSString*)articleTitle;
- (NSString*)articleExcerpt;
- (ONEContentType)articleType;

@optional
- (NSString*)articleSubtitle;
- (NSString*)articleAuthor;
- (NSString*)articleAuthorImageURL;
- (NSString*)articleAuthorWeibo;
- (NSString*)articleTime;
- (NSString*)serialId;
- (BOOL)articleHasAudio;



@end