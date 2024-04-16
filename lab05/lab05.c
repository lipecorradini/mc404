
#define getBit(w, i) ((w >> i) & 1) // int w e index i
#define MASK(j) (1<<j) // peja o j-ésimo bit, so fazer um and pra verificar se é 1

<<<<<<< HEAD
void pack(int input, int start_bit, int end_bit, int packed){
    // provavelmente, fazer o packed como um ponteiro seria mais fácil de converter depois

    // iterar pelos índices de comeco em fim no input
    // adicionar o valor à packed se for 1
    // retornar packed (fazer para todos os int)
=======
#define STDIN_FD  0
#define STDOUT_FD 1
>>>>>>> 99b0091d272f908d6f0a5fad8e7a1580492574b1


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

<<<<<<< HEAD
// int power(int num, int exp)
// {
//     if (exp == 0)
//         return 1;
//     int result = 1;
//     for (int i = 0; i < exp; i++)
//     {
//         result *= num;
//     }
//     return result;
// }
=======
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
>>>>>>> 99b0091d272f908d6f0a5fad8e7a1580492574b1

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

int concatenate(int *numbers){
    
    int final = 0;

    final |= (numbers[0] & 0b11111) << 0;
    final |= (numbers[1] & 0b1111111) << 5;
    final |= (numbers[2] & 0b111111111) << 12;
    final |= (numbers[3] & 0b1111) << 21;
    final |= (numbers[4] & 0b1111111) << 25;

    return final;

}

int dec_to_int(char *str)
{
    int result = 0;
    int exp = 1000;

    for (int i = 0; i < 4; i++)
    {
<<<<<<< HEAD
        result += (1 << (3 - i)) * (str[i] - '0');
    }
    return result;

}

void printBits(int num) {

    int numBits = sizeof(int) * 8;
    
    unsigned int mask = 1 << (numBits - 1);
    
    printf("Binary representation of %d: ", num);
    for (int i = 0; i < numBits; ++i) {
        // Check if the bit at position i is set
        if (num & mask) {
            printf("1");
        } else {
            printf("0");
        }
        // Shift the mask to the right by 1
        mask >>= 1;
    }
    printf("\n");
=======
        result += (str[i] - '0') * exp;
        exp /= 10;
    }
    return result;
>>>>>>> 99b0091d272f908d6f0a5fad8e7a1580492574b1
}

int set_int(char *str, int start_index){
    /*
    Essa função recebe uma string com 4 números de 4 bits sinalados,
    e retorna o valor de inteiro de um dos números designados, considerando que 
    C já considera números inteiros negativos como complemento de dois.
    */

    char buff[6];

    char signal = str[start_index];

    int cont = 0;
    for(int i = start_index + 1; i < start_index + 5; i++){
        buff[cont] = str[i];
        cont ++;
    }
    
    buff[5] = '\0';

    return (signal == '+') ? dec_to_int(buff) : dec_to_int(buff) * -1;

}

void hex_code(int val){
    char hex[11];
    unsigned int uval = (unsigned int) val, aux;

    hex[0] = '0';
    hex[1] = 'x';
    hex[10] = '\n';

    for (int i = 9; i > 1; i--){
        aux = uval % 16;
        if (aux >= 10)
            hex[i] = aux - 10 + 'A';
        else
            hex[i] = aux + '0';
        uval = uval / 16;
    }
    write(1, hex, 11);
    // printf("%s\n", hex);
}

int main(){
    
    char str[32];

    read(STDIN_FD, str, 32);
  

    int values[5];

    values[0] = set_int(str, 0);
    values[1] = set_int(str, 6);
    values[2] = set_int(str, 12);
    values[3] = set_int(str, 18);
    values[4] = set_int(str, 24);


    int final_bin = concatenate(values);


    hex_code(final_bin);
    
}

void _start()
{
  int ret_code = main();
  exit(ret_code);
}