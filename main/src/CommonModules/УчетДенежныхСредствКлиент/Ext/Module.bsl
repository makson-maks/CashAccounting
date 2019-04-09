﻿
#Область ПрограммныйИнтерфейс

Процедура ОткрытьФормуСпискаПланируемыхРасходов() Экспорт
	
	Отбор = Новый Структура;
	Отбор.Вставить("ВидРасхода", ПредопределенноеЗначение("Перечисление.ВидыРасходов.Планируемый"));
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ОтборПоДате", Истина);
	ПараметрыФормы.Вставить("Отбор", Отбор);
	
	ОткрытьФорму("Документ.РасходДенежныхСредств.Форма.ФормаСписка", ПараметрыФормы,,"Планируемый");
	
КонецПроцедуры

Процедура ОткрытьФормуСпискаФактическихРасходов() Экспорт
	
	Отбор = Новый Структура;
	Отбор.Вставить("ВидРасхода", ПредопределенноеЗначение("Перечисление.ВидыРасходов.Фактический"));
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ОтборПоДате", Истина);
	ПараметрыФормы.Вставить("Отбор", Отбор);
	
	ОткрытьФорму("Документ.РасходДенежныхСредств.Форма.ФормаСписка", ПараметрыФормы,,"Фактический");
	
КонецПроцедуры

Процедура ОткрытьФормуВыбораДаты(Форма, ИмяРеквизитаДаты = "Дата", ЭтоРеквизитФормы = Ложь, ПриводитьКНачалуПериода = Ложь) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("ИмяРеквизитаДаты", ИмяРеквизитаДаты);
	ДополнительныеПараметры.Вставить("ЭтоРеквизитФормы", ЭтоРеквизитФормы);
	ДополнительныеПараметры.Вставить("ПриводитьКНачалуПериода", ПриводитьКНачалуПериода);
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ОкончаниеВыбораДаты", ЭтотОбъект, ДополнительныеПараметры);
	
	ПараметрыФормы = Новый Структура;
	
	Если ЭтоРеквизитФормы Тогда
		ПараметрыФормы.Вставить("Дата", Форма[ИмяРеквизитаДаты]);
	Иначе
		ПараметрыФормы.Вставить("Дата", Форма.Объект[ИмяРеквизитаДаты]);
	КонецЕсли;
	
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораДаты", ПараметрыФормы,,,,, ОповещениеОЗакрытии);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыФункции

&НаКлиенте
Процедура ОкончаниеВыбораДаты(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(РезультатЗакрытия) Тогда
		
		Если ДополнительныеПараметры.ПриводитьКНачалуПериода = Истина Тогда
			РезультатЗакрытия = ОбщегоНазначенияКлиентСервер.ПолучитьДатуНачалаПериода(РезультатЗакрытия);	
		КонецЕсли;
		
		Если ДополнительныеПараметры.ЭтоРеквизитФормы Тогда
			ДополнительныеПараметры.Форма[ДополнительныеПараметры.ИмяРеквизитаДаты] = РезультатЗакрытия;
		Иначе
			ДополнительныеПараметры.Форма.Объект[ДополнительныеПараметры.ИмяРеквизитаДаты] = РезультатЗакрытия;
		КонецЕсли;
		
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти