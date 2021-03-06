
#Область ПрограммныйИнтерфейс

// Получение строк таблицы из буфера обмена.
//
// Параметры:
//   ДополнительныеПараметры - Структура - параметры для получения, состав:
//     * УникальныйИдентификатор - УникальныйИдентификатор - идентификатор формы.
//
// Возвращаемое значение:
//   ТаблицаЗначений - строки, полученные из буфера обмена.
//
Функция ПолучитьСтрокиИзБуфераОбмена(ДополнительныеПараметры) Экспорт

	ТаблицаТоваров = КопированиеСтрокСервер.ПолучитьСтрокиИзБуфераОбмена();
	
	МассивДляПолученияЕдиницИзмерения = Новый Массив;
	Для Каждого СтрокаТовара Из ТаблицаТоваров Цикл
		Если Не ЗначениеЗаполнено(СтрокаТовара.Упаковка) Тогда
			МассивДляПолученияЕдиницИзмерения.Добавить(СтрокаТовара.Номенклатура);
		КонецЕсли;
	КонецЦикла;
	
	Если МассивДляПолученияЕдиницИзмерения.Количество() Тогда
		ЕдиницыИзмеренияНоменклатуры = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(МассивДляПолученияЕдиницИзмерения,
			"ЕдиницаИзмерения");
		Для Каждого ЭлементСоответствия Из ЕдиницыИзмеренияНоменклатуры Цикл
			СтрокиТоваров = ТаблицаТоваров.НайтиСтроки(Новый Структура("Номенклатура, Упаковка",
				ЭлементСоответствия.Ключ, Справочники.УпаковкиЕдиницыИзмерения.ПустаяСсылка()));
			Для Каждого СтрокаТоваров Из СтрокиТоваров Цикл
				СтрокаТоваров.Упаковка = ЭлементСоответствия.Значение;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
	Возврат ОбщегоНазначения.ТаблицаЗначенийВМассив(ТаблицаТоваров);
	
КонецФункции

#КонецОбласти
