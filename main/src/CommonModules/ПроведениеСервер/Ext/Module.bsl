﻿
#Область ПрограммныйИнтерфейс

Процедура ПодготовитьНаборыЗаписейКПроведению(Объект) Экспорт
	
	ОчиститьДвижения(Объект);
	
КонецПроцедуры

Процедура ПодготовитьНаборыЗаписейКОтменеПроведения(Объект) Экспорт
	
	ОчиститьДвижения(Объект);	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыФункци

Процедура ОчиститьДвижения(Объект)
	
	Для каждого НаборЗаписей Из Объект.Движения Цикл
		НаборЗаписей.Записывать = Истина;
	КонецЦикла;
	
	Объект.Движения.Записать();
	
КонецПроцедуры

#КонецОбласти
