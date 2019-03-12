﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ТекущийОстатокДенежныхСредств = ПолучитьОстаткиДенежныхСредств();

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СформироватьОстатокЛимитаДенежныхСредств();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "ИзмененОстатокДенежныхСредств" Тогда
		ТекущийОстатокДенежныхСредств = ПолучитьОстаткиДенежныхСредств();
	ИначеЕсли ИмяСобытия = "ИзмененОстатокЛимитаДенежныхСредств" Тогда
		СформироватьОстатокЛимитаДенежныхСредств();	
	КонецЕсли;	

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы


#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьОстатокЛимитаДенежныхСредств(Команда)

	СформироватьОстатокЛимитаДенежныхСредств();	

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьТекущийОстатокДенежныхСредств(Команда)

	ТекущийОстатокДенежныхСредств = ПолучитьОстаткиДенежныхСредств();	

КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПриход(Команда)
	
	ОткрытьФорму("Документ.ФактическийПриходДенежныхСредств.Форма.ФормаДокумента");
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьРасход(Команда)
	
	ОткрытьФорму("Документ.ФактическийРасходДенежныхСредств.Форма.ФормаДокумента");
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПланируемыйРасход(Команда)
	
	ОткрытьФорму("Документ.ПланируемыйРасходДенежныхСредств.Форма.ФормаДокумента");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыФункции

&НаСервереБезКонтекста
Функция ПолучитьОстаткиДенежныхСредств()

	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ОстаткиДенежныхСредствОстатки.СуммаОстаток
		|ИЗ
		|	РегистрНакопления.ФактическиеОстаткиДенежныхСредств.Остатки КАК ОстаткиДенежныхСредствОстатки";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	ВыборкаДетальныеЗаписи.Следующий();
	
	Возврат ВыборкаДетальныеЗаписи.СуммаОстаток;
	
КонецФункции

&НаСервере
Функция ПолучитьФактическийОстатокЛимитаДенежныхСредств()

	ЛимитДС = Константы.ЛимитДенежныхСредств.Получить(); 

	ДатаНачалаНедели = ОбщегоНазначенияКлиентСервер.ПолучитьДатуНачалаНедели(ТекущаяДата());

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОстаткиДенежныхСредствОбороты.СуммаРасход КАК СуммаРасход
		|ИЗ
		|	РегистрНакопления.ФактическиеОстаткиДенежныхСредств.Обороты(&ДатаНачала, , , ) КАК ОстаткиДенежныхСредствОбороты";
	
	Запрос.УстановитьПараметр("ДатаНачала", ДатаНачалаНедели);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	ВыборкаДетальныеЗаписи.Следующий();
	
	Если ВыборкаДетальныеЗаписи.СуммаРасход = Неопределено Тогда
		СуммаРасход = 0;
	Иначе
		СуммаРасход = ВыборкаДетальныеЗаписи.СуммаРасход;
	КонецЕсли;
	
	Возврат ЛимитДС - СуммаРасход;
	
КонецФункции

&НаСервере
Функция ПолучитьПланируемыйОстатокЛимитаДенежныхСредств()

	ДатаНачалаНедели = ОбщегоНазначенияКлиентСервер.ПолучитьДатуНачалаНедели(ТекущаяДата());
	ДатаОкончанияНедели = ОбщегоНазначенияКлиентСервер.ПолучитьДатуОкончанияНедели(ТекущаяДата());

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПланируемыеОстаткиДенежныхСредствОбороты.СуммаОборот КАК СуммаОборот
		|ИЗ
		|	РегистрНакопления.ПланируемыеОстаткиДенежныхСредств.Обороты(&ДатаНачала, &ДатаОкончания, , ) КАК ПланируемыеОстаткиДенежныхСредствОбороты";
	
	Запрос.УстановитьПараметр("ДатаНачала", ДатаНачалаНедели);
	Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончанияНедели);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	ВыборкаДетальныеЗаписи.Следующий();
	
	Если ВыборкаДетальныеЗаписи.СуммаОборот = Неопределено Тогда
		СуммаОборот = 0;
	Иначе
		СуммаОборот = ВыборкаДетальныеЗаписи.СуммаОборот;
	КонецЕсли;
	
	Возврат СуммаОборот;
	
КонецФункции

&НаКлиенте
Процедура СформироватьОстатокЛимитаДенежныхСредств()
	
	ФактическийОстаток = ПолучитьФактическийОстатокЛимитаДенежныхСредств();
	ПланируемыеРасходы = ПолучитьПланируемыйОстатокЛимитаДенежныхСредств();
	
	ПланируемыйОстаток = ФактическийОстаток - ПланируемыеРасходы;
	
	ОстатокЛимитаДенежныхСредств = "Факт. " + ФактическийОстаток + " План. " + ПланируемыйОстаток;
	
КонецПроцедуры

#КонецОбласти

