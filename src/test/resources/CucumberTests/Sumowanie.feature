#language:pl
  Funkcja: Sumowanie

#    Scenariusz: Sumowanie z zerem
#      Zakładając, że kalkulator jest włączony
#      Oraz wyświetla 0
#      Oraz ma pełną baterię
#      Kiedy dodaję 0 i 6
#      Oraz naciskam guzik równa się
#      Wtedy wynik wynosi 6
#      Oraz jest wyświetlony na wyświetlaczu


    Szablon scenariusza: Sumowanie różnych liczb z zerem daje wynik <wynik>
      Zakładając, że kalkulator jest włączony
      Kiedy dodaję <num1> i <num2>
      Wtedy wynik wynosi <wynik>
      Przykłady:
      |num1|num2|wynik|
      |0   |7   |7    |
      |0   |0   |0    |
      |-6  |0   |-6   |
      |4   |0   |4    |