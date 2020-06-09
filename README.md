# cucumberExample
This is extremely easy Cucumber tests example

=======================Polish below this line=============================

Niespodzianka, 
czyli jak ogórkiem połączyć cały zespół. 

# BDD
Mam nadzieję, że większość z Was słyszała o podejściu BDD (Behavior Driven Development). Jest to proces wytwórczy, który łączy w sobie TDD (wytwarzanie sterowane testami) oraz cech procesu DDD (Domain Driven Design). Jedną z podstawowych zasad BDD jest dostarczanie zespołom tworzącym oprogramowanie (w tym testerom!) i zespołom zarządzającym narzędzi takich, które umożliwią im realną współpracę przy tworzeniu oprogramowania.

Ze względu na swoje pochodzenie (przynajmniej częściowo) od test driven development, BDD mocno skupia się na weryfikacji i walidacji oprogramowania i ([za Wikipedią](https://pl.wikipedia.org/wiki/Behavior-driven_development)):

*"BDD sugeruje, aby nazwy testów jednostkowych były całymi zdaniami zaczynającymi się od warunkowego czasownika (np. w języku angielskim - od czasownika "should" - "powinien") i powinny być pisane w kolejności ich wartości biznesowej. Testy akceptacyjne powinny być napisane za pomocą tzw. "historyjek użytkowników" o następującej strukturze: "jako [rola] chcę [opis oczekiwanej funkcji], aby [opis oczekiwanej korzyści]". Kryteria akceptacyjne powinny być pisane w kategoriach scenariuszy i zaimplementowane w postaci klas: Given [początkowy kontekst], When [opis występującego zdarzenia], then [potwierdzenie wystąpienia oczekiwanego rezultatu]"*

To ostatnie to nic innego, niż składnia języka Gherkin, który jest częścią narzędzia Cucumber (konkretnie parserem scenariuszy).

Mówiąc po ludzku, testy napisane językiem naturalnym, zachowując tylko pewne wytyczne mają być wykorzystywane do automatycznego testowania kryteriów akceptacji. Możecie się zatrzymać i zapytać: a co z piramidą testów? Czy w ogóle warto automatyzować testy akceptacyjne, przecież one są jeszcze wyżej, niż testy na UI?! W zasadzie dobrze, że się zastanawiacie i wszyscy powinniście to oceniać w swoich projektach, sercach i umysłach, ALE akceptujemy nie tylko UI. Szczególnie w projektach zwinnych akceptujemy wielokrotnie i potrzebujemy testów regresji dotychczas zaakceptowanych funkcjonalności. W zasadzie, to możemy akceptować w ten sposób wewnętrznie (trzech amigos!) fukcjonalności zanim w ogóle klienci je zobaczą. Dodatkową nieocenianą wymiernie zaletą jest współpraca projektowa. Praca nad takimi scenariuszami jest naprawdę świetnym spoiwem "wysokiego biznesu", analityka, programisty i testera!

Idylla, co? To pozwólcie, że dorzucę małą łyżeczkę dziegciu. Wdrożenie tego procesu, stworzenie kodu i utrzymanie go wymaga dodatkowej warstwy abstrakcji. Po prostu coś za coś. Więcej grzebania w kodzie, żeby więcej osób mogło zrozumieć co się testuje, jak i gdzie failuje itd. Słowo klucz: MOGŁO! Jeśli w Waszym projekcie okaże się, że nikt poza testerami, czy deweloperami nie jest tymi testami zainteresowany, to utrzymywanie tego podejścia nie ma sensu. Skoro i tak wspólnie pracujecie z kodem, to zakładam, że go rozumiecie. Słyszałem o zespołach testowych, które utrzymywały cucumberowe scenariusze tylko dla siebie, twierdząc, że to przy okazji żywa dokumentacja. Tylko jeśli cały zespół automatyzuje, a więc umie czytać i rozumie kod... to czy sam kod nie byłby taką dokumentacją?

Ale po tym przydługim wstępie przejdźmy do meritum.

#Cucumber na przykładzie

Zanim zaczniecie, warto upewnić się, że częścią Waszego intelliJ'a jest plugin "Cucumber for Java", jeśli nie, pobierzcie go sobie z Marketplace.


Testujemy bardzo prostą klasę (tak, metoda mogłaby być statyczna, ale specjalnie nie jest!)

```java
public class Calc {
    public int sum(int a, int b) {
        return a + b;
    }
}
```

Wiemy już, że chcemy dla niej napisać scenariusze w formacie Gherkinowym/Cucumberowym, wiec w test/java/resources stworzę sobie plik Sum.feature. Jest t tzw. Featurefile, w którym będziemy przechowywać wszystkie scenariusze testowe dotyczące jakiegoś ficzera naszej aplikacji. W naszym przypadku będzie to sumowanie. Żeby parser poradził sobie z tym plikiem, wewnątrz musi się znaleźć "Feature: [tu dowolna nazwa]". Następnie dodajemy także scenariusze:

```gherkin
Scenario: Summing with zero
    Given I test calculator
    When I add 0 and 3
    Then result is 3
```
Małe wtrącenie: scenariusze powinny być konkretne tak by dawały przykłady realnych użyć oraz wysokopoziomowe. Sam Cucumber pozwala na nieskończoną w zasadzie liczbę kroków każdego typu. Możemy je powtarzać używając wielokrotnie słów kluczowych Given/When/Then, albo spójników (And / But), oba te podejścia zadziałają tak samo.

Teraz potrzebujemy stworzyć sobie tzw. Runner testów. W test/java/ stworzę bardzo prosty plik CucumberRunner.java (bez importów):

```java
@RunWith(Cucumber.class)
@CucumberOptions()
public class CucumberRunner {
}
```

Taką pustą klasę można uruchomić. Gdy to zrobicie zadzieje się magia i sam Cucumber podpowie Wam czego brakuje, a brakuje definicji kroków. Wystarczy potem takie "wydmuszki" metod skopiować do nowej klasy i prawidłowo uzupełnić. W test/java/StepsDef stworzę klasę StepsDef.java, wkleję tam skopiowane z konsoli metody i odpowiednio wypełnię. Do ciała klasy natomiast wrzucę deklarację zmiennej typu Calc oraz kolejną typu int do przechowywania wyniku. Wyjdzie mi coś takiego (bez importów):

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

Zwracam Waszą uwagę na poniższe kwestie.

Metoda z naszej testowej klasy nie była statyczna, żebyśmy mogli sobie poczynić jakiś setup w metodzie opisującej zdanie z Given.
Ponieważ w scenariuszu użyłem w zdaniach liczb (w When i Then) to Cucumber sam uznał, że w sumie, to może będę chciał używać tam różnych tych liczb i zrobi mi z nich automagicznie parametry. Sam je sobie nazwał (mało sprytnie) "int1", "int2". Zostawiłem je w takiej formie, ale nic nie stoi na przeszkodzie, żeby ich nazwy pozmieniać.

Jedyne co teraz pozostaje, to uruchomić CucumberRunnera ponownie.... i podziwiać. Testy przechodzą, a Wy możecie się cieszyć. Tylko ten log z wykonania testów taki mało urodziwy, co? No to w klasie CucumberRunner wypełnijmy puste dotychczas CucumberOptions:

```java
@CucumberOptions(plugin = {"pretty"})
```

Po uruchomieniu ponownie powinniście zobaczyć coś ładniejszego :)

I na koniec bez dopisywania linijki kodu, bawiąc się tylko w pliku feature, możemy stworzyć "Scenario Outline". Jest to taki rodzaj scenariusza, który jest tylko makietą, która zostanie uruchomiona tyle razy ile różnych zestawów danych jej dostarczymy. To się przydaje w przypadku, gdy chcemy wykonać ten sam scenariusz ale na rożnych danych. Jak dostarczyć te różne dane zobaczysz na poniższym przykładzie:

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

Zobaczcie, że dodałem parametr już w tytule tego scenariusza.  Dzięki temu będę mógł łatwo odróżnić wykonania tych testów, czy to w IDE, czy w historii uruchomienia na Jenkinsie, ale to już temat na zupełnie inną lekcję.
