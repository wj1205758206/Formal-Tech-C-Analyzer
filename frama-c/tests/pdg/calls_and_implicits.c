/* run.config
 *    GCC:
 *    OPT: -val-show-progress -fct-pdg main -inout -journal-disable -pdg-print -pdg-verbose 2
 *
 */

#define SIZE 5
int t[SIZE];
int G, G2;

int f (void) { G += 2; return 1; }

int f2 (void) { G2 = G; return G+1; }

void swap (void) { int tmp = G; G = G2; G2 =  tmp; }


#ifdef __FRAMAC__
#  define print()
#else
int printf(const char * restrict format, ...);

void print (void) {
  int i;
  for (i = 0; i < SIZE; i++)
    printf ("t[%d] = %d\n", i, t[i]);
  printf ("G = %d ; G2 = %d\n\n", G, G2);
}
#endif


int main (void) {
  G = 0; G2 = 0;
  t[G] = f();
  t[G] = f();
  G = f2();
  print();
  swap();
  print();
  return 0;
}
