#import <UIKit/UIKit.h>

#import <GaugeKit/ILTimelineView.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ILHistagramDataSource;

#pragma mark -

@interface ILHistogramView : ILBorderedView

/*! @abstract dataSource for the histogram view */
@property (nonatomic, weak) id<ILHistagramDataSource> dataSource;

@end

#pragma mark -

/*! @abstract protocol for histogram data provided to ILHistogramView */
@protocol ILHistagramDataSource <NSObject>

/*! @abstract length of time for each bucket */
@property (nonatomic, readonly) NSTimeInterval bucketInterval;

/*! @abstract an array of NSDate objects for which the data source has bucket values,
    at the earliest edge of the bucket, in chronological order */
@property (nonatomic, readonly) NSArray<NSDate *>*bucketDates;

/*! @param date - the date for bucket from which we want data, one of the dates in bucketDates
    @returns a normalized value for the sample between 0-1 */
- (CGFloat)bucketValueAtDate:(NSDate *)date;

/*! @param start - the earliest bucket date to allow into the sorted array
    @param end - the latest bucket date to allow into the sorted array
    @returns subarray of sampleDates which are between the dates provided */
- (NSArray<NSDate *>*)bucketDatesBetween:(NSDate *)start and:(NSDate *)end;

@end

NS_ASSUME_NONNULL_END
