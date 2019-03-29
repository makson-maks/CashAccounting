﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ОтборПоДате") И Параметры.ОтборПоДате Тогда
		ДатаНачалаПериода = ОбщегоНазначенияКлиентСервер.ПолучитьДатуНачалаПериода(ТекущаяДата());
		ДатаОкончанияПериода = ОбщегоНазначенияКлиентСервер.ПолучитьДатуОкончанияПериода(ТекущаяДата()); 
		УстановитьОтборПоДате(Истина);
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("ВидРасхода") Тогда
		
		ОтборВидРасхода = Параметры.Отбор.ВидРасхода;
		
		Если ОтборВидРасхода = Перечисления.ВидыРасходов.Планируемый Тогда
			Заголовок = "Расход (план)";
		ИначеЕсли ОтборВидРасхода = Перечисления.ВидыРасходов.Фактический Тогда
			Заголовок = "Расход (факт)";	
		КонецЕсли;
		
	КонецЕсли;
	
	РассчитатьИтоговуюСуммуПоСпискуДокументов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	РассчитатьИтоговуюСуммуПоСпискуДокументов();	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СдвинутьПериодНазад(Команда)
	
	ДатаОкончанияПериода = ДатаНачалаПериода - 1;
	ДатаНачалаПериода = ОбщегоНазначенияКлиентСервер.ПолучитьДатуНачалаПериода(ДатаОкончанияПериода);
	УстановитьОтборПоДате(Истина);
	РассчитатьИтоговуюСуммуПоСпискуДокументов();
	
КонецПроцедуры

&НаКлиенте
Процедура СдвинутьПериодВперед(Команда)
	
	ДатаНачалаПериода = ДатаОкончанияПериода + 1;
	ДатаОкончанияПериода = ОбщегоНазначенияКлиентСервер.ПолучитьДатуОкончанияПериода(ДатаНачалаПериода);
	УстановитьОтборПоДате(Истина);
	РассчитатьИтоговуюСуммуПоСпискуДокументов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьВесьСписок(Команда)
	
	Элементы.ПоказатьВесьСписок.Пометка = Не Элементы.ПоказатьВесьСписок.Пометка;
	
	УстановитьОтборПоДате(Не Элементы.ПоказатьВесьСписок.Пометка);
	
	Если Элементы.ПоказатьВесьСписок.Пометка Тогда
		Элементы.ПоказатьВесьСписок.Заголовок = "Включить отбор по периоду";
	Иначе
		Элементы.ПоказатьВесьСписок.Заголовок = "Показать весь список";
	КонецЕсли;
	
	Элементы.ОтборПериод.Видимость = Не Элементы.ПоказатьВесьСписок.Пометка;
	
	РассчитатьИтоговуюСуммуПоСпискуДокументов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийСписка

&НаКлиенте
Процедура СписокПослеУдаления(Элемент)
	
	РассчитатьИтоговуюСуммуПоСпискуДокументов();
	Оповестить("ИзменениеОстатков");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокОбработкаЗапросаОбновления()
	
	РассчитатьИтоговуюСуммуПоСпискуДокументов();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыФункции

&НаСервере
Процедура УстановитьОтборПоДате(Использовать)
	
	Список.КомпоновщикНастроек.Настройки.Отбор.Элементы.Очистить();
	
	ШаблонПредставлениеПериода = "%1 - %2";
	ПредставлениеПериода = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ШаблонПредставлениеПериода,
		Формат(ДатаНачалаПериода, "ДЛФ=DD"),
		Формат(ДатаОкончанияПериода, "ДЛФ=DD"));
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
		Список.КомпоновщикНастроек.Настройки.Отбор,
		"Дата",
		ВидСравненияКомпоновкиДанных.БольшеИлиРавно,
		ДатаНачалаПериода,
		,
		Использовать);
		
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
		Список.КомпоновщикНастроек.Настройки.Отбор,
		"Дата",
		ВидСравненияКомпоновкиДанных.МеньшеИлиРавно,
		ДатаОкончанияПериода,
		,
		Использовать);
		
КонецПроцедуры

&НаСервере
Процедура РассчитатьИтоговуюСуммуПоСпискуДокументов()
	
	МассивВидовРасхода = Новый Массив;
	Если ЗначениеЗаполнено(ОтборВидРасхода) Тогда
		МассивВидовРасхода.Добавить(ОтборВидРасхода);
	Иначе
		МассивВидовРасхода.Добавить(Перечисления.ВидыРасходов.Планируемый);
		МассивВидовРасхода.Добавить(Перечисления.ВидыРасходов.Фактический);
	КонецЕсли;
	
	ТекстЗапрса =  
		"ВЫБРАТЬ
		|	СУММА(РасходДенежныхСредств.Сумма) КАК Сумма
		|ИЗ
		|	Документ.РасходДенежныхСредств КАК РасходДенежныхСредств
		|ГДЕ
		|	РасходДенежныхСредств.ВидРасхода В(&МассивВидовРасхода)";
	
	ТекстУсловия = "";
	Если Не Элементы.ПоказатьВесьСписок.Пометка Тогда
		ТекстУсловия = " И РасходДенежныхСредств.Дата МЕЖДУ &ДатаНачалаПериода И &ДатаОкончанияПериода";
	КонецЕсли;
	
	ТекстЗапрса = ТекстЗапрса + ТекстУсловия;
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапрса;
	Запрос.УстановитьПараметр("МассивВидовРасхода", МассивВидовРасхода);
	Запрос.УстановитьПараметр("ДатаНачалаПериода", ДатаНачалаПериода);
	Запрос.УстановитьПараметр("ДатаОкончанияПериода", КонецДня(ДатаОкончанияПериода));
	
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	ВыборкаДетальныеЗаписи.Следующий();
	
	ИтоговаяСумма = ВыборкаДетальныеЗаписи.Сумма;
	
КонецПроцедуры

#КонецОбласти