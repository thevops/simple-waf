# simple-waf
Count PHP requests and block after crossing the threshold.


Skrypt dodany jest do każdego wykonywanego zapytania poprzez wpis do .user.ini -> auto_prepend_file
Logowanie jest każde wywołanie, a cron uruchamiany co wybrany czas dodaje do pliku .htaccess adres IP, które przekroczyły próg.

Liczbę zapytań określa próg (domyślnie 100).
Przedział czasowy w jakim dozwolony jest powyższy limit określa wywołanie CRON.
