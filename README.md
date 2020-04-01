# cucumberExample
This is extremely easy cucumbert tests example

=======================Polish below this line=============================

Niespodzianka, 
czyli jak ogórkiem połączyć cały zespół. 

Mam nadzieję, że większość z Was słyszała o podejściu BDD (Behavior Driven Development), jest to proces wytwórczy, który łączy w sobie TDD (wytwarzanie sterowane testami) oraz cech prcesu DDD (Domain Driven Design). Jedną z podstawowych zasad BDD jest dostarczanie zespołom tworzącym oprogramowanie (tak w tym testerom!) i zespołom zarządzającym narzędzi takich, które umożliwią im realną współpracę przy tworzeniu oprogramowania. <BR>
Ze względu na swoje pochodzenie (przynajmniej częściowo) od test driven development BDD mocno skupia się na weryfikacji i walidacji oprogramowania i (za wikipedią)  ( https://pl.wikipedia.org/wiki/Behavior-driven_development )<BR>
"BDD sugeruje, aby nazwy testów jednostkowych były całymi zdaniami zaczynającymi się od warunkowego czasownika (np. w języku angielskim - od czasownika "should" - "powinien") i powinny być pisane w kolejności ich wartości biznesowej. Testy akceptacyjne powinny być napisane za pomocą tzw. "historyjek użytkowników" o następującej strukturze: "jako [rola] chcę [opis oczekiwanej funkcji], aby [opis oczekiwanej korzyści]". Kryteria akceptacyjne powinny być pisane w kategoriach scenariuszy i zaimplementowane w postaci klas: Given [początkowy kontekst], When [opis występującego zdarzenia], then [potwierdzenie wystąpienia oczekiwanego rezultatu] "<BR>
To ostatnie to nic innego, niż składnia języka Gherkin, który jest częścią narzędzia Cucumber (konkretnie parserem scenariuszy). <BR><BR>
Mówiąc po ludzku - testy napisane językiem naturalnym, zachowując tylko pewne wytyczne mają być wykorzystywane do automatycznego testowania kryteriów akceptacji. Możecie się zatrzymać i zapytać - a co z piramidą terstów? Czy w ogóle warto automatyzować testy akceptacyjne, przecież one są jeszcze wyżej, niż testy na UI?! W zasadzie dobrze, że się zastanawiacie i wszyscy powinniście to oceniać w swoich projektach, sercach i umysłach, ALE akceptujemy nie tylko UI, (szczególnie) w projektach zwinnych akceptujemy wielokrotnie i potrzebujemy testów regresji dotychczas zaakceptowanych funkcjonalności oraz w zasadzie, to możemy akceptować w ten sposób wewnętrznie (trzech amigos!) fukcjonalności zanim w ogóle klienci je zobaczą. Dodatkową nieocenialną wymiernie zaletą jest współpraca projektowa. Praca nad takimi scenariuszami jest naprawdę świetnym spoiwem "wysokiego biznesu", analityka, programisty i testera! <BR>
Idylla, co? To pozwólcie, że dorzucę małą łyżeczkę dziegciu. Wdrożenie tego procesu, stworzenie kodu i utrzymanie go wymaga dodatkowej warstwy abstrakcji. Po prostu coś za coś. Więcej grzebania w kodzie, żeby więcej osób mogło zrozumieć co się testuje, jak, gdzie failuje itd. Słowo klucz - MOGŁO! Jeśli w Waszym projekcie okaże się, że nikt poza testerami, czy deweloperami nie jest tymi testami zainteresowany, to utrzymywanie tego podejścia nie ma sensu. Skoro i tak wspólnie pracujecie z kodem, to zakładam, że go rozumiecie. Słyszałem o zespołach testowych, które utrzymywały cucumberowe scenariusze tylko dla siebie, twierdząc, że to przy okazji żywa dokumentacja. Tylko jeśli cały zespół automatyzuje, a więc umie czytać i rozumie kod... to czy sam kod nie byłby taką dokumentacją?<BR><BR>

Ale po tym przydługim wstępie przejdźmy do meritum: <BR><BR>

Zanim zaczniecie, warto upewnić się, że częścią Waszego intelliJ'a jest plugin "Cucumber for Java" - jeśli nie, pobierzcie go sobie z Marketplace. <BR><BR>


Testujemy bardzo prostą klasę (tak, metoda mogłaby być statyczna, ale specjalnie nie jest!)<BR><BR>

```java
public class Calc {
    public int sum(int a, int b) {
        return a + b;
    }
}
```

Wiemy już, że chcemy dla niej napisać scenariusze w formacie Gherkinowym/Cucumberowym, wiec w test/java/resources stworzę sobie plik Sum.feature (to jest tzw. Featurefile w którym będziemy przechowywać wszystkie scenariusze testowe dotyczące jakiegoś ficzera naszej aplikacji - dla mnie to będzie sumowanie). Żeby parser poradził sobie z tym plikiem musi on mieć 
Feature: [tu dowolna nazwa]
Następnie znajdziemy w takim pliku scenariusze:
```gherkin
Scenario: Summing with zero
    Given I test calculator
    When I add 0 and 3
    Then result is 3
```
*małe wtrącenie - tak, scenariusze powinny być konkretne (dają przykłady realnych użyć) i wysokopoziomowe. 
Sam cucumber pozwala na nieskończoną w zasadzie liczbę kroków każdego typu - możemy je powtarzać używając wielokrotnie słów kluczowych Given/When/Then, albo spójników (And / But) - oba użycia zadziałają tak samo. 

Teraz potrzebujemy stworzyć sobie tzw. Runner testów -> w test/java/ stworzę bardzo prosty plik CucumberRunner.java (bez importów):
```java
@RunWith(Cucumber.class)
@CucumberOptions()
public class CucumberRunner {
}
```
Taką pustą klasę można uruchomić - kiedy to zrobocie zadzieje się magia i sam Cucumber podpowie Wam czego brakuje (brakuje definicji kroków) - wystarczy takie "wydmuszki" metod skopiować do nowej klasy, i prawidłowo uzupełnić. 
W test/java/StepsDef stworzę klasę StepsDef.java (wyciągnę sobie obiekcik Cacl i int z wynikiem jako pola tej klasy) wkleję tam skopiowane z konsoli metody i odpowiednio wypełnię. Wyjdzie mi coś takiego (bez importów):
```java
public class StepsDef {
    Calc calc;
    int result;

    @Given("I test calculator")
    public void i_test_calculator() {
        calc = new Calc();
    }

    @When("I add {int} and {int}")
    public void i_add_and(Integer int1, Integer int2) {
        result = calc.sum(int1, int2);
    }

    @Then("result is {int}")
    public void result_is(Integer int1) {
        Assertions.assertEquals(int1, result);
    }
}
```
Zwracam Waszą uwagę na:
1. To, że metoda z naszej testowej klasy nie była statyczna, żebyśmy mogli sobie poczynić jakiś setup w metodzie opisującej zdanie z Given
2. To, że ponieważ w scenariuszu użyłem w zdaniach liczb (w When i Then) to cucumber sam uznał, że w sumie, to może będę chciał używać tam różnych tych liczb i zrobi mi z nich automagicznie parametry (nazywa je sam z siebie mało smartnie "int1", "int2" - ja je już tak zostawiłem, ale nic nie stoi na przeszkodzie, żeby ich nazwy pozmieniać). 
Teraz jedyne co pozostaje zrobić to uruchomić CucumberRunnera ponownie.... i podziwiać. Testy przechodzą a Wy możecie się cieszyć. Tylko ten log z wykoanania testów taki mało urodziwy, co? No to w klasie CucumberRunner wypełnijmy puste dotychczas CucumberOptions:
```java
@CucumberOptions(plugin = {"pretty"})
```
Po uruchomieniu ponownie powinniście zobaczyć coś ładniejszego :) 

I na koniec bez dopisywania linijki kodu bawiąc się tylko w pliku fature możemy stworzyć "Scenario Outline" - czyli taki rodzaj scenariusza, który jest tylko makietą, która zostanie uruchomiona tyle razy ile zestawów danych jej dostarczymy. Tu musimy już sparametryzować parametry w samym scenario outline. Brzmi dziwnie, ale w przykładzie powinno być oczywiste:
```gherkin
Scenario Outline: Summing different numbers with zero for result <result>
    Given I test calculator
    When I add <num1> and <num2>
    Then result is <result>
    Examples:
      | num1 | num2 | result |
      | 0    | 7    | 7      |
      | 0    | 0    | 0      |
      | -6   | 0    | -6     |
```
Zobaczcie, że dodałem parametr już w tytule tego scenario outline - dzięki temu będę mógł łatwo odróżnić wykonania tych testów, czy to w IDE, czy w historii uruchomienia na Jenkinsie - ale to już temat na zupełnie inną lekcję. 
