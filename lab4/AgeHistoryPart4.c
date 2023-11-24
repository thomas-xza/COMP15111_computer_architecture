#include stdlib.h


int day_current = 23;

int month_current = 11;

int year_current = 2005;


void
main() {
    
  printAgeHistory(day_current, month_current, 2000);
    
  print("Another person");
    
  printAgeHistory(13, 11, 2000);

}

void
printAgeHistory (day_birth, month_birth, bYear) {

  /*  Takes birthday as parameters. */

  /*  The 2x iterators are disorienting!  */
  /*  I would've added 1 iterator to 2 base numbers.  */
    
  int year_iter = bYear + 1;
    
  int age = 1;

  /*  Output birthday  */

  print("This person was born on " + str(day_birth) + "/" + str(month_birth) + "/" + str(bYear));

  /*  Compare birthday year with iterating year (on heap)  */

  /*  Thinking maybe that the logic behind the code has a logical
      flaw, only subtley hinted to, in exercise?  */

  /*  Honestly I would've probably converted the whole thing to epoch time then compared integers.
      However, have read that epoch time has some flaws, allegedly!  */
  
  /*  The sun does not revolve around the earth at a perfectly consistent rate,
      Maybe also the earth does not revolve on its axis at a perfectly consistent rate.  */

  /*  Basically the code is like:

      1/1/20XX                    |loop_hit|                                         31/12/2022
      1/1/20XX+1                  |loop_hit|      |bday|                             31/12/2023
      1/1/20XX+2                  |loop_hit|                                         31/12/2024

  */

  /*  AgeHistoryPart4.py is a more accurate implementation of AgeHistoryPart1.py  */    

  /*  But I can't see any shortcuts around human time...  */

  /*  I feel the desire to rewrite the overlying logic, but Assembly
      is *INSANELY* time-consuming to rewrite.  */
  /*  So, you have to be careful before writing Assembly...  */

  /*  Really you need to write tests before changing this, to know it
      actually works, but I'm just going to take a rough guess to save
      time...  */

  /*  OK say we had epoch time, it would just be:
          while iter less than epoch_time

      Anyway, trying to iterate the idea out:

      1/1/20XX+1      |possibility_a|      |bday = possibility_b|    |possibility_c|      31/12/2023
     
      Does the Python loop run once more if it hits possibility_a?
      The truth is: fuck knows. I hate it because I didn't write it,
      so I don't know how it works, and now it is all in Assembly, it
      can't be rewritten. And I feel like writing tests is overkill,
      and not sure if it would help.

      All the permutations that (I originally thought) we want to run the loop:

      1. Y hit, M higher
      2. Y hit, M hit, D higher or equal

      Which would translate to:

      while (year_iter <= year_current) AND
            (month_current <= monday_bday) AND
	    (day_current <= day_bday)

      Perhaps???????

      One advantage of Assembly programming, because it is so slow to implement ideas:
      forced to plan more, hack less.

  */
  
  while (
	 (year_iter < year_current) ||
	 (year_iter == year_current and month_birth < month_current) ||
	 (year_iter == year_current and month_birth == month_current and day_birth < day_current)
	 ) {
    
    printf("This person was " + str(age) + " on " + str(day_birth) + "/" + str(month_birth) + "/" + str(year_iter));

    year_iter = year_iter + 1;

    age = age + 1;

    if (month_birth == month_current and day_birth == day_current) {

      /*  If the dates match exactly, birthday  */

      printf("This person is " + str(age) + " today!");

    }

    else {

      /*  Otherwise  */

      print("This person will be " + str(age) + " on " + str(day_birth) + "/" + str(month_birth) + "/" + str(year_iter));

    }
    
  }

}        

main()
