#import "MCMTMXParser.h"

#import "MCMMap.h"


@interface MCMTMXParser ()
@property NSXMLParser *parser;
@property MCMMap *map;
@end


@implementation MCMTMXParser
#pragma mark - INIT/SETUP
-(id)initWithParser:(NSXMLParser *)aParser{
  if((self = [super init])){
    [aParser setDelegate:self];
    [self setParser:aParser];
  }
  return self;
}


-(id)initWithURL:(NSURL *)aURL{
  NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:aURL];
  return [self initWithParser:parser];
}


-(id)initWithData:(NSData *)someData{
  NSXMLParser *parser = [[NSXMLParser alloc] initWithData:someData];
  return [self initWithParser:parser];
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
    [self setMap:[self createMapWithAttributes:att]];
  } else if ([@"thing" isEqualToString:elementName]){
    
  }
}


#pragma mark - HELPERS
-(MCMMap *)createMapWithAttributes:(NSDictionary *)att{
  NSParameterAssert(att[@"orientation"]);
  NSParameterAssert([att[@"orientation"] isEqualToString:@"orthogonal"]);
  
  MCMMap *map = [MCMMap new];
  [map setVersion:att[@"version"]];
  [map setHeight:[att[@"height"] integerValue]];
  [map setWidth:[att[@"width"] integerValue]];
  [map setTileHeight:[att[@"tileheight"] floatValue]];
  [map setTileWidth:[att[@"tilewidth"] floatValue]];
  [map setOrientation:att[@"orientation"]];
  return map;
}

@end
