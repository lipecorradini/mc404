#include <stdio.h>

#define getBit(w, i) ((w >> i) & 1) // int w e index i
#define MASK(j) (1<<j) // peja o j-ésimo bit, so fazer um and pra verificar se é 1

void pack(int input, int start_bit, int end_bit, int packed){
    
    // iterar pelos índices de comeco em fim no input
    // adicionar o valor à packed se for 1
    // retornar packed (fazer para todos os int)

}

int power(int num, int exp)
{
    if (exp == 0)
        return 1;
    int result = 1;
    for (int i = 0; i < exp; i++)
    {
        result *= num;
    }
    return result;
}

int bin_to_dec(char *str)
{
    int result = 0;
    for (int i = 0; i < 4; i++)
    {
        result += (int)(power(2, 3 - i) * (str[i] - '0'));
    }
    return result;

}

void printBits(int num) {
    // Number of bits in an int
    int numBits = sizeof(int) * 8;
    
    // Mask to check each bit
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
        printf("%c\n", str[i]);
        buff[cont] = str[i];
        cont ++;
    }
    
    buff[5] = '\0';

    return (signal == '+') ? bin_to_dec(buff) : bin_to_dec(buff) * -1;

}

int main(){
    
    char str[32];

    scanf("%[^\n]%*c", str); // Temporário, para ler a string inteira
    printf("string: %s\n", str);

    int first = set_int(str, 0);
    int second = set_int(str, 6);
    int third = set_int(str, 12);
    int fourth = set_int(str, 18);
    int fifth = set_int(str, 24);

    printf("First: \n");
    printBits(first);
    printf("Second: \n");
    printBits(second);



    // Ideia Geral:
    // Receber a entrada como strings 
    // Dividir como quatro inteiros sinalados
        // Se for negativo, transformá-lo para complemento de dois
     // Chamar a função pack para agrupá-los
        // Colocá-los em suas devidas posições, shiftando os bits
    // Transformar para Hexadecimal
    


    
}