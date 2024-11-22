#include <iostream>
#include <unistd.h>
#include <pthread.h>
using namespace std;

int x = 0;
int ITERATIONS = 10000000;

pthread_mutex_t mutex;

/*
OUTPUT:
Value of x = 40000000
Expected : 40000000
Missed % : 0

Thus we can avoid race conditions using mutex locks
*/

void *routine(void *)
{
	for (int i = 0; i < ITERATIONS; i++)
	{
		pthread_mutex_lock(&mutex);	  // Wait until the t1 finishes and lock the memory
		x++;						  // Execute
		pthread_mutex_unlock(&mutex); // Unlock the memory
	}
	return nullptr;
}

int main()
{
	pthread_t th[4];
	pthread_mutex_init(&mutex, NULL);

	for (int i = 0; i < 4; i++)
	{
		if (pthread_create(&th[i], NULL, &routine, NULL))
		{
			cout << "Could not create thread " << i + 1 << endl;
			return EXIT_FAILURE;
		}
	}

	for (int i = 0; i < 4; i++)
	{
		pthread_join(th[i], NULL);
	}

	cout << "Value of x = " << x << endl;
	cout << "Expected : " << ITERATIONS * 4 << endl;
	cout << "Missed % : " << ((float)(ITERATIONS * 4 - x) / (float)(ITERATIONS * 4)) * 100 << endl;

	pthread_mutex_destroy(&mutex); // Free the memory
	return 0;
}
