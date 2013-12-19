#import "MCMTMXParser.h"

#import "MCMMap.h"
#import "MCMTileset.h"
#import "MCMLayer.h"

@interface MCMTMXParser ()
@property NSXMLParser *parser;
@property MCMMap *map;
@property MCMTileset *currentTileset;
@property MCMLayer *currentLayer;
@property (setter = setURL:)NSURL *url;
@end


@implementation MCMTMXParser
#pragma mark - INIT/SETUP
-(id)initWithURL:(NSURL *)aURL{
  if((self = [super init])){
    [self setURL:aURL];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:aURL];
    [parser setDelegate:self];
    [self setParser:parser];
  }
  return self;
}


-(void)dealloc{
  [[self parser] setDelegate:nil];
}


#pragma mark - ACTIONS
-(MCMMap *)parse{
  MCMMap *parsedMap = nil;
  BOOL success = [[self parser] parse];
  if(success){
    parsedMap = [self map];
  }
  return parsedMap;
}


#pragma mark - PARSER DELEGATE METHODS
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)att{
  if([@"map" isEqualToString:elementName]){
    [self setMap:[MCMMap mapWithAttributes:att]];

  } else if([@"tileset" isEqualToString:elementName]){
    NSAssert(nil == [self currentTileset], @"Nested tilesets encountered.");
    NSAssert(nil == [self currentLayer], @"Tileset encountered in layer context.");
    [self setCurrentTileset:[MCMTileset tilesetWithAttributes:att]];

  } else if([@"image" isEqualToString:elementName]){
    NSAssert([self currentTileset], @"Image encountered outside of tileset context.");
    NSAssert(nil == [self currentLayer], @"Image encountered in layer context.");
    NSURL *path = [[self url] URLByDeletingLastPathComponent];
    NSURL *relativeURL = [path URLByAppendingPathComponent:att[@"source"]];
    NSURL *imageURL = [relativeURL URLByStandardizingPath];
    NSImage *image = [[NSImage alloc] initWithContentsOfURL:imageURL];
    [[self currentTileset] setImage:image];
    
  } else if([@"layer" isEqualToString:elementName]){
    NSAssert(nil == [self currentTileset], @"Layer encountered in tileset context.");
    NSAssert(nil == [self currentLayer], @"Nested layers encountered.");
    [self setCurrentLayer:[MCMLayer layerWithAttributes:att]];

  } else if([@"tile" isEqualToString:elementName]){
    //There are two different <tile> elements, those in <tileset> and those in <layer>. We don't care about the <tileset> ones.
    if([self currentLayer]){
      [[self currentLayer] addTile:[att[@"gid"] integerValue]];
    }
  }
}


-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
  if([@"tileset" isEqualToString:elementName]){
    NSAssert([self currentTileset], @"Tileset closed prematurly.");
    [[self map] addTileset:[self currentTileset]];
    [self setCurrentTileset:nil];
  } else if([@"layer" isEqualToString:elementName]){
    NSAssert([self currentLayer], @"Layer closed prematurly.");
    [[self map] addLayer:[self currentLayer]];
    [self setCurrentLayer:nil];
  }
}


@end
