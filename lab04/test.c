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

int size_string(char *str)
{

    int i = 0;
    for (i = 0; str[i] != '\n'; i++)
        ;
    return i;
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

void neg_dec_to_bin(int n, char *str)
{

    char *bin[33];
    printf("aa\n");
    dec_to_base(n, bin, 2);

    printf("aa\n");
    int tamanho = size_string(bin);
    int i, carry = 1;

    str[tamanho - 1] = '\0';

    for (i = tamanho - 1; i >= 2; i--)
    {
        if (bin[i] == '1' && carry == 1)
        {
            str[i] = '0';
        }
        else if (bin[i] == '0' && carry == 1)
        {
            str[i] = '1';
            carry = 0;
        }
        else
        {
            str[i] = bin[i];
        }
    }
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

    // printf("pen: %c\n", str[tam+1]);
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

    switch (str[0])
    {
    case '0':
        // tratar como hexadecimal
        int dec = hx_to_dec(str);
        printf("decimal: %d\n", dec);

        char bin[32];
        dec_to_base(dec, bin, 2);
        pr_str(bin);

        char hex[20];
        dec_to_base(dec, hex, 16);
        pr_str(hex);

        char oct[20];
        dec_to_base(dec, oct, 8);
        pr_str(oct);

        break;

    case '-':
        char neg_bin[33];
        int neg_dec = atoi(str);
        printf("%d\n", neg_dec);
        printf("%d\n", neg_dec);
        neg_dec_to_bin(neg_dec, neg_bin);
        pr_str(neg_bin);

    default:
        // tratar como decimal

        break;
    }
}