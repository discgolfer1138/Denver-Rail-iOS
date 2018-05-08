//
//  ScheduledStop.h
//  DenverRail
//
// 2008 - 2013 Tack Mobile.
//

#import <Foundation/Foundation.h>
#import "Station.h"

typedef NS_ENUM(NSUInteger, RailLine) {
    kALine = 0,
    kBLine,
    kCLine,
    kDLine,
    kELine,
    kFLine,
    kGLine,
    kHLine,
    kRLine,
    kWLine,
};

@interface ScheduledStop : NSObject

@property (strong, nonatomic) NSDate *date;
@property RailLine line;
@property BOOL isNorth;
@property (strong, nonatomic) Station *station;
@property BOOL isHighlighted;

@end
