#import "MCMDocument.h"

#import "MCMWindowController.h"
#import "MCMTMXParser.h"
#import "MCMMap.h"


@interface MCMDocument ()
@property MCMMap *map;
@end


@implementation MCMDocument
#pragma mark - INIT/SETUP
-(id)init{
  if((self = [super init])){
    //
  }
  return self;
}


#pragma mark - ACTIONS
-(IBAction)exportDocument:(id)sender{
  NSURL *url = [NSURL fileURLWithPath:@"/tmp/foo.plist"];
  
  if( ! [self filesExistAtURL:url]){
    [self writeFilesToURL:url];
  }
}


#pragma mark - DOCUMENT METHODS
+(BOOL)autosavesInPlace{
  return NO;
}


-(BOOL)readFromURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError{
  BOOL success = YES;
  
  MCMTMXParser *parser = [[MCMTMXParser alloc] initWithURL:url];
  [self setMap:[parser parse]];
  
  if( ! [self map]){
    success = NO;
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : NSLocalizedString(@"Could not parse TMX file.", nil), NSLocalizedFailureReasonErrorKey : NSLocalizedString(@"Unknown error occured.", nil), NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString(@"Try exporting the TMX again with approved settings.", nil)};
    *outError = [NSError errorWithDomain:@"TMX2AtlasDomain" code:-100 userInfo:userInfo];
  }
  return success;
}


-(void)makeWindowControllers{
  NSWindowController *controller = [[MCMWindowController alloc] initWithMap:[self map]];
  [self addWindowController:controller];
}


#pragma mark - UTILITY
-(BOOL)filesExistAtURL:(NSURL *)aURL{
  BOOL exists = NO;
  NSFileManager *fm = [NSFileManager defaultManager];
  if([fm fileExistsAtPath:[aURL path]]){
    exists = YES;
  }
  if([fm fileExistsAtPath:[[[aURL URLByDeletingPathExtension] URLByAppendingPathExtension:@"atlas"] path]]){
    exists = YES;
  }
  return exists;
}


-(BOOL)writeFilesToURL:(NSURL *)aURL{
  NSDictionary *map = [[self map] serialize];
  [map writeToFile:[aURL path] atomically:NO];

  NSError *error;
  NSURL *directoryURL = [[aURL URLByDeletingPathExtension] URLByAppendingPathExtension:@"atlas"];
  [[NSFileManager defaultManager] createDirectoryAtURL:directoryURL withIntermediateDirectories:NO attributes:nil error:&error];
  
  NSDictionary *images = [[self map] tileImages];
  [images enumerateKeysAndObjectsUsingBlock:^(NSString *name, NSImage *image, BOOL *stop) {
    NSURL *imageURL = [directoryURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", name]];
    CGImageRef imageRef = [image CGImageForProposedRect:NULL context:nil hints:nil];
    NSBitmapImageRep *bitmap = [[NSBitmapImageRep alloc] initWithCGImage:imageRef];
    NSData *data = [bitmap representationUsingType:NSPNGFileType properties:nil];
    [data writeToURL:imageURL atomically:NO];
  }];
  return YES;
}

@end
