++ Python Workshop : Aug 09, 2013

+ Infrequently Answered Questions (Peter Norvig)

- Sorting lists of elements 
  
  I can sort a list of elements of any type, right?

  No, 

  ~~~
  x = [1, 1j]
  x.sort()
  ~~~
  And 

  ~~~
  x = [1, 'a']
  x.sort()
  ~~~
  Returns `None`.

  So the answer is you can sort a sequence of objects that support the __lt__
  method (and possibly other methods if the implementation happens to change).

- Can I do ++x and x++ in Python?
