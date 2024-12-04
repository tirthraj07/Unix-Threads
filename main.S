	.file	"main.cpp"
	.text
	.section	.rodata
	.type	_ZStL19piecewise_construct, @object
	.size	_ZStL19piecewise_construct, 1
_ZStL19piecewise_construct:
	.zero	1
	.local	_ZStL8__ioinit
	.comm	_ZStL8__ioinit,1,1
	.globl	x
	.bss
	.align 4
	.type	x, @object
	.size	x, 4
x:
	.zero	4
	.globl	ITERATIONS
	.data
	.align 4
	.type	ITERATIONS, @object
	.size	ITERATIONS, 4
ITERATIONS:
	.long	10000000
	.globl	mutex
	.bss
	.align 32
	.type	mutex, @object
	.size	mutex, 40
mutex:
	.zero	40
	.text
	.globl	_Z7routinePv
	.type	_Z7routinePv, @function
_Z7routinePv:							# Function "routine(void*)"	
	pushq	%rbp						# Save the previous base pointer on the stack
	movq	%rsp, %rbp					
	movq	%rdi, -24(%rbp)

	#	for (int i = 0; i < ITERATIONS; i++)
    #	{
    #	        x++;
    #	}


	#	int i=0;
	movl	$0, -4(%rbp)				# Initialize the local loop counter to 0 (stored at -4(%rbp))
.L3:									# Loop label
	# i < ITERATIONS
	movl	ITERATIONS(%rip), %eax		# Load the value of ITERATIONS (constant) into %eax
	cmpl	%eax, -4(%rbp)				# Compare the loop counter (-4(%rbp)) with ITERATIONS
	jge	.L2								# If the counter >= ITERATIONS, jump to the end of the loop

	#	x++; 
	movl	x(%rip), %eax				# Load the value of the global variable x into %eax
	# Now this is where race condition can occur
	# If the program is prempted at this point, can another process increments the value 
	# Now when the control comes back to this point, then the eax register has the old value of x 
	# So if the program runs the next line, it will increment the old value of x and thus instead of incrementing by 2 or more times (if multiple process access x at the same time), x will technically be incremented by only once
	# As the x(%rip) value will be overriden by the old value in eax register
	addl	$1, %eax					# Increment %eax by 1
	movl	%eax, x(%rip)				# Store the incremented value back into the global variable x

	#	i++
	addl	$1, -4(%rbp)				# Increment the local loop counter (-4(%rbp)) by 1
	jmp	.L3								# Jump back to the start of the loop

.L2:									# End of the loop
	movl	$0, %eax					# Set the return value to 0 (stored in %eax)
	popq	%rbp						# Restore the previous base pointer
	ret									# Return from the function

	.size	_Z7routinePv, .-_Z7routinePv
	.section	.rodata
.LC0:
	.string	"Could not create thread "
.LC1:
	.string	"Value of x = "
.LC2:
	.string	"Expected : "
.LC3:
	.string	"Missed % : "
	.text
	.globl	main
	.type	main, @function
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	movl	$0, %esi
	leaq	mutex(%rip), %rdi
	call	pthread_mutex_init@PLT
	movl	$0, -4(%rbp)
.L9:
	cmpl	$3, -4(%rbp)
	jg	.L6
	leaq	-48(%rbp), %rax
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	salq	$3, %rdx
	addq	%rdx, %rax
	movl	$0, %ecx
	leaq	_Z7routinePv(%rip), %rdx
	movl	$0, %esi
	movq	%rax, %rdi
	call	pthread_create@PLT
	testl	%eax, %eax
	setne	%al
	testb	%al, %al
	je	.L7
	leaq	.LC0(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc@PLT
	movq	%rax, %rdx
	movl	-4(%rbp), %eax
	addl	$1, %eax
	movl	%eax, %esi
	movq	%rdx, %rdi
	call	_ZNSolsEi@PLT
	movq	%rax, %rdx
	movq	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@GOTPCREL(%rip), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	_ZNSolsEPFRSoS_E@PLT
	movl	$1, %eax
	jmp	.L12
.L7:
	addl	$1, -4(%rbp)
	jmp	.L9
.L6:
	movl	$0, -8(%rbp)
.L11:
	cmpl	$3, -8(%rbp)
	jg	.L10
	movl	-8(%rbp), %eax
	cltq
	movq	-48(%rbp,%rax,8), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	pthread_join@PLT
	addl	$1, -8(%rbp)
	jmp	.L11
.L10:
	leaq	.LC1(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc@PLT
	movq	%rax, %rdx
	movl	x(%rip), %eax
	movl	%eax, %esi
	movq	%rdx, %rdi
	call	_ZNSolsEi@PLT
	movq	%rax, %rdx
	movq	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@GOTPCREL(%rip), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	_ZNSolsEPFRSoS_E@PLT
	leaq	.LC2(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc@PLT
	movq	%rax, %rdx
	movl	ITERATIONS(%rip), %eax
	sall	$2, %eax
	movl	%eax, %esi
	movq	%rdx, %rdi
	call	_ZNSolsEi@PLT
	movq	%rax, %rdx
	movq	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@GOTPCREL(%rip), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	_ZNSolsEPFRSoS_E@PLT
	leaq	.LC3(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc@PLT
	movq	%rax, %rcx
	movl	ITERATIONS(%rip), %eax
	leal	0(,%rax,4), %edx
	movl	x(%rip), %eax
	subl	%eax, %edx
	movl	%edx, %eax
	cvtsi2ss	%eax, %xmm0
	movl	ITERATIONS(%rip), %eax
	sall	$2, %eax
	cvtsi2ss	%eax, %xmm1
	divss	%xmm1, %xmm0
	movaps	%xmm0, %xmm1
	movss	.LC4(%rip), %xmm0
	mulss	%xmm1, %xmm0
	movq	%rcx, %rdi
	call	_ZNSolsEf@PLT
	movq	%rax, %rdx
	movq	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@GOTPCREL(%rip), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	_ZNSolsEPFRSoS_E@PLT
	leaq	mutex(%rip), %rdi
	call	pthread_mutex_destroy@PLT
	movl	$0, %eax
.L12:
	leave
	ret
	.size	main, .-main
	.type	_Z41__static_initialization_and_destruction_0ii, @function
_Z41__static_initialization_and_destruction_0ii:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movl	%esi, -8(%rbp)
	cmpl	$1, -4(%rbp)
	jne	.L15
	cmpl	$65535, -8(%rbp)
	jne	.L15
	leaq	_ZStL8__ioinit(%rip), %rdi
	call	_ZNSt8ios_base4InitC1Ev@PLT
	leaq	__dso_handle(%rip), %rdx
	leaq	_ZStL8__ioinit(%rip), %rsi
	movq	_ZNSt8ios_base4InitD1Ev@GOTPCREL(%rip), %rax
	movq	%rax, %rdi
	call	__cxa_atexit@PLT
.L15:
	nop
	leave
	ret
	.size	_Z41__static_initialization_and_destruction_0ii, .-_Z41__static_initialization_and_destruction_0ii
	.type	_GLOBAL__sub_I_x, @function
_GLOBAL__sub_I_x:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	$65535, %esi
	movl	$1, %edi
	call	_Z41__static_initialization_and_destruction_0ii
	popq	%rbp
	ret
	.size	_GLOBAL__sub_I_x, .-_GLOBAL__sub_I_x
	.section	.init_array,"aw"
	.align 8
	.quad	_GLOBAL__sub_I_x
	.section	.rodata
	.align 4
.LC4:
	.long	1120403456
	.hidden	__dso_handle
	.ident	"GCC: (Debian 8.3.0-6) 8.3.0"
	.section	.note.GNU-stack,"",@progbits
