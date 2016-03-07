//
//  Copyright © 2016 AutomaticLabs. All rights reserved.
//

#import "GaugesDataSource.h"

@implementation GaugesDataSource

#pragma mark - ALIndicatorDataSource

- (CGFloat)indicatorPosition {
    return 0.5;
}

#pragma mark - ALTimeSeriesDataSource

- (NSArray<NSDate *>*)sampleDates {
    return @[[NSDate date]];
}

- (CGFloat)sampleAtDate:(NSDate *)date {
    return 0.5;
}
/*
- (NSArray<NSDate *>*)sampleDatesAfter:(NSDate *)start {
    return @[];
}

- (NSArray<NSDate *>*)sampleDatesBetween:(NSDate *)start and:(NSDate *)end {
    return @[];
}
*/
#pragma mark - ALHistogramDataSource

- (NSTimeInterval)bucketInterval {
    return 10;
}

- (NSArray<NSDate *>*)bucketDates {
    return @[];
}

- (CGFloat)bucketValueAtDate:(NSDate *)date {
    return 0;
}

- (NSArray<NSDate *>*)bucketDatesBetween:(NSDate *)start and:(NSDate *)end {
    return @[];
}

@end
