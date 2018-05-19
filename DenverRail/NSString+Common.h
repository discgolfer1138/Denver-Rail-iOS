//
//  NSString+Common.h
//
// 2008 - 2013 Tack Mobile.
//

#import <Foundation/Foundation.h>

@interface NSString (Common)

@property (NS_NONATOMIC_IOSONLY, getter=isBlank, readonly) BOOL blank;
-(BOOL)contains:(NSString *)string;
-(NSArray *)splitOnChar:(char)ch;
-(NSString *)substringFrom:(NSInteger)from to:(NSInteger)to;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *stringByStrippingWhitespace;

@end
