﻿
#Область ОбработчикиСобытийФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	НачатьЗаписьДокумента();
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыФункции

&НаКлиенте
Процедура НачатьЗаписьДокумента()
	
	ВыполнитьПроведениеДокумента();
	Оповестить("ИзменениеОстатков");
	ОповеститьОбИзменении(Объект.Ссылка);
	Закрыть();

КонецПроцедуры

&НаСервере
Процедура ВыполнитьПроведениеДокумента()
	
	Модифицированность = Ложь;
	
	ОбъектДокумента = РеквизитФормыВЗначение("Объект");
	ОбъектДокумента.Записать(РежимЗаписиДокумента.ОтменаПроведения);
	ОбъектДокумента.Записать(РежимЗаписиДокумента.Проведение);
	ЗначениеВРеквизитФормы(ОбъектДокумента, "Объект");
	
КонецПроцедуры

#КонецОбласти