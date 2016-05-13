//
//  ONESerial.m
//  One
//
//  Created by Lolo on 16/4/14.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import "ONESerial.h"

@implementation ONESerial

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"item_id" : @"id"};
}



- (NSString*)articleToHTML{
    
    static NSString *const ONETitlePlaceholder = @"<!-- title -->";
    static NSString *const ONETimePlaceholder = @"<!-- time -->";
    static NSString *const ONEContentPlaceholder = @"<!-- content -->";
    static NSString *const ONEAuthorImagePlaceholder = @"<!-- head_img -->";
    static NSString *const ONEAuthorNamePlaceholder = @"<!-- author_name -->";
    static NSString *const ONEAuthorIntroPlaceholder = @"<!-- author_intro -->";
    static NSString *const ONEAuthorWeiboPlaceholder = @"<!-- author_weibo -->";
    
    NSString *htmlTemplate = nil;
    
    if (!htmlTemplate) {
        NSURL *htmlURL = [[NSBundle mainBundle] URLForResource:@"Article" withExtension:@"html"];
        htmlTemplate = [NSString stringWithContentsOfURL:htmlURL encoding:NSUTF8StringEncoding error:nil];
    }
    
    
    htmlTemplate = [htmlTemplate stringByReplacingOccurrencesOfString:ONETitlePlaceholder withString:self.title];
    
    NSString* time = [ONEDateHelper getDayMonthYear:self.maketime];
    htmlTemplate = [htmlTemplate stringByReplacingOccurrencesOfString:ONETimePlaceholder withString:time];
    
    htmlTemplate = [htmlTemplate stringByReplacingOccurrencesOfString:ONEContentPlaceholder withString:self.content];
    
    htmlTemplate = [htmlTemplate stringByReplacingOccurrencesOfString:ONEAuthorImagePlaceholder withString:self.author.web_url];
    
    htmlTemplate = [htmlTemplate stringByReplacingOccurrencesOfString:ONEAuthorNamePlaceholder withString:self.author.user_name];
    
    htmlTemplate = [htmlTemplate stringByReplacingOccurrencesOfString:ONEAuthorIntroPlaceholder withString:self.charge_edt];
    
    NSString* weibo = self.author.wb_name? self.author.wb_name:@"";
    htmlTemplate = [htmlTemplate stringByReplacingOccurrencesOfString:ONEAuthorWeiboPlaceholder withString:weibo];
    
    return htmlTemplate;

    
}

- (NSString*)articlePraiseNumber{
    return [NSString stringWithFormat:@"%d",self.praisenum];
}

- (NSString*)articleCommentNumber{
    return [NSString stringWithFormat:@"%d",self.commentnum];
}

- (ONEContentType)articleType{
    return Serial;
}
@end
