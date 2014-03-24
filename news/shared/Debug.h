/*
 *  Debug.h
 *  MapForLinkwith
 *
 *  Created by xiongpeili on 11/1/10.
 *  Copyright 2010 Xiong Peili-PSET. All rights reserved.
 *
 */

// Debug
#ifdef	DEBUG
#define	LOG(...)		NSLog(__VA_ARGS__);
#define	LOG_METHOD		NSLog(@"%s", __func__);

#else
#define	LOG(...)		;
#define	LOG_METHOD		;
#endif
