#include <stdio.h>
#include <time.h>
#include <math.h>
#include <gsl/gsl_rng.h>

//implicitly defined circle
int inside_function(double x, double y)
{
    if (x*x+y*y <= 1.0)
        return 1;
    return 0;
}

int main(int argc, char** argv)
{
    //integration variables
    const long NUM_SAMPLES = 10000000;
    long inside_cnt = 0;
    double computed_pi = 0;
    double computed_error = 0; 

    //long double precision
    const double PI = 3.1415926535897932384626433832795028841968;

    //setup random number generator
    //i chose a marsenne prime twister (fast but good)
    //seed given in unix time
    gsl_rng* r = gsl_rng_alloc(gsl_rng_mt19937);
    gsl_rng_env_setup();
    gsl_rng_set (r,time (NULL));

    //throw darts on the board
    for (int i=0;i<NUM_SAMPLES;i++)
    {
        //generate random numbers on range [0,1.0)
        double x = gsl_rng_uniform(r);
        double y = gsl_rng_uniform(r);

        inside_cnt += inside_function(x,y);
    }

    //deallocate memory
    gsl_rng_free(r);

    //area of box is 4.0, from [-1,-1] to [1,1]
    computed_pi = (double) inside_cnt / (double) NUM_SAMPLES * 4.0;
    computed_error = fabs(computed_pi - PI);

    printf("Computed value of Pi %f\n",computed_pi);
    printf("Exact value of Pi %f\n", PI);
    printf("Error %E\n",computed_error);

    return 0;
}
