#import "GaugesDataSource.h"

@implementation GaugesDataSource

#pragma mark - ILIndicatorDataSource

- (CGFloat)indicatorPosition {
    return 0.5;
}

#pragma mark - ILTimeSeriesDataSource

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
#pragma mark - ILHistogramDataSource

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
