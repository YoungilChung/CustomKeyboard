//
// Created by Tom Atterton on 18/04/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "ButtonShape.h"


@implementation ButtonShape


- (instancetype)init {
	self = [super init];

	if (self) {
		[self setBackgroundColor:[UIColor clearColor]];
		self.clipsToBounds = YES;
	}

	return self;
}

- (void)drawRect:(CGRect)rect {

	CGFloat minX = CGRectGetMinX(rect);
	CGFloat minY = CGRectGetMinY(rect);
	CGFloat maxX = CGRectGetMaxX(rect);
	CGFloat maxY = CGRectGetMaxY(rect);


	CGFloat buttonMinY;
	if (self.buttonView.size.height == 0) {

		buttonMinY = maxY - 45;
	}
	else {
		buttonMinY = maxY - self.buttonView.size.height;

	}

	CGFloat paddingX = 0;


	self.path = [UIBezierPath bezierPath];
//	minY = minY + 160;

	[self.path moveToPoint:CGPointMake(minX, minY)];

	[self.path addCurveToPoint:CGPointMake(minX + paddingX, buttonMinY) controlPoint1:CGPointMake(minX, minY) controlPoint2:CGPointMake(minX + 12, (CGFloat) (buttonMinY / 1.5))];
	[self.path addLineToPoint:CGPointMake(minX + paddingX, maxY)];
	[self.path addLineToPoint:CGPointMake(maxX - paddingX, maxY)];
	[self.path addLineToPoint:CGPointMake(maxX - paddingX, buttonMinY)];
	[self.path addCurveToPoint:CGPointMake(maxX, minY) controlPoint1:CGPointMake(maxX, buttonMinY) controlPoint2:CGPointMake(maxX - 12, (CGFloat) (buttonMinY / 1.5))];
	[self.path closePath];


//	path.lineWidth = 2.0;
	[self.path setLineJoinStyle:kCGLineJoinRound];
	[self.path setLineCapStyle:kCGLineCapRound];
	[[UIColor lightGrayColor] setFill];
	[self.path fill];

//	CGRect bounds = self.bounds;
//	CGFloat xMax = CGRectGetMaxX(bounds);
//	CGFloat yMax = CGRectGetMaxY(bounds);
//	CGFloat shadowDepth  = 5;
//	[path moveToPoint:CGPointMake(self.bounds.origin.x + shadowDepth, self.bounds.origin.y)];
//	[path addLineToPoint:CGPointMake(xMax + shadowDepth, self.bounds.origin.y)];
//	[path addLineToPoint:CGPointMake(xMax, yMax)];
//	[path addLineToPoint:CGPointMake(self.bounds.origin.x, yMax)];
//	[path closePath];
//	self.layer.shadowPath = path.CGPath;



	[self.layer setShadowOffset:CGSizeMake(0, 3)];
	[self.layer setShadowOpacity:0.4];
	[self.layer setShadowRadius:3.0f];
	[self.layer setShouldRasterize:YES];
	[self.layer setCornerRadius:4.0f];
	[self.layer setShadowPath:self.path.CGPath];

//	CGContextRef context = UIGraphicsGetCurrentContext();
//	CGContextAddPath(context, path.CGPath);
//	CGContextSetLineWidth(context, 0.2);
//	CGContextSetBlendMode(context, (CGBlendMode) path.CGPath);
//	CGContextSetShadowWithColor(context, CGSizeMake(1.0, 1.0), 1.0, [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor);
//	CGContextStrokePath(context);


//	self.layer.masksToBounds = YES;
//	self.layer.shadowColor = [UIColor grayColor].CGColor;
//	self.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
//	self.layer.shadowOpacity = 0.5f;
//	self.layer.shadowPath = path.CGPath;

//	CGRect  bounds  = rect;
//	CGFloat minx = CGRectGetMinX(bounds), midx = CGRectGetMidX(bounds), maxx = CGRectGetMaxX(bounds);
//	CGFloat miny = CGRectGetMinY(bounds), maxy = CGRectGetMaxY(bounds);
//	CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);
//	CGContextSetLineWidth(context, 1.0);
//	CGContextBeginPath(context);
//	CGContextSetStrokeColorWithColor(context,[UIColor clearColor].CGColor);
//	CGContextMoveToPoint(context, minx, maxy);
//	CGContextAddLineToPoint(context, midx, miny);
//	CGContextAddLineToPoint(context, maxx, maxy);
//	CGContextClosePath(context);
//	CGContextRotateCTM(context, (CGFloat) (3.0));
//
//	CGContextDrawPath(context, kCGPathFillStroke);

//	CGContextFillRect(context, CGRectMake((rect.size.width / 2), 0, 0.5, rect.size.height / 2));
//	CGContextFillRect(context, CGRectMake(0, rect.size.height / 2, rect.size.width, 0.5f));
//	CGContextFillRect(context, CGRectMake(0, rect.size.height / 2, 0.5f, rect.size.height / 2));
//	CGContextFillRect(context, CGRectMake(rect.size.width - 0.5f, rect.size.height / 2, 0.5f, rect.size.height / 2));


//	self.layer.shadowColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.25f] CGColor];
//	self.layer.shadowOffset = CGSizeMake(0, 2.0f);
//	self.layer.shadowOpacity = 1.0f;
//	self.layer.shadowRadius = 0.0f;
//	self.layer.masksToBounds = NO;
//	self.layer.cornerRadius = 4.0f;

}


- (void)layoutSubviews {


	[self setNeedsDisplay];


}

//- (CGSize)intrinsicContentSize
//{
//	return CGSizeMake(64, 33);
//}


@end