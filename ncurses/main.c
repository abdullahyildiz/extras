#include <ncurses.h>

int main(){

  initscr();
  raw();
  start_color();
  init_pair(1, COLOR_RED, COLOR_BLUE);
  // attron(A_STANDOUT | A_UNDERLINE);
  attron(COLOR_PAIR(1));
  
  printw("Hello World!");
  attroff(COLOR_PAIR(1));
  // addch('a');
  mvprintw(15,20,"abdullah");
  getch();
  endwin();

  return 0;

}
