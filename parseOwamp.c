#include <stdio.h>
#include <stdlib.h>

#define MASK32(x) ((x) & 0xFFFFFFFFUL)
#define MILLION 1000000UL

/*
 * Lifted from owamp/arithm64.c
 *
 *
 * Function:        OWPNum64toTimeval
 *
 * Description:        
 *         Convert a time value in OWPNum64 representation to timeval
 *         representation. These are "relative" time values. (Not absolutes - i.e.
 *         they are not relative to some "epoch".) OWPNum64 values are
 *         unsigned 64 integral types with the MS (Most Significant) 32 bits
 *         representing seconds, and the LS (Least Significant) 32 bits
 *         representing fractional seconds (at a resolution of 32 bits).
 *
 * In Args:        
 *
 * Out Args:        
 *
 * Scope:        
 * Returns:        
 * Side Effect:        
 */
void
OWPNum64ToTimeval(
        struct timeval  *to,
        long long unsigned     from
        )
{
    /*
     * MS 32 bits represent seconds
     */
    to->tv_sec = MASK32(from >> 32);

    /*
     * LS 32 bits represent fractional seconds, normalize them to usecs:
     * frac/2^32 == micro/(10^6), so
     * nano = frac * 10^6 / 2^32
     */
    to->tv_usec = MASK32((MASK32(from)*MILLION) >> 32);

    while(to->tv_usec >= (long)MILLION){
        to->tv_sec++;
        to->tv_usec -= MILLION;
    }
}

int main(int argc, char *argv[])
{
  FILE *fp = fopen(argv[1], "r");
  char buf[1024];
  int seq, send_sync, recv_sync, ttl;
  long long unsigned ts;
  long long unsigned send_time, recv_time;
  long long unsigned delay_sec, delay_usec;
  float send_err, recv_err;
  struct timeval delay;


  while (fscanf(fp, "%d %llu %d %f %llu %d %f %d\n",
          &seq, &send_time, &send_sync, &send_err, &recv_time, &recv_sync,
          &recv_err, &ttl) != EOF) {
    ts = send_time >> 32;

    OWPNum64ToTimeval(&delay, recv_time - send_time);

    fprintf(stdout, "[%llu] Delay: %llu.%06llu\n", ts, delay.tv_sec, delay.tv_usec);
  }
  fclose(fp);
  return 0;
}
