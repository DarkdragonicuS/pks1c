// Универсальные механизмы интеграции ИС (ЕГАИС, ГИСМ, ВЕТИС, ...)

#Область ПрограммныйИнтерфейс

Функция ПоляДляПоискаМаркированнойПродукции() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Номенклатура",   ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка"));
	Результат.Вставить("Характеристика", ПредопределенноеЗначение("Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка"));
	Результат.Вставить("Серия",          ПредопределенноеЗначение("Справочник.СерииНоменклатуры.ПустаяСсылка"));
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ВключитьПоддержкуВидовПродукцииИС(Контекст, ПараметрыСканирования, ВидПродукции) Экспорт
	
	Если ТипЗнч(Контекст) = Тип("УправляемаяФорма") Тогда
		
		Если СтрНачинаетсяС(Контекст.ИмяФормы, "Документ.ЧекККМ") Тогда
			
			ЗаполнитьПараметрыСканированияЧекККМ(Контекст, ПараметрыСканирования, ВидПродукции, Ложь);
			
		ИначеЕсли СтрНачинаетсяС(Контекст.ИмяФормы, "Документ.ЧекККМВозврат") Тогда
			
			ЗаполнитьПараметрыСканированияЧекККМВозврат(Контекст, ПараметрыСканирования, ВидПродукции, Ложь);
			
		ИначеЕсли СтрНачинаетсяС(Контекст.ИмяФормы, "Документ.РеализацияТоваровУслуг") Тогда
			
			ЗаполнитьПараметрыСканированияРеализацияТоваровУслуг(Контекст, ПараметрыСканирования, ВидПродукции);
			
		ИначеЕсли СтрНачинаетсяС(Контекст.ИмяФормы, "Документ.ВозвратТоваровОтКлиента") Тогда
			
			ЗаполнитьПараметрыСканированияВозвратТоваровОтКлиента(Контекст, ПараметрыСканирования, ВидПродукции);
			
		ИначеЕсли СтрНачинаетсяС(Контекст.ИмяФормы, "Документ.ПриобретениеТоваровУслуг") Тогда
			
			ЗаполнитьПараметрыСканированияПриобретениеТоваровУслуг(Контекст, ПараметрыСканирования, ВидПродукции);
			
		ИначеЕсли СтрНачинаетсяС(Контекст.ИмяФормы, "Документ.ВозвратТоваровПоставщику") Тогда
			
			ЗаполнитьПараметрыСканированияВозвратТоваровПоставщику(Контекст, ПараметрыСканирования, ВидПродукции);
			
		ИначеЕсли СтрНачинаетсяС(Контекст.ИмяФормы, "Документ.ПеремещениеТоваров") Тогда
			
			ЗаполнитьПараметрыСканированияПеремещениеТоваров(Контекст, ПараметрыСканирования, ВидПродукции);
			
		ИначеЕсли СтрНачинаетсяС(Контекст.ИмяФормы, "Документ.КорректировкаРеализации") Тогда
			
			ЗаполнитьПараметрыСканированияКорректировкаРеализации(Контекст, ПараметрыСканирования, ВидПродукции);
			
		ИначеЕсли СтрНачинаетсяС(Контекст.ИмяФормы, "ОбщаяФорма.ПроверкаЗаполненияДокументов") Тогда
			
			Если ТипЗнч(Контекст.Ссылка) = Тип("ДокументСсылка.ЧекККМ") Тогда
				
				ЗаполнитьПараметрыСканированияЧекККМ(Контекст, ПараметрыСканирования, ВидПродукции);
				
			ИначеЕсли ТипЗнч(Контекст.Ссылка) = Тип("ДокументСсылка.ЧекККМВозврат") Тогда
				
				ЗаполнитьПараметрыСканированияЧекККМВозврат(Контекст, ПараметрыСканирования, ВидПродукции);
				
			ИначеЕсли ТипЗнч(Контекст.Ссылка) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
				
				ЗаполнитьПараметрыСканированияРеализацияТоваровУслуг(Контекст.Ссылка, ПараметрыСканирования, ВидПродукции);
				
			ИначеЕсли ТипЗнч(Контекст.Ссылка) = Тип("ДокументСсылка.ВозвратТоваровОтКлиента") Тогда
				
				ЗаполнитьПараметрыСканированияВозвратТоваровОтКлиента(Контекст.Ссылка, ПараметрыСканирования, ВидПродукции);
				
			ИначеЕсли ТипЗнч(Контекст.Ссылка) = Тип("ДокументСсылка.ПриобретениеТоваровУслуг") Тогда
				
				ЗаполнитьПараметрыСканированияПриобретениеТоваровУслуг(Контекст.Ссылка, ПараметрыСканирования, ВидПродукции);
				
			ИначеЕсли ТипЗнч(Контекст.Ссылка) = Тип("ДокументСсылка.ВозвратТоваровПоставщику") Тогда
				
				ЗаполнитьПараметрыСканированияВозвратТоваровПоставщику(Контекст.Ссылка, ПараметрыСканирования, ВидПродукции);
				
			ИначеЕсли ТипЗнч(Контекст.Ссылка) = Тип("ДокументСсылка.ПеремещениеТоваров") Тогда
				
				ЗаполнитьПараметрыСканированияПеремещениеТоваров(Контекст.Ссылка, ПараметрыСканирования, ВидПродукции);
				
			ИначеЕсли ТипЗнч(Контекст.Ссылка) = Тип("ДокументСсылка.КорректировкаРеализации") Тогда
				
				ЗаполнитьПараметрыСканированияКорректировкаРеализации(Контекст.Ссылка, ПараметрыСканирования, ВидПродукции);
				
			КонецЕсли;
		КонецЕсли;
	
	ИначеЕсли ТипЗнч(Контекст) = Тип("ДокументСсылка.ПриобретениеТоваровУслуг")Тогда 
		
		ЗаполнитьПараметрыСканированияПриобретениеТоваровУслуг(Контекст, ПараметрыСканирования, ВидПродукции);
		
	ИначеЕсли ТипЗнч(Контекст) = Тип("ДокументСсылка.ВозвратТоваровПоставщику") Тогда
		
		ЗаполнитьПараметрыСканированияВозвратТоваровПоставщику(Контекст, ПараметрыСканирования, ВидПродукции);
		
	ИначеЕсли ТипЗнч(Контекст) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
		
		ЗаполнитьПараметрыСканированияРеализацияТоваровУслуг(Контекст, ПараметрыСканирования, ВидПродукции);
		
	ИначеЕсли ТипЗнч(Контекст) = Тип("ДокументСсылка.ВозвратТоваровОтКлиента") Тогда
		
		ЗаполнитьПараметрыСканированияВозвратТоваровОтКлиента(Контекст, ПараметрыСканирования, ВидПродукции);
		
	ИначеЕсли ТипЗнч(Контекст) = Тип("ДокументСсылка.КорректировкаРеализации") Тогда
		
		ЗаполнитьПараметрыСканированияКорректировкаРеализации(Контекст, ПараметрыСканирования, ВидПродукции);
		
	ИначеЕсли ТипЗнч(Контекст) = Тип("ДокументСсылка.ПеремещениеТоваров") Тогда
		
		ЗаполнитьПараметрыСканированияПеремещениеТоваров(Контекст, ПараметрыСканирования, ВидПродукции);
		
	ИначеЕсли ТипЗнч(Контекст) = Тип("ДокументСсылка.ЧекККМ") Тогда // до оф.выпуска библиотеки
		
		ЗаполнитьПараметрыСканированияЧекККМ(Контекст, ПараметрыСканирования, ВидПродукции, Ложь);
		
	ИначеЕсли ТипЗнч(Контекст.Ссылка) = Тип("ДокументСсылка.ЧекККМВозврат") Тогда // до оф.выпуска библиотеки
				
		ЗаполнитьПараметрыСканированияЧекККМВозврат(Контекст, ПараметрыСканирования, ВидПродукции);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПараметрыСканированияЧекККМ(Контекст, ПараметрыСканирования, ВидПродукции, ПроверкаКоличества = Неопределено)
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Контекст, "Объект") Тогда
		ИсточникДанных = Контекст.Объект;
	Иначе
		ИсточникДанных = Контекст;
	КонецЕсли;
	
	#Область ПоддержкаАлкогольнойПродукции
	Если ШтрихкодированиеИСКлиентСервер.ВключитьПоддержкуАлкогольнойПродукции(ПараметрыСканирования, ВидПродукции) Тогда
		
		ПараметрыСканирования.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.ВНаличии"));
		ПараметрыСканирования.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.ПустаяСсылка"));
		
		ПараметрыСканирования.КонтрольАкцизныхМарок         = Истина;
		ПараметрыСканирования.Операция                      = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЧекККМ");
		ПараметрыСканирования.ОперацияКонтроляАкцизныхМарок = "Продажа";
		ПараметрыСканирования.ОрганизацияЕГАИС              = ИсточникДанных.ОрганизацияЕГАИС;
		ПараметрыСканирования.СоздаватьШтрихкодУпаковки     = Истина;
		
		Если ПроверкаКоличества = Истина Тогда
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("Штрихкод");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("Помещение");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("НоменклатураНабора");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("ХарактеристикаНабора");
		Иначе
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("Цена");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("СтавкаНДС");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("Штрихкод");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("Продавец");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("Помещение");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("НоменклатураНабора");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("ХарактеристикаНабора");
		КонецЕсли;
		
	КонецЕсли;
	
	#КонецОбласти
	
	#Область ПоддержкаТабачнойПродукции
	
	Если ШтрихкодированиеИСКлиентСервер.ВключитьПоддержкуТабачнойПродукции(ПараметрыСканирования, ВидПродукции) Тогда
	
		ПараметрыСканирования.ДопустимыеСтатусыМОТП.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.ВведенВОборот"));
		ПараметрыСканирования.ДопустимыеСтатусыМОТП.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.Нанесен"));
		
		ПараметрыСканирования.Организация                                = ИсточникДанных.Организация;
		ПараметрыСканирования.Склад                                      = ИсточникДанных.Склад;
		
		Если ТипЗнч(Контекст) = Тип("УправляемаяФорма") Тогда // до оф.выпуска библиотеки
			ПараметрыСканирования.ЗапрашиватьСтатусыМОТП                     = Контекст.КонтролироватьСтатусыКодовМаркировкиВРозницеМОТП;
			ПараметрыСканирования.ЗапрашиватьДанныеНеизвестныхШтрихкодовМОТП = Контекст.КонтролироватьСтатусыКодовМаркировкиВРозницеМОТП;
		КонецЕсли;
		
	КонецЕсли;
	
	#КонецОбласти
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыСканированияЧекККМВозврат(Контекст, ПараметрыСканирования, ВидПродукции, ПроверкаКоличества = Неопределено)
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Контекст, "Объект") Тогда
		ИсточникДанных = Контекст.Объект;
	Иначе
		ИсточникДанных = Контекст.Ссылка;
	КонецЕсли;
	
	Если ШтрихкодированиеИСКлиентСервер.ВключитьПоддержкуАлкогольнойПродукции(ПараметрыСканирования, ВидПродукции) Тогда
	
		ПараметрыСканирования.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.Реализована"));
		ПараметрыСканирования.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.ПустаяСсылка"));
		
		ПараметрыСканирования.КонтрольАкцизныхМарок         = Истина;
		ПараметрыСканирования.Операция                      = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЧекККМ");
		ПараметрыСканирования.ОперацияКонтроляАкцизныхМарок = "Возврат";
		ПараметрыСканирования.ОрганизацияЕГАИС              = ИсточникДанных.ОрганизацияЕГАИС;
		ПараметрыСканирования.СоздаватьШтрихкодУпаковки     = Истина;
		
		Если ПроверкаКоличества Тогда
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("Штрихкод");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("Помещение");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("НоменклатураНабора");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("ХарактеристикаНабора");
		Иначе
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("Цена");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("СтавкаНДС");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("Штрихкод");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("Продавец");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("Помещение");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("НоменклатураНабора");
			ПараметрыСканирования.КлючевыеРеквизиты.Добавить("ХарактеристикаНабора");
		КонецЕсли;
	
	КонецЕсли;
	
	Если ШтрихкодированиеИСКлиентСервер.ВключитьПоддержкуТабачнойПродукции(ПараметрыСканирования, ВидПродукции) Тогда
		
		ПараметрыСканирования.ДопустимыеСтатусыМОТП.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.Продан"));
		Если ТипЗнч(Контекст) = Тип("УправляемаяФорма") Тогда // до оф.выпуска библиотеки
			ПараметрыСканирования.ЗапрашиватьСтатусыМОТП                     = Контекст.КонтролироватьСтатусыКодовМаркировкиВРозницеМОТП;
			ПараметрыСканирования.ЗапрашиватьДанныеНеизвестныхШтрихкодовМОТП = Контекст.КонтролироватьСтатусыКодовМаркировкиВРозницеМОТП;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыСканированияРеализацияТоваровУслуг(Контекст, ПараметрыСканирования, ВидПродукции)
	
	Если ШтрихкодированиеИСКлиентСервер.ВключитьПоддержкуТабачнойПродукции(ПараметрыСканирования, ВидПродукции) Тогда
		
		ПараметрыСканирования.ДопустимыеСтатусыМОТП.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.ВведенВОборот"));
		ПараметрыСканирования.ДопустимыеСтатусыМОТП.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.Нанесен"));
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыСканированияКорректировкаРеализации(Контекст, ПараметрыСканирования, ВидПродукции)
	
	Если ШтрихкодированиеИСКлиентСервер.ВключитьПоддержкуТабачнойПродукции(ПараметрыСканирования, ВидПродукции) Тогда
		
		ПараметрыСканирования.ДопустимыеСтатусыМОТП.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.ВведенВОборот"));
		ПараметрыСканирования.ДопустимыеСтатусыМОТП.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.Нанесен"));
		ПараметрыСканирования.ДопустимыеСтатусыМОТП.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.Продан"));
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыСканированияВозвратТоваровОтКлиента(Контекст, ПараметрыСканирования, ВидПродукции)
	
	Если ШтрихкодированиеИСКлиентСервер.ВключитьПоддержкуТабачнойПродукции(ПараметрыСканирования, ВидПродукции) Тогда
		
		ПараметрыСканирования.ДопустимыеСтатусыМОТП.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.Продан"));
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыСканированияПриобретениеТоваровУслуг(Контекст, ПараметрыСканирования, ВидПродукции)
	
	Если ШтрихкодированиеИСКлиентСервер.ВключитьПоддержкуТабачнойПродукции(ПараметрыСканирования, ВидПродукции) Тогда
		
		ПараметрыСканирования.ДопустимыеСтатусыМОТП.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.ВведенВОборот"));
		ПараметрыСканирования.ДопустимыеСтатусыМОТП.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.Нанесен"));
		ПараметрыСканирования.СопоставлятьНоменклатуру               = Ложь;
		ПараметрыСканирования.ЗаписыватьНеизвестныеШтрихкодыУпаковок = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыСканированияВозвратТоваровПоставщику(Контекст, ПараметрыСканирования, ВидПродукции)
	
	Если ШтрихкодированиеИСКлиентСервер.ВключитьПоддержкуТабачнойПродукции(ПараметрыСканирования, ВидПродукции) Тогда
		
		ПараметрыСканирования.ДопустимыеСтатусыМОТП.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.ВведенВОборот"));
		ПараметрыСканирования.ДопустимыеСтатусыМОТП.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.Нанесен"));
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыСканированияПеремещениеТоваров(Контекст, ПараметрыСканирования, ВидПродукции)
	
	Если ШтрихкодированиеИСКлиентСервер.ВключитьПоддержкуТабачнойПродукции(ПараметрыСканирования, ВидПродукции) Тогда
		
		ПараметрыСканирования.ДопустимыеСтатусыМОТП.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.ВведенВОборот"));
		ПараметрыСканирования.ДопустимыеСтатусыМОТП.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыКодовМаркировкиМОТП.Нанесен"));
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

