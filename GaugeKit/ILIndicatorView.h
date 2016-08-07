#import <UIKit/UIKit.h>

#import "ILBorderedView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ILIndicatorDataSource;

/*!
    @abstract drawing style of the level indicator
    @cost ILLevelIndicatorStyleText - the default style, a textual description of the value
    @cost ILLevelIndicatorStyleVertical - a vertical indicator, like a thermometer
    @cost ILLevelIndicatorStyleHorizontal - a horizontal indicator, like a thermometer
    @cost ILLevelIndicatorStyleSquare - a scaled square centered inside of the border
    @cost ILLevelIndicatorStyleCircle - a scaled circle centered inside of the border
    @cost ILLevelIndicatorStyleRing - a circular ring, with zero at the 12 o'clock position
    @cost ILLevelIndicatorStylePie - a pie chart, with zero at the 12 o'clock pososion
    @cost ILLevelIndicatorStyleDial - a dial, with zero at the 12 o'clock pososion
*/
typedef NS_ENUM(NSInteger, ILLevelIndicatorStyle) {
    ILLevelIndicatorStyleText,
    ILLevelIndicatorStyleVertical,
    ILLevelIndicatorStyleHorizontal,
    ILLevelIndicatorStyleSquare,
    ILLevelIndicatorStyleCircle,
    ILLevelIndicatorStyleRing,
    ILLevelIndicatorStylePie,
    ILLevelIndicatorStyleDial
};

#pragma mark -

/*! @abstract An indicator view which displays a single numeric value as a string */
@interface ILIndicatorView : ILBorderedView

/*! @abstract the style of the indicator */
@property (nonatomic, assign) ILLevelIndicatorStyle style;

/*! @abstract the data source for the indicator implmeneting the ILIndicatorDataSource protocol */
@property (nonatomic, weak) id<ILIndicatorDataSource> dataSource;

// TODO @property (nonatomic, assign) CGFloat minAngle; // angle of the min value for circular indicators
// TODO @property (nonatomic, assign) CGFloat maxAngle; // angle of the max value for circular indicators
// TODO @property (nonatomic, assign) NSUInteger valueDivisions; // number of value divisions (tick-marks)

@end

#pragma mark -

/*! @abstract data source protocol for a single-value indicator view */
@protocol ILIndicatorDataSource <NSObject>

/*! @abstract position of the indicator, a scaled value between 0-1 */
@property (nonatomic, readonly) CGFloat indicatorPosition;

@end

NS_ASSUME_NONNULL_END
