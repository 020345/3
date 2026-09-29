1. Write a program to create a child process. The parent catches a SIGCHLD
signal from the child process when the child terminates (the child sends
SIGCHLD when either it is interrupted or it resumes after being
interrupted).

#include <stdio.h>
#include <unistd.h>
#include <signal.h>
#include <sys/wait.h>

void h(int s)
{
    printf("SIGCHLD Received\n");
}

int main()
{
    signal(SIGCHLD, h);

    if (!fork())
    {
        printf("Child\n");
        return 0;
    }

    wait(NULL);

    printf("Parent done\n");

    return 0;
}




2. Write a program to print the default message of SIGINT signal and also
prints the user.

#include <stdio.h>
#include <signal.h>
#include <unistd.h>

void h(int s)
{
    printf("Caught SIGINT (Ctrl+C)\n");
}

int main()
{
    signal(SIGINT, h);

    while (1)
        pause();

    return 0;
}






3. Write a program for a process which cannot be killed by pressing Ctrl
+ c and again restore the default status of it. (Print necessary messages
where required).

#include <stdio.h>
#include <signal.h>
#include <unistd.h>

int main()
{
    signal(SIGINT, SIG_IGN);

    printf("Ctrl+C ignored for 5 seconds\n");

    sleep(5);

    signal(SIGINT, SIG_DFL);

    printf("Default restored\n");

    while (1)
        pause();

    return 0;
}





4. Process A and Process B normally sleep, except when process A
receives signal SIGUSR1 and process B receives signal SIGUSR2, when
both the processes prints the message “I am awake” and terminate.
Write a program to incorporate this.
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>

void h(int s)
{
    printf("I am awake\n");
    exit(0);
}

int main()
{
    signal(SIGUSR1, h);
    signal(SIGUSR2, h);

    printf("PID = %d\n", getpid());

    while (1)
        pause();

    return 0;
}





5. Write a program which takes a value of delay as command line
argument and creates a child process. The parent process waits for the
child process to finish its job up to the supplied delay value. If the child
terminates within the delay the parent prints the termination status
and PID of the child process. On not receiving from the child it kills the
child process forcefully.

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <sys/wait.h>

int main(int argc, char *argv[])
{
    int d = atoi(argv[1]);
    int st;

    pid_t p = fork();

    if (p == 0)
    {
        sleep(d + 1);
        exit(0);
    }

    sleep(d);

    if (waitpid(p, &st, WNOHANG))
        printf("Child %d finished\n", p);
    else
    {
        kill(p, SIGKILL);
        printf("Child %d killed\n", p);
    }

    return 0;
}
