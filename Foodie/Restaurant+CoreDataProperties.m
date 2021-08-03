//
//  Restaurant+CoreDataProperties.m
//  
//
//  Created by Eva Xie on 8/3/21.
//
//

#import "Restaurant+CoreDataProperties.h"

@implementation Restaurant (CoreDataProperties)

+ (NSFetchRequest<Restaurant *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Restaurant"];
}

@dynamic name;

@end
