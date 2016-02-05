//
//  ALIndicatorView.h
//  Automatic
//
//  Created by Alf Watt on 2/1/16.
//  Copyright (c) 2015 Automatic Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ALBorderedView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ALIndicatorDataSource;

/*!
    @abstract drawing style of the level indicator
    @cost ALLevelIndicatorStyleText - the default style, a textual description of the value
    @cost ALLevelIndicatorStyleVertical - a vertical indicator, like a thermometer
    @cost ALLevelIndicatorStyleHorizontal - a horizontal indicator, like a thermometer
    @cost ALLevelIndicatorStyleSquare - a scaled square centered inside of the border
    @cost ALLevelIndicatorStyleCircle - a scaled circle centered inside of the border
    @cost ALLevelIndicatorStyleRing - a circular ring, with zero at the 12 o'clock position
    @cost ALLevelIndicatorStylePie - a pie chart, with zero at the 12 o'clock pososion
    @cost ALLevelIndicatorStyleDial - a dial, with zero at the 12 o'clock pososion
*/
typedef NS_ENUM(NSInteger, ALLevelIndicatorStyle) {
    ALLevelIndicatorStyleText,
    ALLevelIndicatorStyleVertical,
    ALLevelIndicatorStyleHorizontal,
    ALLevelIndicatorStyleSquare,
    ALLevelIndicatorStyleCircle,
    ALLevelIndicatorStyleRing,
    ALLevelIndicatorStylePie,
    ALLevelIndicatorStyleDial
};

#pragma mark -

/*! @abstract An indicator view which displays a single numeric value as a string */
@interface ALIndicatorView : ALBorderedView

/*! @abstract the style of the indicator */
@property (nonatomic, assign) ALLevelIndicatorStyle style;

/*! @abstract the data source for the indicator implmeneting the ALIndicatorDataSource protocol */
@property (nonatomic, weak) id<ALIndicatorDataSource> dataSource;

/*! @abstract smallest number displayable on the indicator, default is 0 */
@property (nonatomic, assign) CGFloat minValue;

/*! @abstract largest number displayable on the indicator, default is 1 */
@property (nonatomic, assign) CGFloat maxValue;

/*! @abstract current percentage of the max that is displayed on the indicator */
@property (nonatomic, readonly) CGFloat indicatorPercent;

// TODO @property (nonatomic, assign) CGFloat minAngle; // angle of the min value for circular indicators
// TODO @property (nonatomic, assign) CGFloat maxAngle; // angle of the max value for circular indicators
// TODO @property (nonatomic, assign) NSInteger valueDivisions; // number of value divisions (tick-marks)

@end

#pragma mark -

/*! @abstract data source protocol for a single-value indicator view */
@protocol ALIndicatorDataSource <NSObject>

/*! @abstract position of the indicator, by default a value between 0-1 */
@property (nonatomic, readonly) CGFloat indicatorPosition;

@end

NS_ASSUME_NONNULL_END
