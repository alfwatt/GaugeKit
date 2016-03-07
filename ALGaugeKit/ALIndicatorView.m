//
//  Copyright (c) 2015 Automatic Labs. All rights reserved.
//

#import "ALIndicatorView.h"

NS_ASSUME_NONNULL_BEGIN

static CGFloat const LevelIndicatorRingWidth = 15;

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
    self.indicatorLayer.frame = self.bounds;
//    NSLog(@"<%@ %p layoutSubviews frame: %@ layer frame: %@ layer bounds: %@>",
//        self.class, self, NSStringFromCGRect(self.frame),
//        NSStringFromCGRect(self.style == ALLevelIndicatorStyleText ? self.indicatorText.frame : self.indicatorLayer.frame),
//        NSStringFromCGRect(self.style == ALLevelIndicatorStyleText ? self.indicatorText.bounds : self.indicatorLayer.bounds));
}

#pragma mark - ALBorderedView

- (void)initView {
    [super initView];
    self.style = ALLevelIndicatorStyleText;
    self.dataSource = nil;

    self.indicatorLayer = [CAShapeLayer new];
    [self.layer addSublayer:self.indicatorLayer];

    self.indicatorText = [CATextLayer new];
    [self.layer addSublayer:self.indicatorText];
}

- (void)updateView {
    [super updateView];

    UIBezierPath* filledPath = nil;

    self.indicatorLayer.hidden = (self.style == ALLevelIndicatorStyleText);
    self.indicatorText.hidden = (self.style != ALLevelIndicatorStyleText);

    if (self.dataSource) {
        switch (self.style) {
            case ALLevelIndicatorStyleText: {
                NSString* valueString = [NSString stringWithFormat:@"%.1f%%", self.dataSource.indicatorPosition*100];
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
                CGFloat indicatorPosition = self.bounds.size.height - (self.bounds.size.height * self.dataSource.indicatorPosition);
                CGRect filledRect = CGRectMake(0,indicatorPosition, self.bounds.size.width,self.bounds.size.height-indicatorPosition);
                filledPath = [UIBezierPath bezierPathWithRect:CGRectInset(filledRect,self.lineWidth,self.lineWidth)];
                break;
            }
            case ALLevelIndicatorStyleHorizontal: {
                CGFloat indicatorPosition = (self.bounds.size.width * self.dataSource.indicatorPosition);
                CGRect filledRect = CGRectMake(0,0, indicatorPosition,self.bounds.size.height);
                filledPath = [UIBezierPath bezierPathWithRect:CGRectInset(filledRect,self.lineWidth,self.lineWidth)];
                break;
            }
            case ALLevelIndicatorStyleSquare: {
                CGRect squareRect = CGRectInset(ALCGRectSquareInRect(self.bounds), ALBorderlineWidth, ALBorderlineWidth);
                CGFloat indicatorSideLength = (squareRect.size.height * self.dataSource.indicatorPosition);
                CGFloat indicatorInset = (squareRect.size.width-indicatorSideLength)/2; // ??? take the square root?
                CGRect filledRect = CGRectInset(squareRect, indicatorInset, indicatorInset);
                filledPath = [UIBezierPath bezierPathWithRect:filledRect];
                break;
            }
            case ALLevelIndicatorStyleCircle: {
                CGFloat squareInsets = ALBorderlineWidth + self.lineWidth;
                CGRect squareRect = CGRectInset(ALCGRectSquareInRect(self.bounds), squareInsets, squareInsets);
                CGFloat indicatorSideLength = (squareRect.size.height * self.dataSource.indicatorPosition);
                CGFloat indicatorInset = (squareRect.size.width-indicatorSideLength)/2; // equal area?
                CGRect filledRect = CGRectInset(squareRect, indicatorInset, indicatorInset);
                filledPath = [UIBezierPath bezierPathWithOvalInRect:filledRect];
                break;
            }
            case ALLevelIndicatorStyleRing: {
                CGFloat squareInsets = ALBorderlineWidth + self.lineWidth;
                CGRect squareRect = CGRectInset(ALCGRectSquareInRect(self.bounds), squareInsets, squareInsets);
                CGFloat indicatorSideLength = (squareRect.size.height/2)-squareInsets;
                CGPoint squareCenter = CGPointMake(squareRect.origin.x+(squareRect.size.width/2), squareRect.origin.y+(squareRect.size.height/2));
                CGPoint topDeadCenter = CGPointMake(squareRect.origin.x+(squareRect.size.width/2),squareCenter.y-indicatorSideLength);
                CGFloat firstAngle = (CGFloat)-(M_PI/2);
                CGFloat secondAngle = (CGFloat)((2*M_PI)*self.dataSource.indicatorPosition)-(CGFloat)(M_PI/2.0f);
                filledPath = [UIBezierPath new];
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
                CGPoint squareCenter = CGPointMake(squareRect.origin.x+(squareRect.size.width/2), squareRect.origin.y+(squareRect.size.height/2));
                CGPoint topDeadCenter = CGPointMake(squareRect.origin.x+(squareRect.size.width/2),squareCenter.y-indicatorSideLength);
                CGFloat firstAngle = (CGFloat)-(M_PI/2);
                CGFloat secondAngle = (CGFloat)((2*M_PI)*self.dataSource.indicatorPosition)-(CGFloat)(M_PI/2);
                filledPath = [UIBezierPath new];
                [filledPath addArcWithCenter:squareCenter radius:indicatorSideLength startAngle:firstAngle endAngle:secondAngle clockwise:YES];
                [filledPath addLineToPoint:squareCenter];
                [filledPath addLineToPoint:topDeadCenter];
                break;
            }
            case ALLevelIndicatorStyleDial: {
                CGFloat squareInsets = ALBorderlineWidth + self.lineWidth;
                CGRect squareRect = CGRectInset(ALCGRectSquareInRect(self.bounds), squareInsets, squareInsets);
                CGFloat indicatorSideLength = (squareRect.size.height/2)-squareInsets;
                CGPoint squareCenter = ALCGPointCenteredInRect(squareRect);
                CGFloat indicatorAngle = (CGFloat)((2*M_PI)*self.dataSource.indicatorPosition)-(CGFloat)(M_PI/2);
                filledPath = [UIBezierPath new];
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
    if (self.style == ALLevelIndicatorStyleText) {
        return [super circularBorder];
    }
    else {
        return (self.style == ALLevelIndicatorStyleCircle)
            || (self.style == ALLevelIndicatorStyleRing)
            || (self.style == ALLevelIndicatorStylePie)
            || (self.style == ALLevelIndicatorStyleDial);
    }
}

@end

NS_ASSUME_NONNULL_END
