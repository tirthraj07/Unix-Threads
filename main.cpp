#include <iostream>
#include <unistd.h>
#include <pthread.h>
using namespace std;

int x = 0;
int ITERATIONS = 100000000;

pthread_mutex_t mutex;

/*
OUTPUT:
Value of x = 2000000
Expected : 2000000
Missed % : 0

OUTPUT:
Value of x = 200000000
Expected : 200000000
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
	pthread_t t1, t2;
	pthread_mutex_init(&mutex, NULL); // Reserve the memory for mutex variable

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

	pthread_mutex_destroy(&mutex); // Free the memory
	return 0;
}
