/* run.config
EXECNOW: make -s @PTEST_DIR@/@PTEST_NAME@.cmxs
OPT: -load-module @PTEST_DIR@/@PTEST_NAME@ -machdep x86_64 -enums int -no-unicode
*/

int main () { return 0; }
