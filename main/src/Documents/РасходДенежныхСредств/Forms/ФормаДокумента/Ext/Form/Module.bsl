﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УправлениеФормой();
	
	Если Параметры.Ключ.Пустая() И Объект.ВидРасхода = Перечисления.ВидыРасходов.Планируемый Тогда
		Объект.ВидПовторяемогоСобытий = Перечисления.ВидыПовторяемыхСобытий.ПовторятьЧерезНесколькоДней;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Параметры.Ключ.Пустая() Тогда
		Если ТипЗнч(ВладелецФормы) = Тип("ТаблицаФормы") Тогда
			Объект.Дата = ВладелецФормы.Родитель.ДатаНачалаПериода;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ПодтверждениеСуммыРасходаПриПереводеПланаВФакт" Тогда
		Объект.Сумма = Параметр;
		ПодтвердитьФактическийРасходЗавершение();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодтвердитьФактическийРасход(Команда)
	
	СписокКнопок = Новый СписокЗначений;
	СписокКнопок.Добавить("Подтвердить", "Подтвердить");
	СписокКнопок.Добавить("ИзменитьСумму", "Изменить сумму");
	СписокКнопок.Добавить("Отмена", "Отмена");
	
	ШаблонВопроса = НСтр("ru = 'Подтвердить факт расхода на сумму %1?'");
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонВопроса, Объект.Сумма);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПодтвердитьФактичекийРасходОтветНаВопрос", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, СписокКнопок, 60);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Результат = ПроверитьПревышениеЛимитаЗаПериод();
	
	Если Результат.ЛимитПревышен Тогда
		
		ШаблонВопроса = НСтр("ru = 'Лимит денежных средств на период с %1 по %2 превышен на %3. Все равно записать?'");
		
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонВопроса,
			Формат(ОбщегоНазначенияКлиентСервер.ПолучитьДатуНачалаПериода(Объект.Дата), "ДЛФ=DD"),
			Формат(ОбщегоНазначенияКлиентСервер.ПолучитьДатуОкончанияПериода(Объект.Дата), "ДЛФ=DD"),
			Результат.СуммаПревышения);
		
		ОписаниеОповещения = Новый ОписаниеОповещения("РезультатВопросаЗаписиДокумента", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена, 60);
		
	Иначе	
		
		НачатьЗаписьДокумента();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиЭлементовФормы

&НаКлиенте
Процедура ДатаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	УчетДенежныхСредствКлиент.ОткрытьФормуВыбораДаты(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НазначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДобавитьГолосовоеНазначение();
	
КонецПроцедуры

&НаКлиенте
Процедура ПовторяемоеСобытиеПриИзменении(Элемент)
	
	Объект.УИДПовторяемыхСобытий = Новый УникальныйИдентификатор;
	
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидПовторяемогоСобытийПриИзменении(Элемент)
	
	УправлениеФормой();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыФункции

&НаКлиенте
Процедура ПодтвердитьФактичекийРасходОтветНаВопрос(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = "Подтвердить" Тогда
		ПодтвердитьФактическийРасходЗавершение();
	ИначеЕсли РезультатВопроса = "ИзменитьСумму" Тогда
		ОткрытьФорму("Документ.РасходДенежныхСредств.Форма.ФормаИзмененияСуммы",, ЭтаФорма,
			,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодтвердитьФактическийРасходЗавершение()
	
	Объект.ВидРасхода = ПредопределенноеЗначение("Перечисление.ВидыРасходов.Фактический");
	НачатьЗаписьДокумента();
	
КонецПроцедуры
	
&НаСервере
Процедура УправлениеФормой()
	
	ЭтоПланируемыйРасход = Объект.ВидРасхода = Перечисления.ВидыРасходов.Планируемый;
	ЭтоНовыйДокумент = Параметры.Ключ.Пустая();
	ЭтоПовторяемоеСобытие = Объект.ПовторяемоеСобытие;
	ЭтоПовторЧерезНесколькоДней = Объект.ВидПовторяемогоСобытий = Перечисления.ВидыПовторяемыхСобытий.ПовторятьЧерезНесколькоДней;
	
	ВидимостьПодтверждения = ЭтоПланируемыйРасход И Не ЭтоНовыйДокумент;
	
	Элементы.ПодтвердитьФактическийРасход.Видимость = ВидимостьПодтверждения;
	
	Если ЭтоПланируемыйРасход Тогда
		Заголовок = "Расход (план)";
	Иначе
		Заголовок = "Расход (факт)";	
	КонецЕсли;
	
	Если ЭтоНовыйДокумент Тогда
		Заголовок = Заголовок + " - новый";
	КонецЕсли;
	
	Элементы.ГруппаПовторяемыеСобытия.Видимость = ЭтоПланируемыйРасход;
	Элементы.ГруппаВидПовторяемогоСобытия.Видимость = ЭтоПовторяемоеСобытие;
	Элементы.ДатаОкончанияПовторяемыхСобытий.Видимость = ЭтоПовторяемоеСобытие;
	Элементы.КоличествоДнейДляПовторения.Видимость = ЭтоПовторяемоеСобытие И ЭтоПовторЧерезНесколькоДней;
	
КонецПроцедуры

&НаСервере
Функция ПроверитьПревышениеЛимитаЗаПериод()
	
	Результат = Новый Структура;
	Результат.Вставить("ЛимитПревышен", Ложь);
	Результат.Вставить("СуммаПревышения", 0);
	
	Если Не Объект.ВидРасхода = Перечисления.ВидыРасходов.Планируемый Тогда
		Возврат Результат;
	КонецЕсли;
	
	ЛимитНаПериод = УчетДенежныхСредствСервер.ПолучитьЛимит();
	
	ДатаНачалаПериода = ОбщегоНазначенияКлиентСервер.ПолучитьДатуНачалаПериода(Объект.Дата);
	ДатаОкончанияПериода = ОбщегоНазначенияКлиентСервер.ПолучитьДатуОкончанияПериода(Объект.Дата);
	
	ПланируемыеРасходы = УчетДенежныхСредствСервер.ПолучитьПланируемыеРасходаЗаПериод(ДатаНачалаПериода, ДатаОкончанияПериода);
	
	ПланируемыеРасходыСТекущимПланом = ПланируемыеРасходы + Объект.Сумма;
	
	СуммаПревышения = ПланируемыеРасходыСТекущимПланом - ЛимитНаПериод;
	
	Результат.ЛимитПревышен = СуммаПревышения > 0;
	Результат.СуммаПревышения = СуммаПревышения;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура РезультатВопросаЗаписиДокумента(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		Закрыть();
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Да Тогда
		НачатьЗаписьДокумента();
	КонецЕсли; 
	
КонецПроцедуры

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

&НаКлиенте
Процедура ДобавитьГолосовоеНазначение()
	
	#Если МобильноеПриложениеКлиент Тогда
	     	
		ЗапсукПриложения = Новый ЗапускПриложенияМобильногоУстройства;
		ЗапсукПриложения.Действие = "android.speech.action.RECOGNIZE_SPEECH";
		
		Если ЗапсукПриложения.ПоддерживаетсяЗапуск() Тогда
			ЗапсукПриложения.Запустить(Истина);
			Для каждого СтрокаДанных Из ЗапсукПриложения.ДополнительныеДанные Цикл
				Если СтрокаДанных.Ключ = "query" Тогда
					Объект.Назначение = СтрокаДанных.Значение;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	
	#КонецЕсли

КонецПроцедуры

#КонецОбласти