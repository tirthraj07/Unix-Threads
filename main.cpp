#include <iostream>
#include <unistd.h>
#include <pthread.h>
using namespace std;

int x = 2;

/*
OUTPUT:
Routine 1: Value of x is 3
Process ID: 549

Routine 2: Value of x is 3
Process ID: 549


This clearly shows that threads share the same memory space and the process is the same.
Where as fork() would create an entirely new process and copy all the variables
*/

void *routine1(void *)
{
	x++;
	cout << "\nRoutine 1: Value of x is " << x << endl;
	cout << "Process ID: " << getpid() << endl;
	return nullptr;
}

void *routine2(void *)
{
	sleep(2);
	cout << "\nRoutine 2: Value of x is " << x << endl;
	cout << "Process ID: " << getpid() << endl;
	return nullptr;
}

int main()
{
	pthread_t t1, t2;
	if (pthread_create(&t1, NULL, &routine1, NULL) != 0)
	{
		cout << "Unable to create thread t1" << endl;
		return EXIT_FAILURE;
	};

	if (pthread_create(&t2, NULL, &routine2, NULL) != 0)
	{
		cout << "Unable to create thread t2" << endl;
		return EXIT_FAILURE;
	};
	pthread_join(t1, NULL);
	pthread_join(t2, NULL);

	return 0;
}
