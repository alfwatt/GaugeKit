#import <GaugeKit/ILBorderedView.h>

NS_ASSUME_NONNULL_BEGIN

/*! @abstract abstract superclass of timeline views */
@interface ILTimelineView : ILBorderedView

/*! @abstract multiplier for the default 1 second per pixel time scale */
@property (nonatomic, assign) CGFloat timeScale;

/*! @abstract time offset from now to display data for */
@property (nonatomic, assign) NSTimeInterval timeOffset;

/*! @returns the earliest date visible in the timeilne view */
@property (nonatomic, readonly, copy) NSDate *earliestVisibleDate;

/*! @returns the most recent date visible in the timeline view */
@property (nonatomic, readonly, copy) NSDate *mostRecentVisibleDate;

/*! @returns the horizontal posiion of the date in the timeline view in screen pixels */
- (CGFloat)horizontalPositionOfDate:(NSDate *)timelineDate;

@end

NS_ASSUME_NONNULL_END
