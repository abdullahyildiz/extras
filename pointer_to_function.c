#include <stdio.h>

void test(int, int *);

int main(){
    
    int a;
    test(5, &a);
    
    printf("a is %d\n", a);
    
    return 0;
}

void test(int i, int * j){
    
    
    *j = ++i;
    
}