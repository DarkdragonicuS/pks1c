#Область СлужебныйПрограммныйИнтерфейс

Процедура ДополнитьСтруктуруКэшируемыеЗначения(КэшированныеЗначения) Экспорт

	//++ Локализация

	КэшированныеЗначения.Вставить("ПризнакиКатегорииЭксплуатации", Новый Соответствие);
	СтруктураПустойКатегории = Новый Структура;
	СтруктураПустойКатегории.Вставить("СрокЭксплуатации", 0);
	СтруктураПустойКатегории.Вставить("СтатьяРасходов", ПредопределенноеЗначение("ПланВидовХарактеристик.СтатьиРасходов.ПустаяСсылка"));
	КэшированныеЗначения.ПризнакиКатегорииЭксплуатации.Вставить(ПредопределенноеЗначение("Справочник.КатегорииЭксплуатации.ПустаяСсылка"), СтруктураПустойКатегории);
	
	
	//-- Локализация
	
КонецПроцедуры

#Область Локализация

//++ Локализация

// Заполняет признаки категории эксплуатации в текущей строке табличной части документа.
//
// Параметры:
//	ТекущаяСтрока - Структура - структура со свойствами строки документа.
//	СтруктураДействий - Структура - структура с действиями, которые нужно произвести.
//	КэшированныеЗначения - Структура - Кэшированные значения табличной части.
//
Процедура ЗаполнитьПризнакиКатегорииЭксплуатации(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения) Экспорт
	
	Если СтруктураДействий.Свойство("ЗаполнитьПризнакиКатегорииЭксплуатации") Тогда
		
		СтруктураПризнаков = КэшированныеЗначения.ПризнакиКатегорииЭксплуатации.Получить(
			ТекущаяСтрока.КатегорияЭксплуатации);
			
	#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
		Если СтруктураПризнаков = Неопределено Тогда
			СтруктураПризнаков = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
				ТекущаяСтрока.КатегорияЭксплуатации,
				"ИнвентарныйУчет, СпособПогашенияСтоимостиБУ, СрокЭксплуатации, СтатьяРасходов");
			КэшированныеЗначения.ПризнакиКатегорииЭксплуатации.Вставить(
				ТекущаяСтрока.КатегорияЭксплуатации,
				СтруктураПризнаков);
		КонецЕсли;
	#КонецЕсли
		
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, СтруктураПризнаков);
		
	КонецЕсли;
	
КонецПроцедуры


//-- Локализация

#КонецОбласти

#КонецОбласти
