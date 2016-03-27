//
//  TPAttributedStringGenerator.h
//  TPRouter2.0
//
//  Created by Al on 14-4-3.
//  Copyright (c) 2014年 TP-Link. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@interface TPAttributedStringGenerator : NSObject

@property(nonatomic, readwrite) NSString* text;
@property(nonatomic, readwrite) UIFont* font;
@property(nonatomic, readwrite) UIColor* textColor;

@property(nonatomic, readwrite) NSTextAlignment textAlignment;
@property(nonatomic, readwrite) NSLineBreakMode lineBreakMode;
@property(nonatomic, readwrite) CGFloat lineSpacing;

@property(nonatomic, readwrite) CGSize constraintSize;
@property(nonatomic, readwrite) NSStringDrawingOptions options;
@property(nonatomic, readwrite) NSStringDrawingContext* context;

@property(nonatomic, readonly) NSAttributedString* attributedString;

//6.1下，计算得到的宽度有点问题
@property(nonatomic, readonly) CGRect bounds;

-(id)initWithString:(NSString*)str boundingRectWithSize:(CGSize)size options:(NSStringDrawingOptions)options context:(NSStringDrawingContext *)context;
-(id)initWithString:(NSString*)str boundingRectWithSize:(CGSize)size options:(NSStringDrawingOptions)options;
-(id)initWithString:(NSString*)str boundingRectWithSize:(CGSize)size;
-(id)initWithString:(NSString*)str options:(NSStringDrawingOptions)options;
-(id)initWithString:(NSString*)str;
-(id)init;
-(NSAttributedString*) generate;

- (CGRect)boundingRectWithSize:(CGSize)size options:(NSStringDrawingOptions)options context:(NSStringDrawingContext *)context;

- (void)drawWithRect:(CGRect)rect options:(NSStringDrawingOptions)options context:(NSStringDrawingContext *)context;
@end


/*
 特殊情况
 
 为了计算文本块的大小，该方法采用默认基线。
 
 如果 NSStringDrawingUsesLineFragmentOrigin未指定，矩形的高度将被忽略，同时使用单线绘制。（由于一个 bug，在 iOS6 中，宽度会被忽略）
 */