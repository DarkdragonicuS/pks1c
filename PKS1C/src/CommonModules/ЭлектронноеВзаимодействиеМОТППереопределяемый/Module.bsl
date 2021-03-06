
#Область ПрограммныйИнтерфейс

// (См. ЭлектронноеВзаимодействиеМОТП.ЗаполнитьСведенияОМаркировке)
//   Переопределяет заполнение сведений о маркировке. Установить СтандартнаяОбработка=Ложь для переопределенных вызовов.
// 
Процедура ЗаполнитьСведенияОМаркировке(Приемник, Источник, ДанныеШтрихкодовУпаковок, СтандартнаяОбработка) Экспорт
	
	Возврат;
	
КонецПроцедуры

// (См. ЭлектронноеВзаимодействиеМОТП.ЗаполнитьСведенияОМаркировке)
//   Переопределяет заполнение сведений о маркировке. Установить СтандартнаяОбработка=Ложь для переопределенных вызовов.
// 
Процедура ЗаполнитьСведенияОМаркировке_2019(Приемник, Источник, ДанныеШтрихкодовУпаковок, СтандартнаяОбработка) Экспорт
	
	Возврат;
	
КонецПроцедуры

Процедура ПроверитьМаркируемуюПродукциюДокумента(Ссылка, Отказ) Экспорт
	//++ НЕ ГОСИС
	ТипДокумента = ТипЗнч(Ссылка);
	Если ТипДокумента = Тип("ДокументСсылка.РеализацияТоваровУслуг")
		ИЛИ ТипДокумента = Тип("ДокументСсылка.ВозвратТоваровПоставщику")
		ИЛИ ТипДокумента = Тип("ДокументСсылка.КорректировкаРеализации") Тогда 
		Отказ = Отказ ИЛИ НЕ ИнтеграцияМОТП.ДанныеДокументаСоответствуютДаннымУпаковок(Ссылка);
	КонецЕсли;
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти
