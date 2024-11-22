#include <iostream>
#include <unistd.h>
#include <pthread.h>
using namespace std;

void *routine(void *)
{
	cout << "Test from threads" << endl;
	sleep(3);
	cout << "Ending Thread" << endl;
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

	return 0;
}
