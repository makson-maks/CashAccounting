
#Область ОбработчикиСобытийОбъекта

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	Движения.ОстаткиДенежныхСредств.Записывать = Истина;
	
	Движение = Движения.ОстаткиДенежныхСредств.ДобавитьРасход();
	Движение.Период = Дата;
	Движение.Сумма = Сумма;	

КонецПроцедуры

#КонецОбласти