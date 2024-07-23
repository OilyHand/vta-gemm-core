#include <iostream>
#include <string>
#include <sstream>
#include <iomanip>
using namespace std;

#define UOP_MEM_WIDTH 2048

typedef struct {
    int acc_idx : 11;
    int inp_idx : 11;
    int wgt_idx : 10;
} uop_t;

int main(){

    // uop_t uop_mem[UOP_MEM_WIDTH];

    // for (int i; i < UOP_MEM_WIDTH; i++){
    //     uop_mem[i].acc_idx = i;
    //     uop_mem[i].inp_idx = i;
    //     uop_mem[i].wgt_idx = i;
    // }

    uop_t uop;
    stringstream ss;
    string str;
    int tmp = 0;


    uop.acc_idx = 7;
    uop.inp_idx = 5;
    uop.wgt_idx = 0;

    tmp = uop.acc_idx << 21;
    tmp += uop.inp_idx << 10;
    tmp += uop.wgt_idx;

  std::stringstream stream;
  stream << std::setfill ('0') << std::setw(sizeof(int)) 
         << std::hex << tmp;
    str = ss.str();
    cout << str << endl;

    // 00000000111000000001010000000000
    // 0   0   e(14)0   1   4    0   0


    return 0;
}