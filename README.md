## Why race condition occurs

If we look into the assembly code without mutex lock, we can see that
when we simply do `x++`, it actually performs 3 lines of code

1. loads the value of x from its location in eax register
2. increments the eax register
3. stores the eax value at location of x

So if the process gets preempted after 2, and other process increments the value of x, then when the control goes back
to the initial process, the value at location of x will get overriden by old incremented value

Eg.

```
initially x = 0

Process 1:
Step 1: eax = 0
-- Gets Preempted

Process 2:
Step 1: eax = 0
Step 2: INCR eax ==> eax = 1
Step 3: mov eax->x ==> x = 1
-- ENDS Process 2

-- Control back to process 1
Process 1:
Step 2: INCR eax ==> eax = 1
Step 3: mov eax->x ==> x = 1
-- ENDS Process 1
```

So instead of incrementing twice, it gets incremented only once. This is RACE CONDITION

Lets take a look at the actual assembly code

```bash
g++ -S -fno-asynchronous-unwind-tables -fno-execptions -march=x86-64 main.cpp
```

Snippet of `main.s`

```assembly
_Z7routinePv:						# Function "routine(void*)"
	pushq	%rbp					# Save the previous base pointer on the stack
	movq	%rsp, %rbp
	movq	%rdi, -24(%rbp)

	#	for (int i = 0; i < ITERATIONS; i++)
	#	{
	#	        x++;
	#	}


	#	int i=0;
	movl	$0, -4(%rbp)				# Initialize the local loop counter to 0 (stored at -4(%rbp))
.L3:							# Loop label
	# i < ITERATIONS
	movl	ITERATIONS(%rip), %eax			# Load the value of ITERATIONS (constant) into %eax
	cmpl	%eax, -4(%rbp)				# Compare the loop counter (-4(%rbp)) with ITERATIONS
	jge	.L2					# If the counter >= ITERATIONS, jump to the end of the loop

	#	x++;

	# ------- START -------

	movl	x(%rip), %eax				# Load the value of the global variable x into %eax

	# Now this is where race condition can occur
	# If the program is prempted at this point, can another process increments the value
	# Now when the control comes back to this point, then the eax register has the old value of x
	# So if the program runs the next line, it will increment the old value of x and thus instead of incrementing by 2 or more times (if multiple process access x at the same time), x will technically be incremented by only once
	# As the x(%rip) value will be overriden by the old value in eax register

	addl	$1, %eax				# Increment %eax by 1
	movl	%eax, x(%rip)				# Store the incremented value back into the global variable x

	# ------- END -------

	#	i++
	addl	$1, -4(%rbp)				# Increment the local loop counter (-4(%rbp)) by 1
	jmp	.L3					# Jump back to the start of the loop

.L2:							# End of the loop
	movl	$0, %eax				# Set the return value to 0 (stored in %eax)
	popq	%rbp					# Restore the previous base pointer
	ret						# Return from the function
```
