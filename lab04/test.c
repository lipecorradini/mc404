#include <stdio.h>

int hx_to_dec(char *str)
{

    // 1 passo: transformar todos os digitos para inteiro e colocar em um array

    int int_dec = 0;
    int curr_exp = 1;
    int arr_size = (sizeof(str) - 2 * sizeof(char)) / (sizeof(char));


    for (int i = 1; i < arr_size; i++) 
        curr_exp *= 16;

    for (int i = 2; i < arr_size + 2; i++)
    {
        // verifica se é entre 0 e 9
        if (str[i] <= '9' && str[i] >= '0')
            int_dec += (str[i] - '0') * curr_exp;

        else
        {
            // acha o valor se for letra
            char f_char = 'a';
            int f_num = 10;
            while (str[i] != f_char)
            {
                f_char++;
                f_num++;
            }
            int_dec = (f_num)*curr_exp;
        }
        curr_exp /= 16;
    }
    return int_dec;
}

void dec_to_bin(int n, char *bin){
    
    int tam = 0;
    int new = n;
    while(new/2 != 0){
        tam ++;
        new /= 2;
    }

    // para números positivos
    printf("tamanho  %d\n", tam);
    int i = 0;

    while(n/2 != 0){
        int res = n % 2;
        bin[tam - i + 2] = res + '0';
        printf("index: %d\n", tam - i + 1);
        n /= 2;
        i++;
    }

    bin[tam] = '\n';

    bin[0] = '0';
    bin[1] = 'b';
    return ;

}
int main()
{
    char str[20];
    scanf("%s", str);

    switch (str[0])
    {
    case '0':
        // tratar como hexadecimal
        int dec = hx_to_dec(str);
        printf("decimal: %d\n", dec);

        char bin[32];
        dec_to_bin(dec, bin);
        printf("%s\n", bin);
        break;

    default:
        // tratar como decimal

        break;
    }
}