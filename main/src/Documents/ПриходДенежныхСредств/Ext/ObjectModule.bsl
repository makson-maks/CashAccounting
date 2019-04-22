﻿
#Область ОбработчикиСобытийОбъекта

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	ДополнительныеСвойства.Вставить("СуммаДоНовогоЛимитаДоИзменения", Ссылка.СуммаДоНовогоЛимита);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	
	Движения.ДенежныеСредства.Записывать = Истина;
	
	Движение = Движения.ДенежныеСредства.ДобавитьПриход();
	Движение.Период = Дата;
	Движение.Сумма = Сумма;
	
	СформироватьДвиженияПоРегиструОстатокЛимитаДенежныхСредств();	

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	Если ДополнительныеСвойства.СуммаДоНовогоЛимитаДоИзменения <> 0 Тогда
		ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
		УчетДенежныхСредствСервер.СформироватьРасходПоРегиструОстатокЛимитаДенежныхСредств(ДополнительныеСвойства.СуммаДоНовогоЛимитаДоИзменения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	УчетДенежныхСредствСервер.СформироватьРасходПоРегиструОстатокЛимитаДенежныхСредств(СуммаДоНовогоЛимита);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыФункции

Процедура СформироватьДвиженияПоРегиструОстатокЛимитаДенежныхСредств()
	
	Если СуммаДоНовогоЛимита = 0 Тогда
		Возврат;
	КонецЕсли;
	
	УчетДенежныхСредствСервер.СформироватьПриходПоРегиструОстатокЛимитаДенежныхСредств(СуммаДоНовогоЛимита);
	
КонецПроцедуры

#КонецОбласти
