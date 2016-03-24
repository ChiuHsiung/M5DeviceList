//
//  TPAttributedStringGenerator.m
//  TPRouter2.0
//
//  Created by Al on 14-4-3.
//  Copyright (c) 2014年 TP-Link. All rights reserved.
//

#import "TPAttributedStringGenerator.h"

@interface TPAttributedStringGenerator ()
@property(nonatomic, readwrite) BOOL isConfigChange;
@property(nonatomic, readwrite) NSMutableParagraphStyle* paragraphStyle;
@property(nonatomic, readwrite) NSMutableDictionary* attribDict;
@property(nonatomic, readwrite) NSAttributedString* attributedString;
@property(nonatomic, readwrite) CGRect bounds;
@end

@implementation TPAttributedStringGenerator

@synthesize text, font, textColor;

-(id)initWithString:(NSString*)str boundingRectWithSize:(CGSize)size options:(NSStringDrawingOptions)options context:(NSStringDrawingContext *)context
{
    self = [super init];
    
    if (nil != self)
    {
        self.isConfigChange = YES;
        
        self.options = options;
        self.context = context;
        self.constraintSize = size;
        
        self.attribDict = [[NSMutableDictionary alloc] initWithCapacity:4];
        self.text = str;
        
        self.font = [UIFont systemFontOfSize:12];
        self.paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        self.textColor = [UIColor blackColor];
    }
    
    return self;
}

-(id)initWithString:(NSString*)str boundingRectWithSize:(CGSize)size options:(NSStringDrawingOptions)options
{
    return [self initWithString:str boundingRectWithSize:size options:options context:nil];
}

-(id)initWithString:(NSString*)str boundingRectWithSize:(CGSize)size
{
    return [self initWithString:str boundingRectWithSize:size options:
            NSStringDrawingUsesLineFragmentOrigin |
            NSStringDrawingUsesFontLeading //|
            /*NSStringDrawingTruncatesLastVisibleLine*/];
}

-(id)initWithString:(NSString*)str options:(NSStringDrawingOptions)options
{
    return [self initWithString:str boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:options];
}

-(id)init
{
    return [self initWithString:@""];
}

-(id)initWithString:(NSString*)str
{
    return [self initWithString:str boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
}

-(NSAttributedString*) generate
{
    self.attribDict = [[NSMutableDictionary alloc] initWithCapacity:4];
    
    
    [self.attribDict setValue:self.font forKey:NSFontAttributeName];
    [self.attribDict setValue:self.paragraphStyle forKey:NSParagraphStyleAttributeName];
    [self.attribDict setValue:self.textColor forKey:NSForegroundColorAttributeName];
    
    _attributedString = [[NSAttributedString alloc] initWithString:self.text attributes:self.attribDict];
    
    _bounds = [_attributedString boundingRectWithSize:self.constraintSize options:self.options context:self.context];
    //[_attributedString drawWithRect:CGRectMake(0, 0, _bounds.size.width, _bounds.size.height) options:self.options context:self.context];
    self.isConfigChange = NO;
    
    return _attributedString;
}

-(NSAttributedString*) attributedString
{
    if (self.isConfigChange)
    {
        [self generate];
    }
    
    return _attributedString;
}

-(CGRect) bounds
{
    if (self.isConfigChange)
    {
        [self generate];
    }
    
    return _bounds;
}

-(void) setText:(NSString *)newText
{
    self.isConfigChange = YES;
    if (nil != newText)
    {
        text = newText;
    }
    else
    {
        text = @"";
//        TPLog(@"---->Text is nil!!");
    }
}

-(void) setFont:(UIFont *)newFont
{
    self.isConfigChange = YES;
    if (nil != newFont)
    {
        font = newFont;
    }
    else
    {
        font = [UIFont systemFontOfSize:1];
//        TPLog(@"---->Font is nil!!");
    }
}

-(void) setTextColor:(UIColor *)newTextColor
{
    self.isConfigChange = YES;
    if (nil != newTextColor)
    {
        textColor = newTextColor;
    }
    else
    {
        textColor = [UIColor redColor];
//        TPLog(@"---->Color is nil!!");
    }
}

-(NSTextAlignment) textAlignment
{
    return self.paragraphStyle.alignment;
}

-(void) setTextAlignment:(NSTextAlignment)alignment
{
    self.isConfigChange = YES;
    self.paragraphStyle.alignment = alignment;
}

-(NSLineBreakMode) lineBreakMode
{
    return self.paragraphStyle.lineBreakMode;
}

-(void) setLineBreakMode:(NSLineBreakMode)lineBreakMode
{
    self.isConfigChange = YES;
    self.paragraphStyle.lineBreakMode = lineBreakMode;
    
    /*
     
     UILineBreakModeWordWrap = 0,
     以单词为单位换行，以单位为单位截断。
     UILineBreakModeCharacterWrap,
     以字符为单位换行，以字符为单位截断。
     UILineBreakModeClip,
     以单词为单位换行。以字符为单位截断。
     UILineBreakModeHeadTruncation,
     以单词为单位换行。如果是单行，则开始部分有省略号。如果是多行，则中间有省略号，省略号后面有4个字符。
     UILineBreakModeTailTruncation,
     以单词为单位换行。无论是单行还是多行，都是末尾有省略号。
     UILineBreakModeMiddleTruncation,
     以单词为单位换行。无论是单行还是多行，都是中间有省略号，省略号后面只有2个字符。
     
     */
}

-(CGFloat) lineSpacing
{
    return self.paragraphStyle.lineSpacing;
}

-(void) setLineSpacing:(CGFloat)lineSpacing
{
    self.isConfigChange = YES;
    self.paragraphStyle.lineSpacing = lineSpacing;
}

- (CGRect)boundingRectWithSize:(CGSize)size options:(NSStringDrawingOptions)options context:(NSStringDrawingContext *)context
{
    return [self.attributedString boundingRectWithSize:size options:options context:context];
}

- (void)drawWithRect:(CGRect)rect options:(NSStringDrawingOptions)options context:(NSStringDrawingContext *)context
{
    [self.attributedString drawWithRect:rect options:options context:context];
}

@end


/*
 常量
 
 NSFontAttributeName
 
 该属性所对应的值是一个 UIFont 对象。该属性用于改变一段文本的字体。如果不指定该属性，则默认为12-point Helvetica(Neue)。
 
 NSParagraphStyleAttributeName
 
 该属性所对应的值是一个 NSParagraphStyle 对象。该属性在一段文本上应用多个属性。如果不指定该属性，则默认为 NSParagraphStyle 的defaultParagraphStyle 方法返回的默认段落属性。
 
 NSForegroundColorAttributeName
 
 该属性所对应的值是一个 UIColor 对象。该属性用于指定一段文本的字体颜色。如果不指定该属性，则默认为黑色。
 
 NSBackgroundColorAttributeName
 
 该属性所对应的值是一个 UIColor 对象。该属性用于指定一段文本的背景颜色。如果不指定该属性，则默认无背景色。
 
 NSLigatureAttributeName
 
 该属性所对应的值是一个 NSNumber 对象(整数)。连体字符是指某些连在一起的字符，它们采用单个的图元符号。0 表示没有连体字符。1 表示使用默认的连体字符。2表示使用所有连体符号。默认值为 1（注意，iOS 不支持值为 2）。
 
 NSKernAttributeName
 
 该属性所对应的值是一个 NSNumber 对象(整数)。字母紧排指定了用于调整字距的像素点数。字母紧排的效果依赖于字体。值为 0 表示不使用字母紧排。默认值为0。
 
 NSStrikethroughStyleAttributeName
 
 该属性所对应的值是一个 NSNumber 对象(整数)。该值指定是否在文字上加上删除线，该值参考“Underline Style Attributes”。默认值是NSUnderlineStyleNone。
 
 NSUnderlineStyleAttributeName
 
 该属性所对应的值是一个 NSNumber 对象(整数)。该值指定是否在文字上加上下划线，该值参考“Underline Style Attributes”。默认值是NSUnderlineStyleNone。
 
 NSStrokeColorAttributeName
 
 该属性所对应的值是一个 UIColor 对象。如果该属性不指定（默认），则等同于 NSForegroundColorAttributeName。否则，指定为删除线或下划线颜色。更多细节见“Drawing attributedstrings that are both filled and stroked”。
 
 NSStrokeWidthAttributeName
 
 该属性所对应的值是一个 NSNumber 对象(小数)。该值改变描边宽度（相对于字体size 的百分比）。默认为 0，即不改变。正数只改变描边宽度。负数同时改变文字的描边和填充宽度。例如，对于常见的空心字，这个值通常为3.0。
 
 NSShadowAttributeName
 
 该属性所对应的值是一个 NSShadow 对象。默认为 nil。
 
 NSVerticalGlyphFormAttributeName
 
 该属性所对应的值是一个 NSNumber 对象(整数)。0 表示横排文本。1 表示竖排文本。在 iOS 中，总是使用横排文本，0 以外的值都未定义。
 */