
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

#define STDIN_FD  0
#define STDOUT_FD 1

int size_string(char *str)
{
    int i = 0;
    for (i = 0; str[i] != '\0'; i++);
    return i;
}

long long hx_to_dec(char *str)
{
    long long int_dec = 0;
    long long curr_exp = 1;
    int arr_size = size_string(str) - 2;
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

long long dec_to_int(char *str)
{
    int tam = size_string(str);
    long long result = 0;
    long long exp = power(10, tam - 1);
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

long long bin_to_dec(char *str)
{
    long long result = 0;
    for (int i = 2; i < size_string(str); ++i)
    {
        result <<= 1;            
        result += (str[i] - '0');
    }
    return result;
}

int size_base(long long n, int base)
{
    int tam = 0;
    long long new = n;
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
    long long save = n;

    while (n != 0)
    {
        int res = n % base;
        if(res > 9){
            res = 'a' + (res - 10);
            str[tam - i + 1] = res;
        }else{
            str[tam - i + 1] = res + '0';
        }
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
        resultado = resultado * 2 + (binario[i] - '0'); 
    }

    return resultado * sinal;
}

long long endianess(char * bin, char * new){
    
    char buff1[9], buff2[9], buff3[9], buff4[9];

    // buff1[8] = '\0';
    // buff2[8] = '\0';

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
            break;
        }
    }

    for(int i = 2; i < 34; i++){
        switch ((i - 2) / 8)
        {
        case 0:
            new[i] = buff4[(i - 2) % 8];
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
   return bin_to_dec(new);
}

char bin_to_hex(char *binary, int base) {
    int decimal = 0;

    // Converte o número binário para decimal
    for (int i = 0; i < base; i++) {
        decimal = decimal * 2 + (binary[i] - '0');
    }

    char resultDigit;
    
    if (base == 3) {
        // Convert decimal to octal
        resultDigit = '0' + (decimal % 8);
    }else{
    if (decimal < 10)
        resultDigit = '0' + decimal;
    else
        resultDigit = 'a' + (decimal - 10);
    }

    return resultDigit;
}

void c2_to_base(char *str, int base, char *ans){

    int g_size = 3;

    if(base == 16){
        g_size = 4;
    }

    char group[g_size + 1];
    group[g_size] = '\0';

    for(int i = 2; i < size_string(str) + 1; i++){

        if((i-2) % g_size == 0 && i != 2){
            char c = bin_to_hex(group, g_size);
            ans[(i - 2) / g_size + 1] = c;
        }
        group[(i - 2) % g_size] = str[i];     
    }
    ans[0] = '0';
    if(base == 8){
        ans[1] = 'o';
        ans[9] = '\0';
    }else{
        ans[1] = 'x';
        ans[17] = '\0';
    }
    
}

void int_to_str(long long n, char *str){

    int tam = size_base(n, 10);
    int start = 0;
    int isneg = 0;
    if (n < 0){
        start = 1;
        str[0] = '-';
        n *= -1;
        isneg = 1;
        
    } 
    for(int i = tam - 1; i >= 0; i--){
        if(isneg == 0)  str[i] = ((n % 10) + '0');
        else str[i + 1] = ((n % 10) + '0');
        n /= 10; 
    }
    str[tam + 1] = '\0';
}

int main()
{
    char str[20];
    int n = read(STDIN_FD, str, 20);

    char bin[35], hex[20], oct[20], dec_str[30], end[35], new_end[35];
    long long ans, dec;

    switch (str[0])
    {
    case '0': // garantido que será hexadecimal (pos ou neg)

        dec = hx_to_dec(str);

        // Valor em Binário
        dec_to_base(dec, bin, 2);
        write(STDOUT_FD, bin, size_string(bin));
        
        // de C2 para decimal
        long long dec_c2 = c2_to_dec(bin);
        int_to_str(dec_c2, dec_str);
        write(STDOUT_FD, dec_str, size_string(dec_str));

        // Trocando o Endianess
        ans = endianess(bin, new_end);
        int_to_str(ans, end);
        write(STDOUT_FD, end, size_string(end));

        dec_to_base(dec, hex, 16);
        write(STDOUT_FD, hex, size_string(hex));

        write(STDOUT_FD, oct, size_string(oct));
        break;

    case '-': // DECIMAL NEGATIVO

        dec = dec_to_int(str);

        // Transformar de decimal para complemento de dois
        dec_to_c2(dec, bin);
        write(STDOUT_FD, bin, size_string(bin));

        // Printar Decimal
        write(STDOUT_FD, str, size_string(str));

        // Trocar o Endianess e printar
        ans = endianess(bin, new_end);
        int_to_str(ans, end);
        write(STDOUT_FD, end, size_string(end));

        // Inteiro para Hexadecimal
        long long hex_value = bin_to_dec(bin);
        dec_to_base(hex_value, hex, 16);
        write(STDOUT_FD, hex, size_string(hex));

        // Inteiro para octal
        long long oct_value = bin_to_dec(bin);
        dec_to_base(oct_value, oct, 8);
        write(STDOUT_FD, oct, size_string(oct));
        
        break;

    default: // DECIMAL POSITIVO

        // Só converter para binário
        dec = dec_to_int(str);
        dec_to_base(dec, bin, 2);
        write(STDOUT_FD, bin, size_string(bin));

        // Só printar
        write(STDOUT_FD, str, size_string(str));

        // Converter para binário, trocar endianess depois para decimal unsigned
        ans = endianess(bin, new_end);
        int_to_str(ans, end);
        write(STDOUT_FD, end, size_string(end));

        // Só transformar para hexadecimal normal
        dec_to_base(dec, hex, 16);
        write(STDOUT_FD, hex, size_string(hex));

        // Só transformar para oct direto
        dec_to_base(dec, oct, 8);
        write(STDOUT_FD, oct, size_string(oct));
        break;
    }
}

void _start()
{
  int ret_code = main();
  exit(ret_code);
}