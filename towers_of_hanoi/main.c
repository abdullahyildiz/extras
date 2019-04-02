#include <stdio.h>

void move_tail(int count, int start, int finish, int temp){
    
    while(count > 0){
        
        move_tail(count-1, start, temp, finish);
        printf("Move a disk from %d to %d\n", start, finish);
        count--;
        int x = start;
        start = temp;
        temp = x;
        
    }
    
}

void move(int count, int start, int finish, int temp){
    
    if(count > 0){
        
        move(count-1, start, temp, finish);
        printf("Move a disk from %d to %d\n", start, finish);
        move(count-1, temp, finish, start);
        
    }
    
}

int main(){
    
    
    move_tail(3, 1, 3, 2);
    // move(3, 1, 3, 2);
    
    return 0;
}