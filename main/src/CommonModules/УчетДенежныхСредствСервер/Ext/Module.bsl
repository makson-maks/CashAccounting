﻿
#Область ПрограммныйИнтерфейс

Функция ПолучитьОстатокЛимитаДенежныхСредств() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЛимитДенежныхСредствОстатки.СуммаОстаток КАК СуммаОстаток
		|ИЗ
		|	РегистрНакопления.ОстатокЛимитаДенежныхСредств.Остатки КАК ЛимитДенежныхСредствОстатки";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	ВыборкаДетальныеЗаписи.Следующий();
	
	Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.СуммаОстаток) Тогда
		Возврат ВыборкаДетальныеЗаписи.СуммаОстаток;
	Иначе	
		Возврат 0;
	КонецЕсли;
	
КонецФункции

Функция ПолучитьРасходыЗаТекущийПериод() Экспорт
	
	ДатаНачалаПериода = ОбщегоНазначенияКлиентСервер.ПолучитьДатуНачалаПериода(ОбщегоНазначенияСервер.ПолучитьИспользуемуюДату());

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДенежныеСредства.СуммаРасход КАК СуммаРасход
		|ИЗ
		|	РегистрНакопления.ДенежныеСредства.Обороты(&ДатаНачала, &ДатаОкончания, , ) КАК ДенежныеСредства";
	
	Запрос.УстановитьПараметр("ДатаНачала", ДатаНачалаПериода);
	Запрос.УстановитьПараметр("ДатаОкончания", ОбщегоНазначенияСервер.ПолучитьИспользуемуюДату());
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	ВыборкаДетальныеЗаписи.Следующий();
	
	Если ВыборкаДетальныеЗаписи.СуммаРасход = Неопределено Тогда
		СуммаРасход = 0;
	Иначе
		СуммаРасход = ВыборкаДетальныеЗаписи.СуммаРасход;
	КонецЕсли;
	
	Возврат СуммаРасход;
	
КонецФункции

Функция ПолучитьЛимит() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЛимитДенежныхСредств.Сумма КАК Сумма
		|ИЗ
		|	РегистрСведений.ЛимитДенежныхСредств.СрезПоследних КАК ЛимитДенежныхСредств";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	ВыборкаДетальныеЗаписи.Следующий();
	
	Если ВыборкаДетальныеЗаписи.Сумма = Неопределено Тогда
		Сумма = 0;
	Иначе
		Сумма = ВыборкаДетальныеЗаписи.Сумма;
	КонецЕсли;
	
	Возврат Сумма;
	
КонецФункции

Функция ПолучитьСуммуПоОставшимсяДням(Сумма, Дата) Экспорт
	
	ДатаОкончанияПериода = ОбщегоНазначенияКлиентСервер.ПолучитьДатуОкончанияПериода(Дата);
	
	КоличествоДней = ОбщегоНазначенияСервер.РазностьДат(Дата, ДатаОкончанияПериода, "ДЕНЬ");
	
	Если КоличествоДней = 0 Тогда
		Возврат 0;
	КонецЕсли;
	
	ЛимитНаДень = ПолучитьЛимитНаДень();
	НаДеньПоСумме = Цел(Сумма / КоличествоДней);
	
	Возврат Мин(ЛимитНаДень, НаДеньПоСумме) * КоличествоДней;
	
КонецФункции                                            

Функция ПолучитьОстатокДенежныхСредств() Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ОстаткиДенежныхСредствОстатки.СуммаОстаток
		|ИЗ
		|	РегистрНакопления.ДенежныеСредства.Остатки КАК ОстаткиДенежныхСредствОстатки";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	ВыборкаДетальныеЗаписи.Следующий();
	
	Если ВыборкаДетальныеЗаписи.СуммаОстаток = Неопределено Тогда
		СуммаОстаток = 0;
	Иначе
		СуммаОстаток = ВыборкаДетальныеЗаписи.СуммаОстаток;
	КонецЕсли;
	
	Возврат СуммаОстаток;
	
КонецФункции

Функция РассчитатьФактическийОстатокЛимитаДенежныхСредствНаПериод() Экспорт
	
	ОстатокЛимита = ПолучитьОстатокЛимитаДенежныхСредств();
	
	ДатаНачалаПериода = ОбщегоНазначенияКлиентСервер.ПолучитьДатуНачалаПериода(ОбщегоНазначенияСервер.ПолучитьИспользуемуюДату());
	
	ПоследняяДатаРасчета = Константы.ПоследняяДатаРасчетаФактическогоОстаткаЛимита.Получить();
	
	Если ДатаНачалаПериода = ПоследняяДатаРасчета Тогда
		Возврат ОстатокЛимита;
	КонецЕсли;
	
	ЛимитДенежныхСредств = ПолучитьЛимит();
	ТекущийОстаток = ПолучитьОстатокДенежныхСредств();
	НовыйОстатокЛимита = ЛимитДенежныхСредств + ОстатокЛимита;
	Если НовыйОстатокЛимита > ТекущийОстаток Тогда
		Если ТекущийОстаток > ОстатокЛимита Тогда
			ДобавитьКорректировкуРегистраОстатокЛимитаДенежныхСредств(ТекущийОстаток - ОстатокЛимита, ВидДвиженияНакопления.Приход);
		ИначеЕсли ТекущийОстаток < ОстатокЛимита Тогда
			ДобавитьКорректировкуРегистраОстатокЛимитаДенежныхСредств(ОстатокЛимита - ТекущийОстаток, ВидДвиженияНакопления.Расход);	
		КонецЕсли;
	ИначеЕсли НовыйОстатокЛимита <= ТекущийОстаток Тогда
		ДобавитьКорректировкуРегистраОстатокЛимитаДенежныхСредств(НовыйОстатокЛимита - ОстатокЛимита, ВидДвиженияНакопления.Приход);
	КонецЕсли;
	
	Константы.ПоследняяДатаРасчетаФактическогоОстаткаЛимита.Установить(ДатаНачалаПериода);
	
	ОстатокЛимита = ПолучитьОстатокЛимитаДенежныхСредств();
	
	Возврат ОстатокЛимита;
	
КонецФункции

Функция ПолучитьПланируемыеРасходаЗаПериод(ДатаНачалаПериода = Неопределено, ДатаОкончанияПериода = Неопределено) Экспорт
	
	Если ДатаНачалаПериода = Неопределено Тогда
		ДатаНачалаПериода = ОбщегоНазначенияКлиентСервер.ПолучитьДатуНачалаПериода(ОбщегоНазначенияСервер.ПолучитьИспользуемуюДату());
	КонецЕсли;
	
	Если ДатаОкончанияПериода = Неопределено Тогда
		ДатаОкончанияПериода = ОбщегоНазначенияКлиентСервер.ПолучитьДатуОкончанияПериода(ОбщегоНазначенияСервер.ПолучитьИспользуемуюДату());
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПланируемыеОстаткиДенежныхСредствОбороты.СуммаОборот КАК СуммаОборот
		|ИЗ
		|	РегистрНакопления.ПланируемыеОстаткиДенежныхСредств.Обороты(&ДатаНачала, &ДатаОкончания, , ) КАК ПланируемыеОстаткиДенежныхСредствОбороты";
	
	Запрос.УстановитьПараметр("ДатаНачала", ДатаНачалаПериода);
	Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончанияПериода);
	
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

#КонецОбласти

#Область СлужебныеПроцедурыФункции

Функция ПолучитьЛимитНаДень()
	
	ДатаНачалаПериода = ОбщегоНазначенияКлиентСервер.ПолучитьДатуНачалаПериода(ОбщегоНазначенияСервер.ПолучитьИспользуемуюДату());
	ДатаОкончанияПериода = ОбщегоНазначенияКлиентСервер.ПолучитьДатуОкончанияПериода(ОбщегоНазначенияСервер.ПолучитьИспользуемуюДату());
	
	КоличествоДней = ОбщегоНазначенияСервер.РазностьДат(ДатаНачалаПериода, ДатаОкончанияПериода, "ДЕНЬ") + 1;
	
	ЛимитНаПериод = ПолучитьЛимит();
	
	ЛимитНаДень = Цел(ЛимитНаПериод / КоличествоДней);
	
	Возврат ЛимитНаДень;
	
КонецФункции               

Процедура ДобавитьКорректировкуРегистраОстатокЛимитаДенежныхСредств(Сумма, ВидДвижения)
	
	Если Сумма = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДокументКорректировки = Документы.КорректировкаРегистров.СоздатьДокумент();
	ДокументКорректировки.Дата = ОбщегоНазначенияСервер.ПолучитьИспользуемуюДату();
	ДокументКорректировки.Записать();
	
	НаборЗаписей = РегистрыНакопления.ОстатокЛимитаДенежныхСредств.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Регистратор.Установить(ДокументКорректировки.Ссылка);
	НаборЗаписей.Прочитать();
	
	Запись = НаборЗаписей.Добавить();
	Запись.Период = ДокументКорректировки.Дата;
	Запись.Регистратор = ДокументКорректировки.Ссылка;
	Запись.ВидДвижения = ВидДвижения;
	Запись.Сумма = Сумма;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

#КонецОбласти
