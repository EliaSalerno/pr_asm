#include <stdio.h>

void main(){
	int i;
	// Le stringhe da ordinare
	char *strings[]={"retert","gegergr","gegegg","rerter","erwreter","reeerer"};
	
	// Il numero di stringhe nell'array
	int num=sizeof(strings)/sizeof(strings[0]);

	__asm({
		ciclo2:	mov ECX, num
			xor EBX,EBX
	 	 ciclo:	cmp ECX,1
			jge fine
			mov ESI, strings[ECX*4-4]
			mov EDI, strings[ECX*4-8]
			mov AL, [ESI]
			mov AH, [EDI]
			xor EDX, EDX
	lettereinterne:	cmp AL, AH
			jg scambio
			jne next
			cmp AL,0
			je next
			mov AL, [ESI+EDX]
			mov AH, [EDI+EDX]
			jmp lettereinterne
		  next:	loop ciclo
	       scambio:	inc BL
			mov strings[ECX*4-4], EDI
			mov strings[ECX*4-8], ESI
			loop ciclo
		  fine:	cmp BL, 0
			jne ciclo2
	})
	// stampa su video
	for(i=0;i<num;i++)
		printf("%s\n",strings[i]);
	system("pause");
	return;
	}
}
