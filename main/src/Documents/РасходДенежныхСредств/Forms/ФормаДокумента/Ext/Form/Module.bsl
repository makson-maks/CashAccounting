﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Параметры.Ключ.Пустая() Тогда
		Если ТипЗнч(ВладелецФормы) = Тип("ТаблицаФормы") Тогда
			Объект.Дата = ВладелецФормы.Родитель.ДатаНачалаПериода;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодтвердитьФактическийРасход(Команда)
	
	Объект.ВидРасхода = ПредопределенноеЗначение("Перечисление.ВидыРасходов.Фактический");
	Записать();
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьГолосовоеНазначение(Команда)
	
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

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
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

#КонецОбласти

#Область СлужебныеПроцедурыФункции

&НаСервере
Процедура УправлениеФормой()
	
	Элементы.ПодтвердитьФактическийРасход.Видимость = Объект.ВидРасхода = Перечисления.ВидыРасходов.Планируемый;
	
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
	ОбъектДокумента.Записать(РежимЗаписиДокумента.Проведение);
	ЗначениеВРеквизитФормы(ОбъектДокумента, "Объект");
	
КонецПроцедуры

#КонецОбласти