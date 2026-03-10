#include <stdio.h>

int main(){
	int num1=0,num2=0,ris=0;
	printf("Primo numero: ");
	scanf("%d",&num1);
	printf("Secondo numero: ");
        scanf("%d",&num2);
	num1=num1+num2;
	num2=num1-num2;
	num1=num1-num2;
	printf("rix per i valori invertiti %d %d",num1,num2);
}
