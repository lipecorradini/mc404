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
    for (i = 0; str[i] != '\0'; i++);
    return i;
}

int dec_to_int(char *str)
{
    int tam = size_string(str); // nao ta funcionando
    int result = 0;
    int exp = power(10, tam - 1);
    int mult = 1, first = 0;

    if (str[0] == '-')
    {
        mult = -1;
        first = 1;
        exp /= 10;
    }

    for (int i = first; i < tam; i++)
    {
        result += (str[i] - '0') * exp;
        exp /= 10;
    }
    return result * mult;
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
    for (int i = 2; i < size_string(str); ++i)
    {
        result <<= 1;             // Left-shift the result by 1
        result += (str[i] - '0'); // Add the current bit
    }
    return result;
}

int size_base(long long n, int base)
{
    int tam = 0, new = n;
    while (new != 0)
    {
        tam++;
        new /= base;
    }

    return tam;
}

void dec_to_base(long long n, char *str, int base)
{
    int tam = size_base(n, base);

    // para números positivos
    int i = 0;
    int save = n;

    while (n != 0)
    {
        int res = n % base;
        // printf("%d resto por %d = %d\n", n, base, res);
        str[tam - i + 1] = res + '0';
        n /= base;
        i++;
    }

    str[tam + 2] = '\0';
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

void bin_to_c2(char *binario, char *novo)
{
    int tamanho = size_string(binario) - 2;

    int i, carry = 1;

    // Começa a partir do bit menos significativo
    for (i = tamanho + 1; i >= 2; i--)
    {
        if (binario[i] == '1' && carry == 1)
        {
            novo[i] = '0';
        }
        else if (binario[i] == '0' && carry == 1)
        {
            novo[i] = '1';
            carry = 0;
        }
        else
        {
            novo[i] = binario[i];
        }
    }

    novo[0] = '0';
    novo[1] = 'b';
    novo[tamanho] = '\0';
}

void dec_to_c2(long long n, char *complemento)
{
    int carry = 1;
    n *= -1;
    int tam = size_base(n, 2);

    for (int i = 33; i >= 33 - tam; i--)
    {
        int bit = n % 2;
        complemento[i] = ((bit ^ 1) ^ carry) + '0';
        carry = ((bit ^ 1 ) & carry);
        n /= 2;
    }

    for(int i = 2; i < 33 - tam; i++){
        complemento[i] = '1';
    }
    complemento[0] = '0';
    complemento[1] = 'b';
    complemento[34] = '\0';
}

long long c2_to_dec(char *binario){
    
    long long resultado = 0;
    int sinal = 1; // assume-se que o número é positivo inicialmente

    // Verifica o sinal do número
    if (binario[2] == '1' && size_string(binario) == 34) {
        sinal = -1;
    }

    // Itera sobre os bits do array a partir do terceiro elemento
    for (int i = 2; binario[i] != '\0'; i++) {
        resultado = resultado * 2 + (binario[i] - '0'); // converte o bit para inteiro ('0' é 48 na tabela ASCII)
    }

    return resultado * sinal;
}

int endianess(char * bin, char * new){
    
    char *buff1[9];
    char *buff2[9];
    char *buff3[9];
    char *buff4[9];

    buff1[8] = '\0';
    buff2[8] = '\0';

    // colocando os devidos zeros antes
    int tam = size_string(bin) - 2;
    for(int i = 2; i < (34 - tam); i++){
        new[i] = '0';
    }

    for(int i = (34 - tam); i < 34; i++){
        new[i] = bin[i - 34 + tam + 2];
    }

    new[34] = '\0';
    new[0] = '0';
    new[1] = 'b';
    // pr_str(new);

    for(int i = 2; i < 34; i++){
        switch ((i - 2) / 8)
        {
        case 0:
            buff1[(i - 2) % 8] = new[i];
            break;
        
        case 1:
            buff2[(i - 2) % 8] = new[i];
            break;
        
        case 2:
            buff3[(i - 2) % 8] = new[i];
            break;
        
        case 3:
            buff4[(i - 2) % 8] = new[i];
            // printf("i: %d, i4: %d, new: %c\n", i, (i - 2) % 8, new[i]);
            break;
        }
    }

    for(int i = 2; i < 34; i++){
        switch ((i - 2) / 8)
        {
        case 0:
            new[i] = buff4[(i - 2) % 8];
            // printf("buff4-> ind %d: %c\n",(i - 2) % 8, buff4[(i - 2) % 8]);
            break;
        
        case 1:
            new[i] = buff3[(i - 2) % 8];
            break;
        
        case 2:
            new[i] = buff2[(i - 2) % 8];
            break;
        
        case 3:
            new[i] = buff1[(i - 2) % 8];
            break;
        }


    }
        // pr_str(new);

    return bin_to_dec(new);

}

int main()
{
    char str[20];
    scanf("%s", str);

    char bin[35];
    char hex[20];
    char oct[20];
    char bin_c2[35];
    char new_end[35];
    long long ans;

    long long dec;

    switch (str[0])
    {
    case '0': // garantido que será hexadecimal (pos ou neg)

        dec = hx_to_dec(str);
        // Valor em Binário
        dec_to_base(dec, bin, 2);
        pr_str(bin);

        // de C2 para decimal
        long long dec_c2 = c2_to_dec(bin);
        printf("%lli\n", dec_c2);

        // Trocando o Endianess
        ans = endianess(bin, new_end);
        printf("unsigned: %d\n", ans);

        dec_to_base(dec, hex, 16);
        pr_str(hex);

        dec_to_base(dec, oct, 8);
        pr_str(oct);
        break;

    case '-': // DECIMAL NEGATIVO

        int neg_dec = dec_to_int(str);

        // Transformar de decimal para complemento de dois
        dec_to_c2(neg_dec, bin);
        pr_str(bin);

        // Printar Decimal
        pr_str(str);

        // Trocar o Endianess e printar
        ans = endianess(bin, new_end);
        printf("unsigned: %d\n", ans);

        // usar o complemento para transformar para hexadecimal

        break;

    default: // DECIMAL POSITIVO

        // Só converter para binário
        dec = dec_to_int(str);
        dec_to_base(dec, bin, 2);
        pr_str(bin);

        // Só printar
        printf("decimal: %d\n", dec);

        // Converter para binário, trocar endianess depois para decimal unsigned
        
        int ans = endianess(bin, new_end);
        printf("unsigned: %d\n", ans);

        // Só transformar para hexadecimal normal
        dec_to_base(dec, hex, 16);
        pr_str(hex);

        // Só transformar para oct direto
        dec_to_base(dec, oct, 8);
        pr_str(oct);

        break;
    }
}