#include <stdio.h>

void test();
void A_test();
void A_AA_test();
void B_test();
void C_test();

int API_main(int argc, char **argv)
{
    printf("%s %s %d\r\n", __FILE__, __FUNCTION__, __LINE__);

    test();
    A_test();
    A_AA_test();
    B_test();
    C_test();
    printf("OVER: %s %s %d\r\n", __FILE__, __FUNCTION__, __LINE__);

    return 0;
}

