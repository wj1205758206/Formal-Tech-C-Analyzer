/* run.config
STDOPT: +"-machdep gcc_x86_32"
*/

extern __attribute__((const, noreturn))
int ____ilog2_NaN(void);

static inline __attribute__((no_instrument_function)) __attribute__((const))
int __ilog2_u32(int n);

static inline __attribute__((no_instrument_function)) __attribute__((const))
  int __ilog2_u64(long n);

char ___assert_task_state[1 - 2*!!(
  sizeof("RSDTtZXxKWP")-1 != ( __builtin_constant_p(1024) ? ( (1024) < 1 ? ____ilog2_NaN() : (1024) & (1ULL << 63) ? 63 : (1024) & (1ULL << 62) ? 62 : (1024) & (1ULL << 61) ? 61 : (1024) & (1ULL << 60) ? 60 : (1024) & (1ULL << 59) ? 59 : (1024) & (1ULL << 58) ? 58 : (1024) & (1ULL << 57) ? 57 : (1024) & (1ULL << 56) ? 56 : (1024) & (1ULL << 55) ? 55 : (1024) & (1ULL << 54) ? 54 : (1024) & (1ULL << 53) ? 53 : (1024) & (1ULL << 52) ? 52 : (1024) & (1ULL << 51) ? 51 : (1024) & (1ULL << 50) ? 50 : (1024) & (1ULL << 49) ? 49 : (1024) & (1ULL << 48) ? 48 : (1024) & (1ULL << 47) ? 47 : (1024) & (1ULL << 46) ? 46 : (1024) & (1ULL << 45) ? 45 : (1024) & (1ULL << 44) ? 44 : (1024) & (1ULL << 43) ? 43 : (1024) & (1ULL << 42) ? 42 : (1024) & (1ULL << 41) ? 41 : (1024) & (1ULL << 40) ? 40 : (1024) & (1ULL << 39) ? 39 : (1024) & (1ULL << 38) ? 38 : (1024) & (1ULL << 37) ? 37 : (1024) & (1ULL << 36) ? 36 : (1024) & (1ULL << 35) ? 35 : (1024) & (1ULL << 34) ? 34 : (1024) & (1ULL << 33) ? 33 : (1024) & (1ULL << 32) ? 32 : (1024) & (1ULL << 31) ? 31 : (1024) & (1ULL << 30) ? 30 : (1024) & (1ULL << 29) ? 29 : (1024) & (1ULL << 28) ? 28 : (1024) & (1ULL << 27) ? 27 : (1024) & (1ULL << 26) ? 26 : (1024) & (1ULL << 25) ? 25 : (1024) & (1ULL << 24) ? 24 : (1024) & (1ULL << 23) ? 23 : (1024) & (1ULL << 22) ? 22 : (1024) & (1ULL << 21) ? 21 : (1024) & (1ULL << 20) ? 20 : (1024) & (1ULL << 19) ? 19 : (1024) & (1ULL << 18) ? 18 : (1024) & (1ULL << 17) ? 17 : (1024) & (1ULL << 16) ? 16 : (1024) & (1ULL << 15) ? 15 : (1024) & (1ULL << 14) ? 14 : (1024) & (1ULL << 13) ? 13 : (1024) & (1ULL << 12) ? 12 : (1024) & (1ULL << 11) ? 11 : (1024) & (1ULL << 10) ? 10 : (1024) & (1ULL << 9) ? 9 : (1024) & (1ULL << 8) ? 8 : (1024) & (1ULL << 7) ? 7 : (1024) & (1ULL << 6) ? 6 : (1024) & (1ULL << 5) ? 5 : (1024) & (1ULL << 4) ? 4 : (1024) & (1ULL << 3) ? 3 : (1024) & (1ULL << 2) ? 2 : (1024) & (1ULL << 1) ? 1 : (1024) & (1ULL << 0) ? 0 : ____ilog2_NaN() ) : (sizeof(1024) <= 4) ? __ilog2_u32(1024) : __ilog2_u64(1024) )+1)];
int X;
void main(int z) {
  switch(sizeof(z)) {
  case 1: X++; break;
  case 2: ___assert_task_state[0]=1;break;
  case -1: ++X;break;
  }
   
  
}

int T[__builtin_types_compatible_p(int,int)+__builtin_types_compatible_p(int,float)];
