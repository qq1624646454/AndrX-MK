*************************************************************************************
*    README
*                                by Jielong Lin.  @2020-01-18. All rights reserved.
*
* Rev-1.0: initialized.
*************************************************************************************

This project is Makefile template in order to reduce the configuration complexity.

It uses the Android.mk similarred Makefile for each code module to perform compiled configuration. 
But this Makefile name is AndrX.mk rather than Android.mk.

   ├── demo
   │   ├── AndrX.mk
   │   └── func1
   │       ├── AndrX.mk
   │       └── subfunc1
   │           ├── A
   │           │   ├── AA
   │           │   │   └── test.c
   │           │   └── test.c
   │           ├── AndrX.mk
   │           ├── B
   │           │   └── test.c
   │           ├── C
   │           │   └── test.c
   │           ├── main.c
   │           └── test.c



