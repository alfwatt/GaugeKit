//
//  Copyright © 2016 AutomaticLabs. All rights reserved.
//

#import "ALTimelineView.h"

NS_ASSUME_NONNULL_BEGIN

static CGFloat const ALTimelineDefaultScale = 0.5f;
static NSTimeInterval const ALTimelineZeroOffset = 0.0f;

#pragma mark -

@implementation ALTimelineView

- (NSDate *)earliestVisibleDate {
    CGFloat widthInPixels = self.frame.size.width;
    NSTimeInterval visibleInterval = (widthInPixels / ALTimelineDefaultScale);
    NSDate *earliest = [NSDate dateWithTimeInterval:-visibleInterval sinceDate:self.mostRecentVisibleDate];
    return earliest;
}

- (NSDate *)mostRecentVisibleDate {
    return [NSDate dateWithTimeInterval:self.timeOffset sinceDate:[NSDate date]];
}

- (CGFloat)horizontalPositionOfDate:(NSDate *)timelineDate {
    NSTimeInterval elapsed = [timelineDate timeIntervalSinceDate:self.mostRecentVisibleDate];
    return (self.bounds.size.width - (elapsed * self.timeScale));
}

#pragma mark - ALBorderedView

- (void)initView {
    [super initView];

    /* pinching the view adjusts the time scale */
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self addGestureRecognizer:pinchGesture];

    /* swiping the view adjust the time offset */
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight & UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipeGesture];

    /* tapping the view resets the scale and offset to their defaults */
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tapGesture];
    [self handleTap:tapGesture];
}

#pragma mark - UIGestureRecognizer

-(void)handlePinch:(UIPinchGestureRecognizer *)pinch {
    // adjust the timeScale
    NSLog(@"%@ handlePinch: %@ -> %f", self.class, pinch, self.timeScale);
}

-(void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    // adjust the timeOffset
    NSLog(@"%@ handleSwipe: %@ -> %f", self.class, swipe, self.timeOffset);
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    self.timeScale = ALTimelineDefaultScale;
    self.timeOffset = ALTimelineZeroOffset;
    NSLog(@"%@ handleTap: %@", self.class, tap);
}

@end

NS_ASSUME_NONNULL_END
