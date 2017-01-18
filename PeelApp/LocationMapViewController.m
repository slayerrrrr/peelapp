//
//  LocationMapViewController.m
//  PeelApp
//
//  Created by Peelapp on 12-5-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LocationMapViewController.h"
#import "LocalizedCurrentLocation.h"

@interface LocationMapViewController()
-(void)initMap;
@end

@implementation LocationMapViewController
@synthesize mapView;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *navButton = [[UIBarButtonItem alloc] initWithTitle:@"查看路线" style:UIBarButtonItemStylePlain target:self action:@selector(navigationButtonPressed)];
    self.navigationItem.rightBarButtonItem = navButton;
    [navButton release];
    
    [self initMap];
}

- (void)dealloc
{
    [mapView release];
    [super dealloc];
}

-(void)navigationButtonPressed{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定要跳出程序查看地图？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    [alertView release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"]; 
        NSDictionary *resultDictionary = [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"LocationViewConfig"];
        
        NSString *sourceAddress = [LocalizedCurrentLocation currentLocationStringForCurrentLanguage];
        
        NSString *theString = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%@&daddr=%f,%f", [sourceAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [[resultDictionary objectForKey:@"lat"] floatValue], [[resultDictionary objectForKey:@"lng"] floatValue]];
        
        NSURL *url = [NSURL URLWithString:theString];
        [[UIApplication sharedApplication] openURL:url];
    }
}


#pragma mark -
#pragma mark Annotation Delegate
-(void)initMap{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"]; 
    NSDictionary *resultDictionary = [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"LocationViewConfig"];
    
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = [[resultDictionary objectForKey:@"lat"] floatValue];
    newRegion.center.longitude = [[resultDictionary objectForKey:@"lng"] floatValue];
    
    newRegion.span.latitudeDelta = 0.1;
    newRegion.span.longitudeDelta = 0.1;
    
    [self.mapView setRegion:newRegion animated:YES];
    self.mapView.showsUserLocation = YES;
    mapView.zoomEnabled = YES;
    mapView.scrollEnabled = YES;
    mapView.mapType = MKMapTypeStandard;
    
    NSMutableArray *annotationArray = [[NSMutableArray alloc] init];
    
    MKPointAnnotation *object = [[MKPointAnnotation alloc] init];
    [object setCoordinate:CLLocationCoordinate2DMake([[resultDictionary objectForKey:@"lat"] floatValue], [[resultDictionary objectForKey:@"lng"] floatValue])];
    
    [object setSubtitle:[resultDictionary objectForKey:@"address"]];
    
    [annotationArray addObject:object];
    [object release];
    
    [mapView addAnnotations:annotationArray];
    [annotationArray release];
}

- (void)mapView:(MKMapView *)amapView didSelectAnnotationView:(MKAnnotationView *)aview{
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
}

- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
    if(annotation == mapView.userLocation){
        return nil;
    }
    else{
        // try to dequeue an existing pin view first
        static NSString* identifier = @"AnnotationIdentifier";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (!pinView)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView* customPinView = [[[MKPinAnnotationView alloc]
                                                   initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
            
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton addTarget:self
                            action:nil
                  forControlEvents:UIControlEventTouchUpInside];
            customPinView.rightCalloutAccessoryView = rightButton;
            
            return customPinView;
        }
        
        return pinView;
    }
}
@end
