//
//  main.m
//  BCP-Mobile
//
//  Created by Bryce Pauken on 4/5/14.
//  Copyright (c) 2014 Kingfish. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BCPAppDelegate.h"

void exceptionHandler(NSException *exception) {
    [BCPData deleteData];
}

void sigHandler(int sig, siginfo_t *info, void *context) {
    [BCPData deleteData];
}

int main(int argc, char * argv[])
{
    @autoreleasepool {
        #ifdef DEBUG
        #else
        NSSetUncaughtExceptionHandler(&exceptionHandler);
        struct sigaction sigAction;
        sigAction.sa_sigaction = sigHandler;
        sigAction.sa_flags = SA_SIGINFO;
        sigemptyset(&sigAction.sa_mask);
        sigaction(SIGQUIT, &sigAction, NULL);
        sigaction(SIGILL, &sigAction, NULL);
        sigaction(SIGTRAP, &sigAction, NULL);
        sigaction(SIGABRT, &sigAction, NULL);
        sigaction(SIGEMT, &sigAction, NULL);
        sigaction(SIGFPE, &sigAction, NULL);
        sigaction(SIGBUS, &sigAction, NULL);
        sigaction(SIGSEGV, &sigAction, NULL);
        sigaction(SIGSYS, &sigAction, NULL);
        sigaction(SIGPIPE, &sigAction, NULL);
        sigaction(SIGALRM, &sigAction, NULL);
        sigaction(SIGXCPU, &sigAction, NULL);
        sigaction(SIGXFSZ, &sigAction, NULL);
        #endif
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([BCPAppDelegate class]));
    }
}
