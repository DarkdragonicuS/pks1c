//Фиксирует автора изменений документа
Процедура УстановитьИзменениеДокумента(Документ,Дата=Неопределено) Экспорт
	Если Дата=Неопределено Тогда
		ДатаИзменения = ТекущаяДата();
	Иначе
		ДатаИзменения = Дата;
	КонецЕсли;
	НаборЗаписей = РегистрыСведений.ИсторияИзмененийДокументов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Документ.Установить(Документ);
	НаборЗаписей.Отбор.Период.Установить(ДатаИзменения);
	
	Запись = НаборЗаписей.Добавить();
	Запись.Период = ДатаИзменения;
	Запись.Документ = Документ;
	Запись.Автор = Пользователи.АвторизованныйПользователь();
	НаборЗаписей.Записать();
КонецПроцедуры