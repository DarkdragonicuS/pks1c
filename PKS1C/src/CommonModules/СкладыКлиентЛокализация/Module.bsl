
#Область СлужебныйПрограммныйИнтерфейс

Процедура ПриВыполненииКоманды_ПанельСправочниковСклад(Команда, Форма) Экспорт

	//++ Локализация
	
	Элементы = Форма.Элементы;
	
	Если Команда.Имя = Элементы.ОткрытьКатегорииЭксплуатации.Имя Тогда
		ОткрытьФорму("Справочник.КатегорииЭксплуатации.ФормаСписка", , Форма);
	КонецЕсли; 
	
	//-- Локализация
	
КонецПроцедуры

#КонецОбласти

