#import "MCMTileView.h"


@implementation MCMTileView
-(void)drawRect:(NSRect)dirtyRect{
  NSRect bounds = [self bounds];
  [[NSColor lightGrayColor] setFill];
  [[NSColor darkGrayColor] setStroke];
  [[NSBezierPath bezierPathWithRect:bounds] fill];
  [[NSBezierPath bezierPathWithRect:bounds] stroke];
}
@end
