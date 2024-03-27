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

int dec_to_int(char *str){
    int tam = size_string(str); // nao ta funcionando
    int result = 0, exp = pow(10, size_string(str) - 1) ; 
    for(int i = 0; i < tam; i++){
        result += (str[i] -'0') * exp;
        exp /= 10;
    }
    return result;
}

int pow(int num, int exp){
    if(exp == 1) return 0;
    for(int i = 1; i < exp; i++){
        num *= exp; 
    }
    return num;
}

int size_string(char *str)
{

    int i = 0;
    for (i = 0; str[i] != '\n'; i++);
    return i;
}

int bin_to_dec(char *str){

    int result = 0;
    for (int i = 2; i < size_string(str); ++i) {
        result <<= 1; // Left-shift the result by 1
        result += (str[i] - '0'); // Add the current bit
    }
    return result;

}

int size_base(int n, int base)
{
    int tam = 0, new = n;
    while (new != 0)
    {
        tam++;
        new /= base;
    }

    return tam;
}

void dec_to_base(int n, char *str, int base)
{
    int tam = size_base(n, base);

    // para números positivos
    int i = 0;

    while (n != 0)
    {
        int res = n % base;
        // printf("%d resto por %d = %d\n", n, base, res);
        str[tam - i + 1] = res + '0';
        n /= base;
        i++;
    }

    str[tam + 2] = '\n';
    str[0] = '0';

    switch (base)
    {
    case 2:
        str[1] = 'b';
        break;
    case 8:
        str[1] = 'o';
        break;
    case 16:
        str[1] = 'x';
        break;

    default:
        break;
    }

    return;
}

void pr_str(char *str)
{
    int tam = size_string(str);
    for (int i = 0; i < tam; i++)
    {
        printf("%c", str[i]);
    }
    printf("\n");
}

int atoi(char *arr)
{
    int result = 0;
    int size = size_string(arr);
    for (int i = 1; i < size; i++)
    {
        result = result * 10 + (arr[i] - '0');
    }
    return result;
}

int main()
{
    char str[20];
    scanf("%s", str);
    
    char bin[32];
    char hex[20];
    char oct[20];
    int dec;

    switch (str[0])
    {
    case '0': // garantido que será hexadecimal (pos ou neg)
    
        // por enquanto, tratando apenas os positivos
        dec = hx_to_dec(str);
        printf("decimal: %d\n", dec);

        dec_to_base(dec, bin, 2);
        pr_str(bin);

        dec_to_base(dec, hex, 16);
        pr_str(hex);

        dec_to_base(dec, oct, 8);
        pr_str(oct);
        break;     

    case '-': // garantido que será decimal negativo

        
    default:
        // tratar como decimal positivoint dec = hx_to_dec(str);
        dec = dec_to_int(str);
        printf("decimal: %d\n", dec);

        dec_to_base(dec, bin, 2);
        pr_str(bin);

        dec_to_base(dec, hex, 16);
        pr_str(hex);

        dec_to_base(dec, oct, 8);
        pr_str(oct);

        break;
    }
}