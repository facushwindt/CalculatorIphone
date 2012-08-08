//
//  GraphicView.h
//  Calculator
//
//  Created by facundo schwindt on 25/07/12.
//  Copyright (c) 2012 Elemental Geeks. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GraphicView;
@protocol GraphicsViewDatasource
-(NSMutableArray *)pointsForGraphicsView:(GraphicView *) sender;
@end

@protocol descriptionOfProgViewDatasource
-(NSString*)getDescriptionOfProgram:(GraphicView *) sender2;
@end

@protocol centerPointViewDatasource
-(CGPoint)getCenterPointForView:(GraphicView *) sender3;
@end

@interface GraphicView : UIView
@property (nonatomic,weak) IBOutlet id <GraphicsViewDatasource> datasource;
@property (nonatomic,weak) IBOutlet id <descriptionOfProgViewDatasource> datasourceProgram;
@property (nonatomic,weak) IBOutlet id <centerPointViewDatasource> datasourceCenterPoint;

@property (nonatomic) CGFloat scale;
@property (nonatomic) CGPoint centerPoint;

-(void)drawpoints:(NSMutableArray*)points;
-(void)pinch:(UIPinchGestureRecognizer *) gesture;

@end
