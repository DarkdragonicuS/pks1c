
#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриОткрытииФормы() Экспорт 
	
	Если НЕ ЭтоРазделенныйСеанс() Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПриложения["ТехнологияСервиса.РаботаВМоделиСервиса.РасширенияВМоделиСервиса.ФормаОповещений"] = ЭтотОбъект;
		
	ЭтотПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	
	ОткрытьФорму("Обработка.КаталогРасширений.Форма.ФормаУстановленныеРасширения",,,,,,, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
	ПодключитьОбработчикОжидания("ПроверитьНаличеНовыхОповещений", 30);
		
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьНаличеНовыхОповещений() Экспорт 
	
	ДанныеДляОповещения = ПроверитьНаличеНовыхОповещенийНаСервере(); 
	
	Для Каждого Оповещение Из ДанныеДляОповещения Цикл
		
		Если Оповещение.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияРасширений.Установлено") Тогда
			Текст = НСтр("ru = 'Установка расширения завершена'");
			СостояниеДоп = НСтр("ru = 'установлено'");
		Иначе 
			Текст = НСтр("ru = 'Удаление расширения завершено'");	
			СостояниеДоп = НСтр("ru = 'удалено'");
		КонецЕсли;
		
		Пояснение = СтрШаблон(НСтр("ru = 'Расширение ""%1"" %2, необходимо перезапустить приложение'"), Оповещение.Расширение, СостояниеДоп);
		Описание = Новый ОписаниеОповещения("ОбработатьПерезапуск", ЭтотОбъект, Оповещение);
			
		ПоказатьОповещениеПользователя(Текст, Описание, Пояснение, БиблиотекаКартинок.Успешно32, СтатусОповещенияПользователя.Важное, Оповещение.ИдентификаторРасширения) 		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПроверитьНаличеНовыхОповещенийНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ОчередьРасширенийДляОповещений.ИдентификаторРасширения КАК ИдентификаторРасширения,
	               |	ОчередьРасширенийДляОповещений.Пользователь КАК Пользователь,
	               |	ОчередьРасширенийДляОповещений.Состояние КАК Состояние
	               |ИЗ
	               |	РегистрСведений.ОчередьРасширенийДляОповещений КАК ОчередьРасширенийДляОповещений
	               |ГДЕ
	               |	ОчередьРасширенийДляОповещений.Пользователь = &Пользователь
	               |	И ОчередьРасширенийДляОповещений.Состояние В (ЗНАЧЕНИЕ(Перечисление.СостоянияРасширений.Установлено), ЗНАЧЕНИЕ(Перечисление.СостоянияРасширений.Удалено))";
	
	Запрос.УстановитьПараметр("Пользователь", ЭтотПользователь);
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	
	МассивДанных = Новый Массив;
	
	Пока Выборка.Следующий() Цикл
		
		Расширение = Справочники.ПоставляемыеРасширения.ПолучитьСсылку(Выборка.ИдентификаторРасширения);
		
		ДанныеОповещения = Новый Структура;
		ДанныеОповещения.Вставить("ИдентификаторРасширения", Выборка.ИдентификаторРасширения);
		ДанныеОповещения.Вставить("Расширение", Расширение);
		ДанныеОповещения.Вставить("Состояние", Выборка.Состояние);
		
		МассивДанных.Добавить(ДанныеОповещения);

	КонецЦикла;
	
	Возврат МассивДанных;
	
КонецФункции

&НаКлиенте
Процедура ОбработатьПерезапуск(Оповещение) Экспорт 
	
	Если Оповещение.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияРасширений.Установлено") Тогда
		СостояниеДоп = НСтр("ru = 'установлено'");
	Иначе 
		СостояниеДоп = НСтр("ru = 'удалено'");
	КонецЕсли;
	
	Вопрос = СтрШаблон(НСтр("ru = 'Расширение ""%1"" %2, перезапустить приложение?'"), Оповещение.Расширение, СостояниеДоп);
	Описание = Новый ОписаниеОповещения("ОбработатьПерезапускОтвет", ЭтотОбъект);
	
	ПоказатьВопрос(Описание, Вопрос, РежимДиалогаВопрос.ДаНет,,, НСтр("ru = 'Перезапуск приложения'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьПерезапускОтвет(Ответ, ДопПараметры) Экспорт 
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ЗавершитьРаботуСистемы(Ложь, Истина);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЭтоРазделенныйСеанс()
	
	Возврат РаботаВМоделиСервиса.ИспользованиеРазделителяСеанса();
	
КонецФункции

#КонецОбласти



