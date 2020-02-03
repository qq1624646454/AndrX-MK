/*
 * Copyright(c) 2016-2100.  root.  All rights reserved.
 */
/*
 * FileName:      my.c
 * Author:        root
 * Email:         493164984@qq.com
 * DateTime:      2020-02-02 23:47:55
 * ModifiedTime:  2020-02-02 23:51:51
 */


#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

void shared_library_my(const char *pcsInfo)
{
    printf("[%s:%d@%s] %s\r\n", __FUNCTION__, __LINE__, __FILE__, pcsInfo ? pcsInfo : "");
}

