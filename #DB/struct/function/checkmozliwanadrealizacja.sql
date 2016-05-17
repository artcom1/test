CREATE FUNCTION checkmozliwanadrealizacja(integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idtrans_pierwotny ALIAS FOR $1;
 _idpracownika INT;
 _uprawnienie INT;
 _flagaklienta INT;
 _ustawienietxt TEXT;
 _ustawienieval INT;
 _isZO BOOL;
BEGIN
 -- 1. Czy mam elem pierwotny
 IF (_idtrans_pierwotny<=0) THEN
  --RAISE NOTICE '1 % % % % % % %',_idtrans_pierwotny,_idpracownika,_uprawnienie,_flagaklienta,_ustawienietxt,_ustawienieval,_isZO;
  RETURN TRUE;
 END IF;
 
 -- 2. Okreslenie czy zamowienie zakupowe czy sprzedazowe
 _isZO=(SELECT (tr_flaga&(1<<9))!=0 FROM tg_transakcje WHERE tr_idtrans=_idtrans_pierwotny AND tr_rodzaj NOT IN (70));
 
 IF (_isZO IS NULL) THEN
  --- Nie ma wskazanego dokumentu lub dokument to konsygnata
  RETURN FALSE;
 END IF;
 
 IF (_isZO=TRUE) THEN
  _uprawnienie=(1<<13);
  _flagaklienta=(1<<28);
  _ustawienietxt=''||'BlokNadreal_1'||'';
 ELSE
  _uprawnienie=(1<<14);
  _flagaklienta=(1<<29);
  _ustawienietxt=''||'BlokNadreal_0'||'';
 END IF; 
  
 -- 3. Uprawnienia pracownika  
 _idpracownika=vendo.getidpracownika();
 --_idpracownika=2;
 IF (_idpracownika IS NULL) THEN
  --RAISE NOTICE '2 % % % % % % %',_idtrans_pierwotny,_idpracownika,_uprawnienie,_flagaklienta,_ustawienietxt,_ustawienieval,_isZO;
  RETURN TRUE;
 END IF;
 
 IF ((SELECT count(*) FROM tb_pracownicy WHERE p_uprawnienia2&_uprawnienie=_uprawnienie AND p_idpracownika=_idpracownika)=1) THEN
  --RAISE NOTICE '3 % % % % % % %',_idtrans_pierwotny,_idpracownika,_uprawnienie,_flagaklienta,_ustawienietxt,_ustawienieval,_isZO;
  RETURN TRUE;
 END IF;
 
 -- 4. Ustawienia programu
 -- BLOK_NADREAL_BRAK   = 0,
 --    BLOK_NADREAL_WGKL   = 1,
 --    BLOK_NADREAL_ZAWSZE = 2
 
 _ustawienieval=(SELECT cf_defvalue FROM tc_config WHERE cf_tabela=_ustawienietxt);
 -- Brak blokady nadrealizacja
 IF (_ustawienieval=0) THEN
  --RAISE NOTICE '4 % % % % % % %',_idtrans_pierwotny,_idpracownika,_uprawnienie,_flagaklienta,_ustawienietxt,_ustawienieval,_isZO;
  RETURN TRUE;
 END IF;
 
 -- Zawsze blokada nadrealizacja
 IF (_ustawienieval=2) THEN
  --RAISE NOTICE '5 % % % % % % %',_idtrans_pierwotny,_idpracownika,_uprawnienie,_flagaklienta,_ustawienietxt,_ustawienieval,_isZO;
  RETURN FALSE;
 END IF;
 
 IF (_ustawienieval<>1) THEN -- jakies nieokreslone
  --RAISE NOTICE '6 % % % % % % %',_idtrans_pierwotny,_idpracownika,_uprawnienie,_flagaklienta,_ustawienietxt,_ustawienieval,_isZO;
  RETURN FALSE;
 END IF;
  
 -- W zaleznosci od ustawien klienta
 
 _ustawienieval=(SELECT count(*) FROM tg_transakcje AS tr JOIN tb_klient AS kl ON (kl.k_idklienta=tr.k_idklienta) WHERE tr_idtrans=_idtrans_pierwotny AND k_flaga&_flagaklienta=_flagaklienta); 
 IF (_ustawienieval=1) THEN
  --RAISE NOTICE '7 % % % % % 1 %',_idtrans_pierwotny,_idpracownika,_uprawnienie,_flagaklienta,_ustawienietxt,_isZO;
  RETURN TRUE;
 END IF;
 
 --RAISE NOTICE '8 % % % % % 1 %',_idtrans_pierwotny,_idpracownika,_uprawnienie,_flagaklienta,_ustawienietxt,_isZO;
 RETURN FALSE;
END;
$_$;
