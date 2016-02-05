//
//  ALIndicatorView.m
//  Automatic
//
//  Created by Alf Watt on 2/1/16.
//  Copyright (c) 2015 Automatic Labs. All rights reserved.
//

#import "ALIndicatorView.h"

NS_ASSUME_NONNULL_BEGIN

static CGFloat const LevelIndicatorRingWidth = 10;

#pragma mark - Private

@interface ALIndicatorView ()
@property (nonatomic, retain) CATextLayer *indicatorText;
@property (nonatomic, retain) CAShapeLayer *indicatorLayer;
@end

#pragma mark -

@implementation ALIndicatorView

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    self.indicatorText.frame = self.bounds;
    self.indicatorLayer.frame = self.bounds;
}

#pragma mark - ALBorderedView

- (void)initView {
    [super initView];
    self.style = ALLevelIndicatorStyleText;
    self.dataSource = nil;
    self.minValue = 0;
    self.maxValue = 1;
//    self.minAngle = 0;
//    self.maxAngle = 0;
//    self.valueDivisions = 2;

    self.indicatorLayer = [CAShapeLayer new];
    [self.layer addSublayer:self.indicatorLayer];

    self.indicatorText = [CATextLayer new];
    [self.layer addSublayer:self.indicatorText];
}

- (void)updateView {
    [super updateView];

    UIBezierPath* filledPath = nil;

    if (self.dataSource) {
        switch (self.style) {
            case ALLevelIndicatorStyleText: {
                NSString* valueString = [NSString stringWithFormat:@"%.2f", self.dataSource.indicatorPosition];
                NSMutableParagraphStyle* valueStyle = [NSMutableParagraphStyle new];
                valueStyle.alignment = NSTextAlignmentCenter;

                NSAttributedString* attributedValueString = [[NSAttributedString alloc] initWithString:valueString attributes:@{
                    NSParagraphStyleAttributeName: valueStyle,
                    NSFontAttributeName: [UIFont systemFontOfSize:[UIFont systemFontSize]*2],
                    NSForegroundColorAttributeName: self.lineColor
                }];

                // compute the string size and offsets
                CGSize stringSize = attributedValueString.size;
                CGFloat xOffset = (self.bounds.size.width-stringSize.width)/2;
                CGFloat yOffset = (self.bounds.size.height-stringSize.height)/2;
                CGRect stringRect = CGRectIntegral(CGRectMake(xOffset, yOffset, stringSize.width, stringSize.height));

                // set text properties and mask
                self.indicatorText.mask = self.borderMask;
                self.indicatorText.string = attributedValueString;
                self.indicatorText.frame = stringRect;
                break;
            }
            case ALLevelIndicatorStyleVertical: {
                CGFloat indicatorPosition = self.bounds.size.height - (self.bounds.size.height * self.indicatorPercent);
                CGRect filledRect = CGRectMake(0,indicatorPosition, self.bounds.size.width,self.bounds.size.height-indicatorPosition);
                filledPath = [UIBezierPath bezierPathWithRect:CGRectInset(filledRect,self.lineWidth,self.lineWidth)];
                break;
            }
            case ALLevelIndicatorStyleHorizontal: {
                CGFloat indicatorPosition = (self.bounds.size.width * self.indicatorPercent);
                CGRect filledRect = CGRectMake(0,0, indicatorPosition,self.bounds.size.height);
                filledPath = [UIBezierPath bezierPathWithRect:CGRectInset(filledRect,self.lineWidth,self.lineWidth)];
                break;
            }
            case ALLevelIndicatorStyleSquare: {
                CGRect squareRect = CGRectInset(ALCGRectSquareInRect(self.bounds), ALBorderlineWidth, ALBorderlineWidth);
                CGFloat indicatorSideLength = (squareRect.size.height * self.indicatorPercent);
                CGFloat indicatorInset = (squareRect.size.width-indicatorSideLength)/2; // ??? take the square root?
                CGRect filledRect = CGRectInset(squareRect, indicatorInset, indicatorInset);
                filledPath = [UIBezierPath bezierPathWithRect:filledRect];
                break;
            }
            case ALLevelIndicatorStyleCircle: {
                CGFloat squareInsets = ALBorderlineWidth + self.lineWidth;
                CGRect squareRect = CGRectInset(ALCGRectSquareInRect(self.bounds), squareInsets, squareInsets);
                CGFloat indicatorSideLength = (squareRect.size.height * self.indicatorPercent);
                CGFloat indicatorInset = (squareRect.size.width-indicatorSideLength)/2; // equal area?
                CGRect filledRect = CGRectInset(squareRect, indicatorInset, indicatorInset);
                filledPath = [UIBezierPath bezierPathWithOvalInRect:filledRect];
                break;
            }
            case ALLevelIndicatorStyleRing: {
                CGFloat squareInsets = ALBorderlineWidth + self.lineWidth;
                CGRect squareRect = CGRectInset(ALCGRectSquareInRect(self.bounds), squareInsets, squareInsets);
                CGFloat indicatorSideLength = (squareRect.size.height/2)-squareInsets;
                filledPath = [UIBezierPath new];
                CGPoint squareCenter = CGPointMake(squareRect.origin.x+(squareRect.size.width/2), squareRect.origin.y+(squareRect.size.height/2));
                CGPoint topDeadCenter = CGPointMake(squareRect.origin.x+(squareRect.size.width/2),squareCenter.y-indicatorSideLength);
                CGFloat firstAngle = (CGFloat)-(M_PI/2);
                CGFloat secondAngle = (CGFloat)((2*M_PI)*self.indicatorPercent)-(CGFloat)(M_PI/2.0f);
                [filledPath addArcWithCenter:squareCenter radius:indicatorSideLength startAngle:firstAngle endAngle:secondAngle clockwise:YES];
                CGPoint outsideEndPoint = filledPath.currentPoint;
                CGPoint insetPoint = ALCGPointOnLineToPointAtDistance(outsideEndPoint,squareCenter,LevelIndicatorRingWidth);
                [filledPath addLineToPoint:insetPoint];
                [filledPath addArcWithCenter:squareCenter radius:indicatorSideLength-LevelIndicatorRingWidth startAngle:secondAngle endAngle:firstAngle clockwise:NO];
                [filledPath addLineToPoint:topDeadCenter];
                break;
            }
            case ALLevelIndicatorStylePie: {
                CGFloat squareInsets = ALBorderlineWidth + self.lineWidth;
                CGRect squareRect = CGRectInset(ALCGRectSquareInRect(self.bounds), squareInsets, squareInsets);
                CGFloat indicatorSideLength = (squareRect.size.height/2)-squareInsets;
                filledPath = [UIBezierPath new];
                CGPoint squareCenter = CGPointMake(squareRect.origin.x+(squareRect.size.width/2), squareRect.origin.y+(squareRect.size.height/2));
                CGPoint topDeadCenter = CGPointMake(squareRect.origin.x+(squareRect.size.width/2),squareCenter.y-indicatorSideLength);
                CGFloat firstAngle = (CGFloat)-(M_PI/2);
                CGFloat secondAngle = (CGFloat)((2*M_PI)*self.indicatorPercent)-(CGFloat)(M_PI/2);
                [filledPath addArcWithCenter:squareCenter radius:indicatorSideLength startAngle:firstAngle endAngle:secondAngle clockwise:YES];
                [filledPath addLineToPoint:squareCenter];
                [filledPath addLineToPoint:topDeadCenter];
                break;
            }
            case ALLevelIndicatorStyleDial: {
                CGFloat squareInsets = ALBorderlineWidth + self.lineWidth;
                CGRect squareRect = CGRectInset(ALCGRectSquareInRect(self.bounds), squareInsets, squareInsets);
                CGFloat indicatorSideLength = (squareRect.size.height/2)-squareInsets;
                UIBezierPath *filledPath = [UIBezierPath new];
                CGPoint squareCenter = ALCGPointCenteredInRect(squareRect);
                CGFloat indicatorAngle = (CGFloat)((2*M_PI)*self.indicatorPercent)-(CGFloat)(M_PI/2);
                [filledPath addArcWithCenter:squareCenter radius:indicatorSideLength startAngle:indicatorAngle endAngle:indicatorAngle clockwise:YES];
                [filledPath addLineToPoint:squareCenter];
                // XXX don't really want to force this, more of a default setting
                self.lineWidth = ALBoldlineWidth;
                break;
            }
        }
    }

    self.indicatorLayer.path = filledPath.CGPath;
    self.indicatorLayer.mask = self.borderMask;
    self.indicatorLayer.fillColor = self.fillColor.CGColor;
    self.indicatorLayer.strokeColor = self.lineColor.CGColor;
    self.indicatorLayer.lineWidth = self.lineWidth;
}

- (BOOL)circularBorder {
    return (self.style == ALLevelIndicatorStyleCircle)
        || (self.style == ALLevelIndicatorStyleRing)
        || (self.style == ALLevelIndicatorStylePie)
        || (self.style == ALLevelIndicatorStyleDial);
}

#pragma mark - ALIndicatorView

- (CGFloat)indicatorPercent {
    return ((self.dataSource.indicatorPosition-self.minValue) / self.maxValue);
}

@end

NS_ASSUME_NONNULL_END
