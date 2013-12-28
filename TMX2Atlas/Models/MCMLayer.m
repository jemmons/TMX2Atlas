#import "MCMLayer.h"
#import "NSArray+HOF.h"

NSString * const TMXLayerNameKey = @"TMXLayerName";
NSString * const TMXLayerIsVisibleKey = @"TMXLayerIsVisible";
NSString * const TMXLayerOpacityKey = @"TMXLayerOpacity";
NSString * const TMXLayerTilesKey = @"TMXLayerTiles";


@implementation MCMLayer
#pragma mark - INIT/SETUP
+(instancetype)layerWithAttributes:(NSDictionary *)att{
  NSParameterAssert(att[@"name"]);
  MCMLayer *layer = [MCMLayer new];
  [layer setName:att[@"name"]];
  [layer setVisible:YES];
  if(att[@"visible"] && [@"0" isEqualToString:att[@"visible"]]){
    [layer setVisible:NO];
  }
  [layer setOpacity:1.0];
  if(att[@"opacity"]){
    [layer setOpacity:[att[@"opacity"] floatValue]];
  }
  [layer setTiles:@[]];
  
  return layer;
}


#pragma mark - ACCESSORS
-(NSArray *)fullTiles{
  return [[self tiles] filter:^BOOL(id it) {
    return [it integerValue];
  }];
}


-(void)addTile:(NSInteger)tileID{
  [self setTiles:[[self tiles] arrayByAddingObject:@(tileID)]];
}


-(NSString *)description{
  return [NSString stringWithFormat:@"%@: %@/%.2f, %lu tiles", [self name], [self isVisible]?@"visible":@"hidden", [self opacity], (unsigned long)[[self tiles] count]];
}


#pragma mark - ACTIONS
-(NSDictionary *)serialize{
  return @{TMXLayerNameKey: [self name],
           TMXLayerIsVisibleKey: @([self isVisible]),
           TMXLayerOpacityKey: @([self opacity]),
           TMXLayerTilesKey: [self tiles]};
}

@end
