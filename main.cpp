#include <iostream>
#include <unistd.h>
#include <pthread.h>
using namespace std;

int x = 0;
int ITERATIONS = 1000000;

/*
OUTPUT:
Value of x = 128758
Expected : 200000
Missed % : 35.621

OUTPUT:
Value of x = 1046202
Expected : 2000000
Missed % : 47.6899

This is called Race Condition
*/

void *routine(void *)
{
	for (int i = 0; i < ITERATIONS; i++)
	{
		x++;
	}
	return nullptr;
}

int main()
{
	pthread_t t1, t2;
	if (pthread_create(&t1, NULL, &routine, NULL) != 0)
	{
		cout << "Unable to create thread t1" << endl;
		return EXIT_FAILURE;
	};

	if (pthread_create(&t2, NULL, &routine, NULL) != 0)
	{
		cout << "Unable to create thread t2" << endl;
		return EXIT_FAILURE;
	};
	pthread_join(t1, NULL);
	pthread_join(t2, NULL);

	cout << "Value of x = " << x << endl;
	cout << "Expected : " << ITERATIONS * 2 << endl;
	cout << "Missed % : " << ((float)(ITERATIONS * 2 - x) / (float)(ITERATIONS * 2)) * 100 << endl;

	return 0;
}
