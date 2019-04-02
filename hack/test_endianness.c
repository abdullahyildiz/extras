#include <stdio.h>

int main(){
  
  int i = 1;
  
  if(*(char *)&i == 1){
    printf("little endian\n");
  }
  else{
    printf("big endian\n");
  }
  
  return 0;
}
