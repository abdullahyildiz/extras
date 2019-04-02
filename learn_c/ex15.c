#include <stdio.h>

int main(int argc, char *argv[]){

  int ages[] = {25, 54, 12, 89, 2};
  char *names[] = {"alan", "frank", "mary", "john", "lisa"};

  int count = sizeof(ages) / sizeof(int);
  
  int i = 0;

  int *cur_age = ages;
  char **cur_name = names;

  for(i = 0; i < count; i++){
    printf("%s is %d years old.\n", *(cur_name + i), *(cur_age + i));
  }
  
  return 0;

}
