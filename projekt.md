

**Dokument:** `database_design.md`
**Wersja:** 0.1 — model koncepcyjny i wstępny model logiczny
**Status:** projekt roboczy; nie jest jeszcze schematem produkcyjnym
**Technologie docelowe:** MariaDB (InnoDB), NestJS, React

---

## 1. Cel dokumentu

Dokument porządkuje dotychczasowe ustalenia dotyczące systemu obsługi wniosków o świadczenia z Zakładowego Funduszu Świadczeń Socjalnych. Jest punktem wyjścia do przygotowania diagramu ERD, a następnie skryptu SQL.

Nieznane jeszcze zasady regulaminu uczelni oznaczamy jako **TBD** (to be determined). Nie będziemy ich zgadywać ani na sztywno kodować.

### Zasady projektowe

1. Baza opisuje rzeczywiste obiekty i procesy, a nie tylko ekrany aplikacji.
2. Dane osobowe ograniczamy do minimum niezbędnego do obsługi świadczeń.
3. Wnioski, decyzje i zdarzenia historyczne zachowujemy — nie usuwamy ich fizycznie w zwykłym toku pracy.
4. Reguły świadczeń i wymagania dokumentacyjne powinny być konfigurowalne i wersjonowane.
5. Backend jest jedyną warstwą aplikacji komunikującą się z bazą. Frontend korzysta z API.
6. Baza wymusza integralność danych przez klucze główne, obce, ograniczenia i indeksy tam, gdzie to możliwe.

---

## 2. Ustalenia funkcjonalne

| Obszar                   | Ustalenie                                                                                                                  |
| ------------------------ | -------------------------------------------------------------------------------------------------------------------------- |
| Wnioskodawcy             | Aktualnie zatrudnieni pracownicy uczelni                                                                                   |
| Administrator            | Jest pracownikiem i może składać własne wnioski                                                                        |
| Role                     | Wstępnie:`EMPLOYEE`, `ADMIN`; `GUEST` wymaga doprecyzowania                                                         |
| Rejestracja pracowników | Ręczna oraz import z CSV/XLSX                                                                                             |
| Identyfikator pracownika | Własny klucz wewnętrzny; numer z USOS/kadr pozostaje do sprawdzenia                                                      |
| Zatrudnienie             | Pracownik może mieć wiele przypisań do jednostek/stanowisk                                                              |
| Wnioski                  | Pracownik może mieć wiele wniosków równocześnie                                                                       |
| Ponawianie wniosków     | Zasady zależą od rodzaju świadczenia i okresu                                                                           |
| Wersje robocze           | Tak                                                                                                                        |
| Poprawki                 | Wniosek może wrócić do pracownika i zostać ponownie złożony jako ten sam wniosek                                     |
| Dokumenty                | Nie przechowujemy skanów ani treści dokumentów; tylko ewidencję dostarczenia/weryfikacji                               |
| Wymagane dokumenty       | Konfigurowane dla świadczeń; historyczne wymagania muszą być zachowane przy wniosku                                    |
| Decyzje                  | Kwota przyznana może różnić się od wnioskowanej                                                                       |
| Komisja                  | Wieloosobowa; szczegóły głosowania są TBD                                                                              |
| Historia                 | Rejestrujemy zmiany statusów i istotne działania                                                                         |
| Okresy                   | Wniosek dotyczy konkretnego okresu świadczeniowego                                                                        |
| Dzieci                   | Pracownik może zgłosić wiele dzieci; jedno dziecko może być powiązane z więcej niż jednym pracownikiem             |
| Weryfikacja dzieci       | Pracownik deklaruje dane; komisja może zażądać potwierdzenia bez przechowywania kopii dokumentu                        |
| Kryteria                 | Konfigurowalne per świadczenie; część automatyczna, część wymaga oceny komisji                                      |
| Budżet                  | System ma ewidencjonować budżet, sumować przyznane kwoty i ostrzegać przed przekroczeniem; szczegóły rozliczania TBD |

---

## 3. Proponowany podział na obszary

### 3.1. Konta i role

- `users`
- `roles`
- `user_roles`

### 3.2. Pracownicy i struktura uczelni

- `employees`
- `departments`
- `employee_assignments`

### 3.3. Dzieci i uprawnienia rodzinne

- `children`
- `employee_children`
- `child_verifications`

### 3.4. Katalog świadczeń i okresy

- `benefit_types`
- `benefit_periods`
- `eligibility_rules`

### 3.5. Wnioski

- `applications`
- `application_statuses`
- `application_history`

### 3.6. Dokumentacja

- `document_types`
- `benefit_required_documents`
- `application_documents`

### 3.7. Komisja i decyzje

- `commission_members`
- `application_reviews`
- `decisions`

### 3.8. Budżet

- `benefit_budgets`
- `budget_transactions`

### 3.9. Import danych

- `import_batches`
- `import_rows` (opcjonalnie; do decyzji po zaprojektowaniu procesu importu)

---

## 4. Wstępny model logiczny tabel

Typy poniżej są typami logicznymi / propozycją. Dokładne typy MariaDB, długości pól, wartości domyślne i indeksy ustalimy w następnym kroku.

### 4.1. `users`

Konto służące do logowania. Nie jest tożsamością pracownika samą w sobie.

| Pole              | Znaczenie                                                           |
| ----------------- | ------------------------------------------------------------------- |
| `user_id` PK    | Wewnętrzny identyfikator konta                                     |
| `email`         | Adres logowania; unikalność TBD (czy adres może się zmieniać?) |
| `password_hash` | Hash hasła, nigdy hasło jawne                                     |
| `is_active`     | Czy konto jest aktywne                                              |
| `created_at`    | Data utworzenia                                                     |
| `updated_at`    | Data aktualizacji                                                   |

Relacja: konto może być powiązane z jednym rekordem `employees`. Konta techniczne/administracyjne bez pracownika nie są na tym etapie zakładane.

### 4.2. `roles`

| Pole                 | Znaczenie                  |
| -------------------- | -------------------------- |
| `role_id` PK       | Identyfikator roli         |
| `role_code` UNIQUE | Np.`EMPLOYEE`, `ADMIN` |
| `role_name`        | Nazwa wyświetlana         |
| `description`      | Opis                       |

`GUEST` może oznaczać anonimowego odwiedzającego, a nie rekord przypisany do konta. Rozstrzygniemy to podczas projektowania uwierzytelniania.

### 4.3. `user_roles`

Tabela łącząca użytkowników i role (N:M).

| Pole                     | Znaczenie        |
| ------------------------ | ---------------- |
| `user_id` PK/FK        | Konto            |
| `role_id` PK/FK        | Rola             |
| `assigned_at`          | Data nadania     |
| `assigned_by` FK, NULL | Kto nadał rolę |

Wstępnie zakładamy, że administrator ma uprawnienia pracownika i może składać własne wnioski. W implementacji można to osiągnąć przez jawne przypisanie obu ról albo przez hierarchię uprawnień — do decyzji przy projekcie RBAC.

### 4.4. `employees`

| Pole                                      | Znaczenie                                              |
| ----------------------------------------- | ------------------------------------------------------ |
| `employee_id` PK                        | Wewnętrzny identyfikator pracownika                   |
| `user_id` FK, UNIQUE                    | Powiązane konto                                       |
| `first_name`                            | Imię                                                  |
| `last_name`                             | Nazwisko                                               |
| `email`                                 | Służbowy adres kontaktowy, jeśli odrębny od loginu |
| `external_employee_number` NULL, UNIQUE | Numer z USOS/kadr — dopiero po sprawdzeniu            |
| `is_active`                             | Czy pracownik jest aktywny w systemie                  |
| `created_at`, `updated_at`            | Znaczniki czasu                                        |

**Uwaga:** nie uzależniamy `employee_id` od USOS ani PESEL. Nie dodajemy PESEL bez wykazanego, prawnego i funkcjonalnego uzasadnienia.

### 4.5. `departments`

| Pole                              | Znaczenie                                         |
| --------------------------------- | ------------------------------------------------- |
| `department_id` PK              | Identyfikator jednostki                           |
| `department_name`               | Nazwa jednostki                                   |
| `parent_department_id` FK, NULL | Jednostka nadrzędna, jeśli potrzebna hierarchia |
| `is_active`                     | Czy jednostka jest aktywna                        |

### 4.6. `employee_assignments`

Pozwala przypisać jednego pracownika do wielu jednostek i stanowisk, z zachowaniem historii.

| Pole                 | Znaczenie                 |
| -------------------- | ------------------------- |
| `assignment_id` PK | Identyfikator przypisania |
| `employee_id` FK   | Pracownik                 |
| `department_id` FK | Jednostka                 |
| `position_name`    | Nazwa stanowiska          |
| `start_date`       | Początek przypisania     |
| `end_date` NULL    | Koniec przypisania        |

### 4.7. `children`

| Pole              | Znaczenie                 |
| ----------------- | ------------------------- |
| `child_id` PK   | Wewnętrzny identyfikator |
| `date_of_birth` | Data urodzenia            |
| `is_active`     | Czy rekord jest aktywny   |

Na tym etapie nie zapisujemy imienia, nazwiska ani PESEL dziecka, ponieważ nie ustalono, że są potrzebne.

### 4.8. `employee_children`

Relacja N:M między pracownikami i dziećmi.

| Pole                     | Znaczenie                        |
| ------------------------ | -------------------------------- |
| `employee_child_id` PK | Identyfikator powiązania        |
| `employee_id` FK       | Pracownik                        |
| `child_id` FK          | Dziecko                          |
| `relationship_type`    | Rodzaj relacji, jeśli potrzebny |
| `valid_from`           | Początek powiązania            |
| `valid_to` NULL        | Koniec powiązania               |

**Ważne TBD:** jeżeli oboje rodzice pracują na uczelni, trzeba ustalić, jak system rozpoznaje, że dwa zgłoszenia dotyczą tego samego dziecka, skoro nie chcemy gromadzić nadmiarowych identyfikatorów. Nie wolno zakładać, że sama data urodzenia wystarczy do pewnego dopasowania.

### 4.9. `child_verifications`

| Pole                            | Znaczenie                                                    |
| ------------------------------- | ------------------------------------------------------------ |
| `child_verification_id` PK    | Identyfikator weryfikacji                                    |
| `employee_child_id` FK        | Powiązanie pracownik–dziecko, którego dotyczy weryfikacja |
| `verified_by` FK → `users` | Osoba weryfikująca                                          |
| `verified_at`                 | Data weryfikacji                                             |
| `verification_status`         | Np.`PENDING`, `VERIFIED`, `REJECTED`                   |
| `comment` NULL                | Uwagi bez kopiowania treści dokumentu                       |

Nie przechowujemy kopii dokumentu potwierdzającego datę urodzenia.

### 4.10. `benefit_types`

| Pole                           | Znaczenie                                                                      |
| ------------------------------ | ------------------------------------------------------------------------------ |
| `benefit_type_id` PK         | Identyfikator rodzaju świadczenia                                             |
| `name`                       | Nazwa                                                                          |
| `description` NULL           | Opis                                                                           |
| `is_active`                  | Czy świadczenie jest dostępne                                                |
| `allows_multiple`            | Wstępna flaga dotycząca ponawiania; szczegółowe limity określają reguły |
| `created_at`, `updated_at` | Znaczniki czasu                                                                |

Przykładowe kategorie znane z rozmowy: wczasy pod gruszą, świadczenie świąteczne, świadczenie z okazji Dnia Dziecka, pomoc w sytuacji wyjątkowej. Lista nie jest zamknięta.

### 4.11. `benefit_periods`

| Pole                     | Znaczenie                                 |
| ------------------------ | ----------------------------------------- |
| `benefit_period_id` PK | Identyfikator okresu                      |
| `benefit_type_id` FK   | Rodzaj świadczenia                       |
| `name`                 | Np. „Boże Narodzenie 2026”             |
| `year`                 | Rok rozliczeniowy, jeśli ma zastosowanie |
| `start_date` NULL      | Początek okresu                          |
| `end_date` NULL        | Koniec okresu                             |
| `is_active`            | Czy okres przyjmuje wnioski               |

Wymagamy spójności: okres musi należeć do rodzaju świadczenia wskazanego we wniosku. W SQL można to zabezpieczyć kluczem złożonym (unikalna para `benefit_period_id`, `benefit_type_id` i odpowiadający jej FK w `applications`).

### 4.12. `eligibility_rules`

Konfiguracja kryteriów kwalifikacyjnych.

| Pole                         | Znaczenie                                |
| ---------------------------- | ---------------------------------------- |
| `eligibility_rule_id` PK   | Identyfikator reguły                    |
| `benefit_type_id` FK       | Rodzaj świadczenia                      |
| `rule_code`                | Stabilny kod typu reguły                |
| `rule_name`                | Nazwa                                    |
| `rule_type`                | Np. automatyczna lub wymagająca oceny   |
| `parameters`               | Parametry reguły — format do ustalenia |
| `is_mandatory`             | Czy kryterium jest obowiązkowe          |
| `valid_from`, `valid_to` | Okres obowiązywania                     |
| `is_active`                | Czy reguła jest aktywna                 |

Nie przechowujemy dowolnego SQL ani wykonywalnego kodu w bazie. Zestaw obsługiwanych typów reguł i format parametrów zaprojektujemy jawnie w backendzie.

### 4.13. `applications`

| Pole                                     | Znaczenie                         |
| ---------------------------------------- | --------------------------------- |
| `application_id` PK                    | Identyfikator wniosku             |
| `employee_id` FK                       | Wnioskodawca                      |
| `benefit_type_id` FK                   | Rodzaj świadczenia               |
| `benefit_period_id` FK                 | Okres świadczeniowy              |
| `status_id` FK                         | Aktualny status                   |
| `requested_amount` DECIMAL(12,2), NULL | Kwota wnioskowana, jeśli dotyczy |
| `submitted_at` NULL                    | Data formalnego złożenia        |
| `created_at`, `updated_at`           | Znaczniki czasu                   |

Wniosek może przechodzić przez wiele cykli poprawy i ponownego złożenia. To nadal ten sam rekord `applications`; kolejne wersje treści i zdarzenia muszą być możliwe do odtworzenia.

### 4.14. `application_statuses`

| Pole                   | Znaczenie                                                                                                         |
| ---------------------- | ----------------------------------------------------------------------------------------------------------------- |
| `status_id` PK       | Identyfikator                                                                                                     |
| `status_code` UNIQUE | Np.`DRAFT`, `SUBMITTED`, `UNDER_REVIEW`, `REQUIRES_CORRECTION`, `APPROVED`, `REJECTED`, `WITHDRAWN` |
| `status_name`        | Nazwa wyświetlana                                                                                                |
| `is_final`           | Czy status kończy standardowy proces                                                                             |

Przejścia między statusami kontroluje backend, a nie dowolna zmiana wartości przez frontend.

### 4.15. `application_history`

| Pole                            | Znaczenie               |
| ------------------------------- | ----------------------- |
| `application_history_id` PK   | Identyfikator zdarzenia |
| `application_id` FK           | Wniosek                 |
| `previous_status_id` FK, NULL | Poprzedni status        |
| `new_status_id` FK            | Nowy status             |
| `changed_by` FK → `users`  | Kto wykonał operację  |
| `changed_at`                  | Kiedy                   |
| `comment` NULL                | Powód/komentarz        |

Osobno trzeba zaprojektować historię zmian treści wniosku, aby można było ustalić, jaką wersję komisja faktycznie rozpatrywała. Robocza nazwa: `application_versions`. Szczegóły TBD.

### 4.16. `document_types`

| Pole                    | Znaczenie                           |
| ----------------------- | ----------------------------------- |
| `document_type_id` PK | Identyfikator                       |
| `name`                | Nazwa rodzaju dokumentu             |
| `description` NULL    | Opis                                |
| `is_active`           | Czy rodzaj dokumentu jest dostępny |

### 4.17. `benefit_required_documents`

Konfiguracja dokumentów wymaganych dla rodzaju świadczenia.

| Pole                                | Znaczenie                         |
| ----------------------------------- | --------------------------------- |
| `benefit_required_document_id` PK | Identyfikator konfiguracji        |
| `benefit_type_id` FK              | Rodzaj świadczenia               |
| `document_type_id` FK             | Rodzaj dokumentu                  |
| `is_required`                     | Czy dokument jest obowiązkowy    |
| `valid_from`, `valid_to`        | Okres obowiązywania konfiguracji |

Zmiana wymagań nie może zmieniać wstecz wymagań przypisanych do już złożonych wniosków.

### 4.18. `application_documents`

Ewidencja dokumentów dla konkretnego wniosku — bez przechowywania plików i treści.

| Pole                                    | Znaczenie                                                     |
| --------------------------------------- | ------------------------------------------------------------- |
| `application_document_id` PK          | Identyfikator                                                 |
| `application_id` FK                   | Wniosek                                                       |
| `document_type_id` FK                 | Rodzaj dokumentu                                              |
| `status`                              | `PENDING`, `DELIVERED`, `VERIFIED` lub `NOT_REQUIRED` |
| `delivery_date` NULL                  | Data dostarczenia                                             |
| `registered_by` FK → `users`, NULL | Kto zarejestrował dostarczenie                               |
| `verification_date` NULL              | Data weryfikacji                                              |
| `verified_by` FK → `users`, NULL   | Kto zweryfikował                                             |

Przy utworzeniu wniosku system powinien skopiować jego wymagania do zestawu dokumentów przypisanych do wniosku. Dzięki temu późniejsza zmiana konfiguracji nie zmieni historycznej sprawy. Historia zmian statusów dokumentów wymaga osobnej tabeli zdarzeń, np. `application_document_history`.

### 4.19. `commission_members`

| Pole                        | Znaczenie                             |
| --------------------------- | ------------------------------------- |
| `commission_member_id` PK | Identyfikator członkostwa            |
| `employee_id` FK          | Pracownik będący członkiem komisji |
| `valid_from`              | Początek członkostwa                |
| `valid_to` NULL           | Koniec członkostwa                   |
| `is_active`               | Czy członkostwo jest aktywne         |

Członkostwo w komisji jest funkcją organizacyjną. Rola `ADMIN` określa uprawnienia aplikacyjne. Nie należy utożsamiać tych dwóch pojęć, nawet jeśli na potrzeby pierwszej wersji członkowie komisji otrzymają uprawnienia administratora.

### 4.20. `application_reviews`

| Pole                         | Znaczenie                              |
| ---------------------------- | -------------------------------------- |
| `application_review_id` PK | Identyfikator rozpatrzenia             |
| `application_id` FK        | Wniosek                                |
| `commission_member_id` FK  | Członek komisji                       |
| `reviewed_at` NULL         | Data rozpatrzenia                      |
| `review_status` NULL       | Wynik/etap, jeśli zostanie określony |
| `comment` NULL             | Uwagi                                  |

Głosowanie nie jest częścią pierwszej wersji modelu. Jeżeli regulamin potwierdzi głosowanie, zaprojektujemy osobne tabele dla posiedzeń i głosów.

### 4.21. `decisions`

| Pole                                    | Znaczenie                                                                          |
| --------------------------------------- | ---------------------------------------------------------------------------------- |
| `decision_id` PK                      | Identyfikator decyzji                                                              |
| `application_id` FK                   | Wniosek                                                                            |
| `decision_type`                       | Np.`APPROVED`, `REJECTED`, `PARTIALLY_APPROVED` — słownik do zatwierdzenia |
| `decision_date`                       | Data decyzji                                                                       |
| `approved_amount` DECIMAL(12,2), NULL | Kwota przyznana                                                                    |
| `comment` NULL                        | Uzasadnienie/uwagi                                                                 |
| `recorded_by` FK → `users`         | Osoba rejestrująca decyzję                                                       |

Kwota wnioskowana należy do `applications`, a kwota przyznana do `decisions`. Nie zakładamy jeszcze, czy wniosek może mieć wiele formalnych decyzji — trzeba to doprecyzować, aby obsłużyć ewentualne ponowne rozpatrzenie bez nadpisywania historii.

### 4.22. `benefit_budgets`

| Pole                            | Znaczenie                   |
| ------------------------------- | --------------------------- |
| `benefit_budget_id` PK        | Identyfikator budżetu      |
| `benefit_period_id` FK        | Okres świadczeniowy        |
| `budget_amount` DECIMAL(12,2) | Dostępna pula              |
| `is_control_enabled`          | Czy system kontroluje limit |
| `updated_at`                  | Data aktualizacji           |

### 4.23. `budget_transactions`

Rejestr zmian obciążenia budżetu. Saldo powinno wynikać z transakcji, a nie z ręcznie zmienianego pola „pozostało”.

| Pole                           | Znaczenie                  |
| ------------------------------ | -------------------------- |
| `budget_transaction_id` PK   | Identyfikator              |
| `benefit_budget_id` FK       | Budżet                    |
| `decision_id` FK, NULL       | Powiązana decyzja         |
| `amount` DECIMAL(12,2)       | Kwota obciążenia/korekty |
| `transaction_type`           | Typ operacji               |
| `created_at`                 | Data operacji              |
| `created_by` FK → `users` | Kto zarejestrował         |

Szczegóły księgowania, anulowania decyzji i zwalniania środków wymagają potwierdzenia z zasadami uczelni.

---

## 5. Najważniejsze relacje

- `users` 1:0..1 `employees`
- `users` N:M `roles` przez `user_roles`
- `employees` 1:N `employee_assignments`
- `departments` 1:N `employee_assignments`
- `employees` N:M `children` przez `employee_children`
- `benefit_types` 1:N `benefit_periods`
- `employees` 1:N `applications`
- `benefit_types` 1:N `applications`
- `benefit_periods` 1:N `applications`
- `applications` 1:N `application_history`
- `applications` 1:N `application_documents`
- `benefit_types` N:M `document_types` przez `benefit_required_documents`
- `benefit_types` 1:N `eligibility_rules`
- `employees` 1:N `commission_members` (historyczne członkostwa)
- `applications` 1:N `application_reviews`
- `applications` 1:N `decisions` (do potwierdzenia)
- `benefit_periods` 1:0..1 `benefit_budgets` (wstępne założenie)
- `benefit_budgets` 1:N `budget_transactions`

---

## 6. Wstępny przebieg procesu

1. Administrator dodaje pracownika ręcznie albo importuje dane.
2. Pracownik otrzymuje konto i loguje się.
3. Pracownik uzupełnia wymagane dane, np. deklaruje dzieci, jeżeli świadczenie tego wymaga.
4. Pracownik wybiera rodzaj i okres świadczenia.
5. System tworzy wersję roboczą wniosku i zestaw wymaganych dokumentów według konfiguracji obowiązującej dla tego wniosku.
6. System sprawdza automatyczne kryteria, a nierozstrzygnięte oznacza do weryfikacji.
7. Pracownik składa wniosek.
8. Komisja rozpatruje wniosek, może zażądać poprawek lub dokumentów.
9. Pracownik poprawia ten sam wniosek i składa go ponownie.
10. Komisja rejestruje decyzję i przyznaną kwotę.
11. System aktualizuje ewidencję budżetu i zachowuje historię.

---

## 7. Zasady techniczne dla MariaDB

1. Wszystkie tabele relacyjne używają silnika `InnoDB`.
2. Kodowanie: `utf8mb4`.
3. Klucze główne: wewnętrzne identyfikatory `BIGINT UNSIGNED AUTO_INCREMENT` (do potwierdzenia przy DDL).
4. Klucze obce muszą mieć zgodny typ i znak z kolumnami referencjonowanymi.
5. Kwoty: `DECIMAL(12,2)`, nie `FLOAT`/`DOUBLE`.
6. Daty kalendarzowe: `DATE`; chwile zdarzeń: `DATETIME` lub `DATETIME(precision)` według wspólnej konwencji.
7. Nazwy tabel i kolumn: angielskie `snake_case`.
8. Hasła: wyłącznie bezpieczne hashe tworzone przez bibliotekę backendu.
9. Nie usuwamy kaskadowo danych historycznych, takich jak wnioski, decyzje i audyt. Dla tych relacji preferujemy `RESTRICT` i dezaktywację zamiast fizycznego usuwania.
10. Klucze obce, `UNIQUE` i `CHECK` wykorzystujemy do ochrony integralności, ale walidacja reguł procesu pozostaje również w backendzie.

MariaDB/InnoDB obsługuje klucze obce i ograniczenia integralności. Kolumny FK muszą być zgodne typem z kolumnami referencjonowanymi. `DECIMAL` jest typem stałoprzecinkowym dokładnym i dlatego nadaje się do kwot pieniężnych.

---

## 8. Otwarte kwestie — nie blokują dalszej pracy

| ID     | Kwestia               | Co trzeba ustalić                                                                              |
| ------ | --------------------- | ----------------------------------------------------------------------------------------------- |
| TBD-01 | Identyfikator kadrowy | Czy USOS/kadry udostępnia stabilny numer pracownika                                            |
| TBD-02 | Logowanie             | Czy loginem będzie uczelniany e-mail i czy możliwe będzie SSO                                |
| TBD-03 | Guest                 | Czy`GUEST` jest rolą konta, czy po prostu dostępem anonimowym                               |
| TBD-04 | Dane dzieci           | Jak rozpoznawać to samo dziecko zgłoszone przez dwoje pracowników bez nadmiarowych danych    |
| TBD-05 | Regulamin             | Konkretne kryteria, limity, okresy i wymagane dokumenty                                         |
| TBD-06 | Wersjonowanie         | Zakres przechowywania wersji treści wniosku                                                    |
| TBD-07 | Komisja               | Czy jest głosowanie, kworum, posiedzenia i indywidualne głosy                                 |
| TBD-08 | Decyzje               | Czy dopuszczalne są kolejne decyzje/ponowne rozpatrzenia dla jednego wniosku                   |
| TBD-09 | Budżet               | Zasady rezerwowania, obciążania i zwalniania środków                                        |
| TBD-10 | Import                | Format pliku źródłowego, mapowanie kolumn i reguły aktualizacji pracowników                |
| TBD-11 | Retencja              | Okres przechowywania danych i procedura archiwizacji/usuwania zgodna z polityką uczelni        |
| TBD-12 | Uprawnienia           | Czy administratorzy mają identyczne uprawnienia, czy potrzebne są ograniczenia zakresu danych |

---

## 9. Kolejność dalszych prac

### Krok 1 — zatwierdzenie modelu

Przejrzeć encje, usunąć zbędne, rozdzielić te, które mają różne odpowiedzialności.

### Krok 2 — diagram ERD

Przygotować diagram z kluczami PK/FK, krotnościami i opcjonalnością relacji.

### Krok 3 — DDL dla MariaDB

Napisać skrypt `01_schema.sql` tworzący bazę, tabele, indeksy i ograniczenia.

### Krok 4 — dane startowe

Przygotować `02_seed.sql` dla ról, statusów i przykładowych typów dokumentów/świadczeń.

### Krok 5 — test bazy

Utworzyć bazę w lokalnym MariaDB/XAMPP, załadować dane testowe i sprawdzić relacje.

Dopiero po tych krokach przejdziemy do modułów backendu NestJS.

---

## 10. Źródła techniczne

- [MariaDB — Foreign Keys](https://mariadb.com/docs/server/ha-and-performance/optimization-and-tuning/optimization-and-indexes/foreign-keys)
- [MariaDB — Constraints](https://mariadb.com/docs/server/reference/sql-statements/data-definition/constraint)
- [MariaDB — DECIMAL](https://mariadb.com/docs/server/reference/data-types/numeric-data-types/decimal)
  """

out = Path("/mnt/data/database_design.md")
pypandoc.convert_text(content, "md", format="md", outputfile=str(out), extra_args=["--standalone"])
print(f"Utworzono: {out} ({out.stat().st_size} bajtów)")
