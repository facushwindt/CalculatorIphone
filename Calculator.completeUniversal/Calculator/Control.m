//
//  Control.m
//  Calculator
//
//  Created by facundo schwindt on 25/07/12.
//  Copyright (c) 2012 Elemental Geeks. All rights reserved.
//

#import "Control.h"
#import "GraphicView.h"
#import "CalculatorBrain.h"
#define CENTER_X self.bounds.size.width/2
#define CENTER_Y self.bounds.size.height/2


@interface Control () <GraphicsViewDatasource, descriptionOfProgViewDatasource, centerPointViewDatasource>
@property (nonatomic, weak) IBOutlet GraphicView * graphicView;
@property (nonatomic, strong) NSMutableArray * points;
@property (nonatomic) NSString * descriptionOfProg;
@property (nonatomic) CGPoint centerPoint;

@end

@implementation Control
@synthesize graphicView = _GraphicView;
@synthesize points = _points;
@synthesize descriptionOfProg = _descriptionOfProg;
@synthesize centerPoint = _centerPoint;


-(void)setPoints:(NSMutableArray *)points{
    _points = points;
    [self.graphicView setNeedsDisplay];
}

-(NSMutableArray *)points{
    if(!_points){
        _points = [[NSMutableArray alloc] init]; 
    }
    return _points;
}

-(void)setCenterPoint:(CGPoint)centerPoint{
    if (_centerPoint.x != centerPoint.x || _centerPoint.y != centerPoint.y) {
        _centerPoint.x += centerPoint.x;
        _centerPoint.y += centerPoint.y;
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setFloat:_centerPoint.x forKey:@"componenteX"];
        [defaults setFloat:_centerPoint.y forKey:@"componenteY"];
        [defaults synchronize];
        [self.graphicView setNeedsDisplay];
    }
}

-(CGPoint)centerPoint{
    if(_centerPoint.x == 0 && _centerPoint.y == 0){
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        _centerPoint.x = [defaults floatForKey:@"componenteX"];
        _centerPoint.y = [defaults floatForKey:@"componenteY"];
    }
    return _centerPoint;
}

-(void)pan:(UIPanGestureRecognizer*) gesture{
    if( (gesture.state == UIGestureRecognizerStateEnded) || 
       (gesture.state == UIGestureRecognizerStateChanged)){
        CGPoint translation = [gesture translationInView:self.graphicView];
        self.centerPoint = translation;
        [gesture setTranslation:CGPointZero inView:self.graphicView];
    }

}

-(void)setGraphicView:(GraphicView *)graphicView{
    _GraphicView = graphicView;
    _GraphicView.datasource = self;
    _GraphicView.datasourceProgram = self;
    _GraphicView.datasourceCenterPoint = self;
    [self.graphicView addGestureRecognizer:[[UIPinchGestureRecognizer alloc]initWithTarget:self.graphicView action:@selector(pinch:)]];
    [self.graphicView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)]];
    
}


-(NSMutableArray *)pointsForGraphicsView:(GraphicView *) sender{
    return self.points;
}

-(NSString*)getDescriptionOfProgram:(GraphicView *) sender2{
    return self.descriptionOfProg;
}

-(CGPoint)getCenterPointForView:(GraphicView *) sender3{
    return self.centerPoint;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)DrawInView:(NSMutableArray*) currentProgram{
    self.descriptionOfProg = [CalculatorBrain descriptionOfProgram: currentProgram];
    for (double xValue=-30.0; xValue < 30.0; xValue+=0.1) {
//        NSLog(@"%@",[NSString stringWithFormat:@"%g",xValue]);
        
        double result_y_axes = [CalculatorBrain runProgram:currentProgram usingVariableValues:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat: xValue], @"x",nil]];
        CGPoint point= CGPointMake(xValue, result_y_axes);
        [self.points addObject:[NSValue valueWithCGPoint:point]];
        
        NSLog(@"%@",[NSString stringWithFormat:@"%g",point.y]);
        
    }
    
    [self.graphicView setNeedsDisplay];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
