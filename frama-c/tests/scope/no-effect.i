/* run.config
   OPT: -val-show-progress -val -print -journal-disable -scope-verbose 1 -remove-redundant-alarms
*/

typedef struct {
  int v;
} tt;

void main (const tt *p1) {
  while(1) {
  switch ((p1+1)->v) {
  case 1:
  case 2:
  case 3:
  case 4:
    (p1+1)->v;
    break;
  }
  }
}
