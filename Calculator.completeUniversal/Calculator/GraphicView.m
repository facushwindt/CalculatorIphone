//
//  GraphicView.m
//  Calculator
//
//  Created by facundo schwindt on 25/07/12.
//  Copyright (c) 2012 Elemental Geeks. All rights reserved.
//

#import "GraphicView.h"
#import "AxesDrawer.m"
#define OFFSET_X self.bounds.size.width/2
#define OFFSET_Y self.bounds.size.height/2
#define DEFAULT_SCALE 50
#define CENTER_X self.bounds.size.width/2
#define CENTER_Y self.bounds.size.height/2

@interface GraphicView()
@property (nonatomic,strong) NSMutableArray* array;
@end

@implementation GraphicView
@synthesize datasource = _datasource;
@synthesize array = _array;
@synthesize scale = _scale;
@synthesize datasourceProgram = _datasourceProgram;
@synthesize centerPoint = _centerPoint;
@synthesize datasourceCenterPoint = _datasourceCenterPoint;


-(void)seter{
    self.contentMode = UIViewContentModeRedraw;
}

-(void)awakeFromNib{
    [self seter];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self seter];
    }
    return self;
}

-(void)drawpoints:(NSMutableArray*)points{
    _array = points;
}

-(void)setScale:(CGFloat)scale{
    if(_scale != scale){
        _scale = scale;
        [self setNeedsDisplay];
    }
}

-(CGFloat)scale{
    if(!_scale)
        _scale= DEFAULT_SCALE;
    return _scale;
}


-(CGPoint)graphicOffset:(CGPoint)point{
    CGPoint gpoint;
    gpoint.x = point.x * self.scale  + self.centerPoint.x ;
    gpoint.y = -1 * point.y * self.scale + 5 + self.centerPoint.y;
    return gpoint;
}



-(void)pinch:(UIPinchGestureRecognizer *) gesture{
    if( (gesture.state == UIGestureRecognizerStateEnded) || 
        (gesture.state == UIGestureRecognizerStateChanged)){
        self.scale *= gesture.scale;
        gesture.scale = 1;
    }
}


- (void)drawRect:(CGRect)rect
{
    //datasource para obtener buscar en el controler el centro de la gráfica
    self.centerPoint = [self.datasourceCenterPoint getCenterPointForView:self];
    
    //Draw Axes
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:self.centerPoint scale:self.scale];
    
    // A través de un datasource busca descriptionOfProgem
    NSString* descripcion = [[NSString alloc]init];
    descripcion = [self.datasourceProgram getDescriptionOfProgram:self];    
    
    
    [AxesDrawer drawString: descripcion atPoint:CGPointMake(20 +[descripcion length]*2 ,2* OFFSET_Y) withAnchor:3.0]; 
    
    //delegado para buscar los puntos en el controller
    NSMutableArray *aa = [self.datasource pointsForGraphicsView:self];
    
    for(int index= 0 ; index < [aa count] ;  index +=1 ){
        NSValue *value =  [aa objectAtIndex:index ];
        CGPoint p = [value CGPointValue];
        //Draw points
        [AxesDrawer drawString:@"." atPoint:[self graphicOffset:p] withAnchor:3.0]; 
    }
}

@end
