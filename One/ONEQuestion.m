//
//  ONEQuestion.m
//  One
//
//  Created by Lolo on 16/4/14.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import "ONEQuestion.h"

@implementation ONEQuestion


- (NSString*)articleToHTML{
    
    static NSString *const ONETimePlaceholder = @"<!-- time -->";
    static NSString *const ONEQuestionTitlePlaceholder = @"<!-- question_title -->";
    static NSString *const ONEQuestionContentPlaceholder = @"<!-- question_content -->";
    static NSString *const ONEAnswerTitlePlaceholder = @"<!-- answer_title -->";
    static NSString *const ONEAnswerContentPlaceholder = @"<!-- answer_content -->";
    static NSString *const ONEAuthorPlaceholder = @"<!-- author -->";
    
    NSString *htmlTemplate = nil;
    
    if (!htmlTemplate) {
        NSURL *htmlURL = [[NSBundle mainBundle] URLForResource:@"Question" withExtension:@"html"];
        htmlTemplate = [NSString stringWithContentsOfURL:htmlURL encoding:NSUTF8StringEncoding error:nil];
    }
    
    NSString* time = [ONEDateHelper getDayMonthYear:self.question_makettime];
    htmlTemplate = [htmlTemplate stringByReplacingOccurrencesOfString:ONETimePlaceholder withString:time];

    htmlTemplate = [htmlTemplate stringByReplacingOccurrencesOfString:ONEQuestionTitlePlaceholder withString:self.question_title];
    
    
    htmlTemplate = [htmlTemplate stringByReplacingOccurrencesOfString:ONEQuestionContentPlaceholder withString:self.question_content];
    
    htmlTemplate = [htmlTemplate stringByReplacingOccurrencesOfString:ONEAnswerTitlePlaceholder withString:self.answer_title];
    
    htmlTemplate = [htmlTemplate stringByReplacingOccurrencesOfString:ONEAnswerContentPlaceholder withString:self.answer_content];
    
    htmlTemplate = [htmlTemplate stringByReplacingOccurrencesOfString:ONEAuthorPlaceholder withString:self.charge_edt];
    
    
    return htmlTemplate;
    
    
}

- (NSString*)articlePraiseNumber{
    return [NSString stringWithFormat:@"%d",self.praisenum];
}

- (NSString*)articleCommentNumber{
    return [NSString stringWithFormat:@"%d",self.commentnum];
}

- (ONEContentType)articleType{
    return Question;
}

@end
