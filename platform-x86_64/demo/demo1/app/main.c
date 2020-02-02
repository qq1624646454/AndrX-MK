/*
 * Copyright(c) 2016-2100.  root.  All rights reserved.
 */
/*
 * FileName:      main.c
 * Author:        root
 * Email:         493164984@qq.com
 * DateTime:      2020-02-03 00:05:54
 * ModifiedTime:  2020-02-03 00:05:54
 */


#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

void static_library_my(const char *info);
void shared_library_my(const char *info);

int main(int argc, char *argv[])
{
    static_library_my("app call");
    shared_library_my("app call");

    return 0;
}

