/* run.config 
   OPT: -rte -warn-signed-overflow -rte-mem -print
*/
struct ArrayStruct {
  int data[10];
} buff;

int main (int i) {
  return buff.data[i] ;
}
