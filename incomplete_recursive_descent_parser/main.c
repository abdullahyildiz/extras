#include <stdio.h>

int parseSum();
int parseProduct();
int parseFactor();

char * x;

int parseProduct(){
    
    int fac1 = parseFactor();
    
    while(*x == '*'){
        
        ++x;
        int fac2 = parseFactor();
        fac1 = fac1 * fac2;
    }
    
    return fac1;
    
}

int parseFactor(){
    
    if(*x >= '0' && *x <= '9'){
        return *x++ - '0';
    }
    else if(*x == '('){
        ++x; // consume ()
        int sum = parseSum();
        ++x; // consume )
        return sum;
        
    }
    else{
        printf("expected digit but found %c\n", *x);
    }
    
}

int parseSum(){
    
    int pro1 = parseProduct();
    
    while(*x == '+'){
        
        ++x;
        int pro2 = parseProduct();
        pro1 = pro1 + pro2;
        
    }
    return pro1;
    
}

int main(){
    
    
    x = "2*(3+4)";
    int result = parseSum();
    printf("%d", result);
    
    return 0;
}