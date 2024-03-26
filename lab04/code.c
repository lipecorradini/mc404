
int read(int __fd, const void *__buf, int __n){
    int ret_val;
  __asm__ __volatile__(
    "mv a0, %1           # file descriptor\n"
    "mv a1, %2           # buffer \n"
    "mv a2, %3           # size \n"
    "li a7, 63           # syscall write code (63) \n"
    "ecall               # invoke syscall \n"
    "mv %0, a0           # move return value to ret_val\n"
    : "=r"(ret_val)  // Output list
    : "r"(__fd), "r"(__buf), "r"(__n)    // Input list
    : "a0", "a1", "a2", "a7"
  );
  return ret_val;
}

void write(int __fd, const void *__buf, int __n)
{
  __asm__ __volatile__(
    "mv a0, %0           # file descriptor\n"
    "mv a1, %1           # buffer \n"
    "mv a2, %2           # size \n"
    "li a7, 64           # syscall write (64) \n"
    "ecall"
    :   // Output list
    :"r"(__fd), "r"(__buf), "r"(__n)    // Input list
    : "a0", "a1", "a2", "a7"
  );
}

void exit(int code)
{
  __asm__ __volatile__(
    "mv a0, %0           # return code\n"
    "li a7, 93           # syscall exit (64) \n"
    "ecall"
    :   // Output list
    :"r"(code)    // Input list
    : "a0", "a7"
  );
}

void _start()
{
  int ret_code = main();
  exit(ret_code);
}

#define STDIN_FD  0
#define STDOUT_FD 1

int hx_to_dec(char *str){

    // 1 passo: transformar todos os digitos para inteiro e colocar em um array
    // int dec[20];

    int int_dec = 0;
    int curr_exp = 1;
    int arr_size = (sizeof(str) - 2 * sizeof(char))/(sizeof(char));

    for (int i = 1; i < arr_size; i++){
        curr_exp *= 16;
    }
    
    for(int i = 2; i < arr_size; i++){

        // verifica se é entre 0 e 9
        if(str[i] <= '9' && str[i] >= '0') int_dec += (str[i] - '0') *  curr_exp;
        
        else{
            // acha o valor se for letra
            char f_char = 'a';
            int f_num = 10;
            while(str[i] != f_char) {
                f_char ++;
                f_num ++;
            }
            int_dec = (f_num) * pow(16, arr_size - i + 1);
        }
        curr_exp /= 16;
    }
    return int_dec;

}

int main()
{
  char str[20];
  /* Read up to 20 bytes from the standard input into the str buffer */
  int n = read(STDIN_FD, str, 20);

    switch (str[0])
    {
    case '0':
        // tratar como hexadecimal
        int test = hx_to_dec(str);
        break;
    
    default:
        // tratar como decimal
        
        break;
    }

  /* Write n bytes from the str buffer to the standard output */
  write(STDOUT_FD, str, n);
  return 0;
}