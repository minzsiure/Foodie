//
//  Restaurant+CoreDataProperties.h
//  
//
//  Created by Eva Xie on 8/3/21.
//
//

#import ".Restaurant+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Restaurant (CoreDataProperties)

+ (NSFetchRequest<Restaurant *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
