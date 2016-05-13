//
//  ONECommon.h
//  One
//
//  Created by Lolo on 16/4/28.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#ifndef ONECommon_h
#define ONECommon_h

typedef NS_ENUM(NSInteger,ONEContentType){
    Essay,
    Serial,
    Question,
    Gallery
};

#define one_tintColor [UIColor colorWithRed:0.8196 green:0.7333 blue:0.6314 alpha:1.0]

#define one_placeHolder_image [UIImage imageNamed:@"image_placeholder"]
#define one_placeHolder_head [UIImage imageNamed:@"official_head"]

#define one_placeHolder_essay [UIImage imageNamed:@"essay_image"]
#define one_placeHolder_serial [UIImage imageNamed:@"serial_image"]
#define one_placeHolder_question [UIImage imageNamed:@"question_image"]
#define one_placeHolder_channel [UIImage imageNamed:@"channel_placeholder"]
#define one_placeHolder_album [UIImage imageNamed:@"music_cover"]


#endif /* ONECommon_h */
