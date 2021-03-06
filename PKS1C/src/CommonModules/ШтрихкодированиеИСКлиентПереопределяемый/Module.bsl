#Область ПрограммныйИнтерфейс

// В процедуре нужно показать диалоговое окно для ввода штрихкода и передать полученные данные в описание оповещения.
//
// Параметры:
//  Оповещение - ОписаниеОповещения - процедура, которую нужно вызвать после ввода штрихкода.
//
Процедура ПоказатьВводШтрихкода(Оповещение) Экспорт
	
	//++ НЕ ГОСИС
	ШтрихкодированиеНоменклатурыКлиент.ПоказатьВводШтрихкода(Оповещение);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// В процедуре необходимо реализовать алгоритм обработки
//
// Параметры:
//  Форма - УправляемаяФорма - форма документа, в которой были обработаны штрихкоды,
//  ОбработанныеДанные - Структура - подготовленные ранее данные штрихкодов,
//  КэшированныеЗначения - Структура - используется механизмом обработки изменения реквизитов ТЧ.
Процедура ПослеОбработкиШтрихкодов(Форма, ОбработанныеДанные, КэшированныеЗначения) Экспорт
	
	//++ НЕ ГОСИС
	СтруктураДействий = ОбработанныеДанные;
	
	Если СтруктураДействий.НеизвестныеШтрихкоды.Количество() > 0 Тогда
		ДополнительныеПараметры = Новый Структура("Форма, КэшированныеЗначения", Форма, КэшированныеЗначения);
		ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьНеизвестныеШтрихкодыЗавершение", ШтрихкодированиеИСКлиент, ДополнительныеПараметры);
		РаботаСНоменклатуройКлиент.ОткрытьФормуПодбораНоменклатурыПоШтрихкодам(СтруктураДействий, Форма, ОписаниеОповещения);
	КонецЕсли;
	
	ПараметрыСканирования = ШтрихкодированиеИСКлиентСервер.ИнициализироватьПараметрыСканирования(Форма);
	Если ШтрихкодированиеИСКлиентСервер.ДопустимаАлкогольнаяПродукция(ПараметрыСканирования) Тогда
		ШтрихкодированиеНоменклатурыЕГАИСКлиентПереопределяемый.ОткрытьФормуСчитыванияАкцизнойМаркиПриНеобходимости(Форма, СтруктураДействий);
	КонецЕсли;
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

Процедура ОткрытьФормуПодбораНоменклатурыПоШтрихкодам(НеизвестныеШтрихкоды,
		ФормаВладелец = Неопределено, ОповещениеОЗакрытии = Неопределено) Экспорт
	
	СтруктураПараметров  = Новый Структура;
	СтруктураПараметров.Вставить("НеизвестныеШтрихкоды", НеизвестныеШтрихкоды);
	
	ОткрытьФорму("Обработка.РаботаСНоменклатурой.Форма.ПоискНоменклатурыПоШтрихкоду", 
		СтруктураПараметров, ФормаВладелец, Новый УникальныйИдентификатор, , , ОповещениеОЗакрытии);
	
КонецПроцедуры

Процедура ОчиститьКэшированныеШтрихкоды(ДанныеШтрихкодов, КэшированныеЗначения) Экспорт
	
	//++ НЕ ГОСИС
	КэшированныеЗначения.Штрихкоды.Очистить();
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Вызывается после загрузки данных из ТСД. В процедуре нужно проанализировать полученные штрихкоды на предмет сканирования акцизной марки, а также
// обработать штрихкоды, не привязанные к номенклатуре.
//
// Параметры:
//  Форма - УправляемаяФорма - форма документа, в которой были обработаны штрихкоды,
//  ОбработанныеДанные - Структура - подготовленные ранее данные штрихкодов,
//  КэшированныеЗначения - Структура - используется механизмом обработки изменения реквизитов ТЧ.
Процедура ПослеОбработкиТаблицыТоваровПолученнойИзТСД(Форма, ОбработанныеДанные, КэшированныеЗначения) Экспорт
	
	//++ НЕ ГОСИС
	СтруктураДействий = ОбработанныеДанные;
	
	ШтрихкодированиеНоменклатурыКлиент.ОбработатьНеизвестныеШтрихкоды(СтруктураДействий, КэшированныеЗначения, Форма);
	
	Если СтруктураДействий.ТекущаяСтрока <> Неопределено Тогда
		Форма.Элементы.Товары.ТекущаяСтрока = СтруктураДействий.ТекущаяСтрока;
	КонецЕсли;
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

Процедура ПодготовитьДанныеДляОбработкиТаблицыТоваровПолученнойИзТСД(
	Форма, ТаблицаТоваров, КэшированныеЗначения, ПараметрыЗаполнения, СтруктураДействий) Экспорт

	//++ НЕ ГОСИС
	ПараметрыСканирования = ШтрихкодированиеИСКлиентСервер.ИнициализироватьПараметрыСканирования(Форма);
	Если ШтрихкодированиеИСКлиентСервер.ДопустимаАлкогольнаяПродукция(ПараметрыСканирования) Тогда
		СтруктураДействий = Неопределено;
		ШтрихкодированиеНоменклатурыЕГАИСКлиентПереопределяемый.ПодготовитьДанныеДляОбработкиТаблицыТоваровПолученнойИзТСД(
			ЭтотОбъект,
			ТаблицаТоваров,
			КэшированныеЗначения,
			ПараметрыЗаполнения,
			СтруктураДействий);
	КонецЕсли;
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

Процедура ЗаполнитьПолноеИмяФормыУказанияСерии(ПолноеИмяФормыУказанияСерии) Экспорт
	
	//++ НЕ ГОСИС
	ПолноеИмяФормыУказанияСерии = "Обработка.ПодборСерийВДокументы.Форма.УказаниеСерииВСтрокеТоваров";
	//-- НЕ ГОСИС
	
КонецПроцедуры

#КонецОбласти
