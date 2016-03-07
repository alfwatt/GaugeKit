//
//  Copyright (c) 2015 Automatic Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <ALGaugeKit/ALTimelineView.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ALTimeSeriesDataSource;

#pragma mark -

/*! @abstract for viewing a plot of time series data */
@interface ALTimeSeriesView : ALTimelineView

/*! @abstract provides sample data to the view */
@property (nonatomic, weak) id<ALTimeSeriesDataSource> dataSource;

@end

#pragma mark -

/*! @abstract protocol for time series data provided to ALTimeSeriesView */
@protocol ALTimeSeriesDataSource <NSObject>

/*! @abstract an array of NSDate objects for which the data source has samples, in chronological order */
@property(nonatomic, readonly) NSArray<NSDate *>*sampleDates;

/*! @param date - the date for which we want data, one of the dates in sampleDates
    @returns a normalized value for the sample between 0-1 */
- (CGFloat) sampleAtDate:(NSDate *)date;

@optional // but highly reccomended for performance reasons

/*! @param start - the earliest date to allow into the sorted array
    @returns subarray of sampleDates which are after the date provided */
- (NSArray<NSDate *>*)sampleDatesAfter:(NSDate *)start;

/*! @param start - the earliest date to allow into the sorted array
    @param end - the latest date to allow into the sorted array
    @returns subarray of sampleDates which are between the dates provided */
- (NSArray<NSDate *>*)sampleDatesBetween:(NSDate *)start and:(NSDate *)end;

@end

NS_ASSUME_NONNULL_END
