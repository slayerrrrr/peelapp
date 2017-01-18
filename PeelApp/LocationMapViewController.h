//
//  LocationMapViewController.h
//  PeelApp
//
//  Created by Peelapp on 12-5-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface LocationMapViewController : UIViewController<MKMapViewDelegate,UIAlertViewDelegate>{
    IBOutlet MKMapView *mapView;
}

@property (nonatomic,retain) IBOutlet MKMapView *mapView;
@end
