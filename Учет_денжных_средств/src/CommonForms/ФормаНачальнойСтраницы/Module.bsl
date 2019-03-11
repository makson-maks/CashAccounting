
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ТекущийОстатокДенежныхСредств = ПолучитьОстаткиДенежныхСредств();

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "ИзмененОстатокДенежныхСредств" Тогда
		ТекущийОстатокДенежныхСредств = ПолучитьОстаткиДенежныхСредств();
	КонецЕсли;	

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ДекорацияРасходыНажатие(Элемент)

	ОткрытьФорму("Документ.РасходДенежныхСредств.ФормаСписка");	

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
		|	РегистрНакопления.ОстаткиДенежныхСредств.Остатки КАК ОстаткиДенежныхСредствОстатки";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	ВыборкаДетальныеЗаписи.Следующий();
	
	Возврат ВыборкаДетальныеЗаписи.СуммаОстаток;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьОстатокЛимитаДенежныхСредств()

	ЛимитДС = Константы.ЛимитДенежныхСредств.Получить();
	
	 

КонецФункции

#КонецОбласти

