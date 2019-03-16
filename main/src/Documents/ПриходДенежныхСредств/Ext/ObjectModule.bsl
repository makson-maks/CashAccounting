﻿
#Область ОбработчикиСобытийОбъекта

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	Движения.ДенежныеСредства.Записывать = Истина;
	
	Движение = Движения.ДенежныеСредства.ДобавитьПриход();
	Движение.Период = Дата;
	Движение.Сумма = Сумма;
	
	Движения.ОстатокЛимитаДенежныхСредств.Записывать = Истина;
	
	Движение = Движения.ОстатокЛимитаДенежныхСредств.ДобавитьПриход();
	Движение.Период = Дата;
	Движение.Сумма = РассчитатьСуммуДляЛимита();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыФункции

Функция РассчитатьСуммуДляЛимита()
	
	ТекущийОстатокЛимита = УчетДенежныхСредствСервер.ПолучитьОстатокЛимитаДенежныхСредств();
	ЛимитДенежныхСредств = УчетДенежныхСредствСервер.ПолучитьЛимит();
	РасходыЗаТекущийПериод = УчетДенежныхСредствСервер.ПолучитьРасходыЗаТекущийПериод();
	
	ОсталосьОтЛимита = ЛимитДенежныхСредств - (ТекущийОстатокЛимита - РасходыЗаТекущийПериод);
	
	СуммаДляРаспределения = Мин(ОсталосьОтЛимита, Сумма);
	
	СуммаДоНовогоЛимита = УчетДенежныхСредствСервер.ПолучитьСуммуПоОставшимсяДням(СуммаДляРаспределения);
	
КонецФункции

#КонецОбласти
