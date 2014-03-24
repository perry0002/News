//
//  Alerts.m
//  news
//
//  Created by Perry Xiong on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Alerts.h"

void showErrorDlg(NSError *error){
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                        message:[NSString stringWithFormat:@"%@", error]
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];

    [alertView show];
    [alertView release];
}

void showErrorDlg1(NSString *title,NSString *errorString){
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title 
                                                        message:errorString
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
	
    [alertView show];
    [alertView release];
}


void showStatusDlg(ASIHTTPRequest *request){
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                        message:[request responseStatusMessage]
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}
