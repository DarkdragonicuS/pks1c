
Процедура ТалонНаРемонт(ТабДок, Ссылка) Экспорт
	//{{_КОНСТРУКТОР_ПЕЧАТИ(ТалонНаРемонт)
	Макет = Документы.ЗаявкаНаРемонт.ПолучитьМакет("ТалонНаРемонт");
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗаявкаНаРемонт.IMEI,
	|	ЗаявкаНаРемонт.ВидОборудования,
	|	ЗаявкаНаРемонт.Дата,
	|	ЗаявкаНаРемонт.Клиент.Контрагент.НаименованиеПолное КАК Клиент,
	|	ЗаявкаНаРемонт.Модель,
	|	ЗаявкаНаРемонт.Номер,
	|	ЗаявкаНаРемонт.ПретензииКРаботе,
	|	ЗаявкаНаРемонт.Производитель,
	|	ЗаявкаНаРемонт.СерийныйНомер,
	|	ЗаявкаНаРемонт.ТехническийПредставитель,
	|	ЗаявкаНаРемонт.Характеристика,
	|	ЗаявкаНаРемонт.ЗИПиУслуги.(
	|		НомерСтроки,
	|		Номенклатура,
	|		Количество,
	|		Цена,
	|		Сумма
	|	),
	|	ЗаявкаНаРемонт.Оплата.(
	|		Оплата,
	|		ДатаПлатежа
	|	),
	|	ЗаявкаНаРемонт.Клиент.НомерТелефона КАК Телефон,
	|	ЗаявкаНаРемонт.НахождениеУстройства,
	|	ЗаявкаНаРемонт.БлокПитания,
	|	ЗаявкаНаРемонт.СумкаИлиЧехол
	|ИЗ
	|	Документ.ЗаявкаНаРемонт КАК ЗаявкаНаРемонт
	|ГДЕ
	|	ЗаявкаНаРемонт.Ссылка В(&Ссылка)";
	Запрос.Параметры.Вставить("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();

	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	Шапка = Макет.ПолучитьОбласть("Шапка");
	//ОбластьЗИПиУслугиШапка = Макет.ПолучитьОбласть("ЗИПиУслугиШапка");
	//ОбластьЗИПиУслуги = Макет.ПолучитьОбласть("ЗИПиУслуги");
	ОбластьОплатаШапка = Макет.ПолучитьОбласть("ОплатаШапка");
	ОбластьОплата = Макет.ПолучитьОбласть("Оплата");
	
	ОбластьКлиентШапка = Макет.ПолучитьОбласть("КлиентШапка");
//	ОбластьКлиент = Макет.ПолучитьОбласть("Клиент");
	
	Подвал = Макет.ПолучитьОбласть("Подвал");

	ТабДок.Очистить();

	ВставлятьРазделительСтраниц = Ложь;
	Пока Выборка.Следующий() Цикл
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;

		ТабДок.Вывести(ОбластьЗаголовок);

		Шапка.Параметры.Заполнить(Выборка);
		ТабДок.Вывести(Шапка, Выборка.Уровень());

		//ТабДок.Вывести(ОбластьЗИПиУслугиШапка);
		//ВыборкаЗИПиУслуги = Выборка.ЗИПиУслуги.Выбрать();
		//Пока ВыборкаЗИПиУслуги.Следующий() Цикл
		//	ОбластьЗИПиУслуги.Параметры.Заполнить(ВыборкаЗИПиУслуги);
		//	ТабДок.Вывести(ОбластьЗИПиУслуги, ВыборкаЗИПиУслуги.Уровень());
		//КонецЦикла;
		ОбластьКлиентШапка.Параметры.Заполнить(Выборка);
		ТабДок.Вывести(ОбластьКлиентШапка);
		//ВыборкаКлиент = Выборка.Телефон;
		//Пока ВыборкаКлиент.Следующий() Цикл
		//	ОбластьКлиент.Параметры.Заполнить(ВыборкаКлиент);
		//	ТабДок.Вывести(ОбластьКлиент, ВыборкаКлиент.Уровень());
		//КонецЦикла;

		
		
		ТабДок.Вывести(ОбластьОплатаШапка);
		ВыборкаОплата = Выборка.Оплата.Выбрать();
		Пока ВыборкаОплата.Следующий() Цикл
			ОбластьОплата.Параметры.Заполнить(ВыборкаОплата);
			ТабДок.Вывести(ОбластьОплата, ВыборкаОплата.Уровень());
		КонецЦикла;

		Подвал.Параметры.Заполнить(Выборка);
		ТабДок.Вывести(Подвал);

		ВставлятьРазделительСтраниц = Истина;
	КонецЦикла;
	//}}
КонецПроцедуры

Процедура АктВыполненныхРабот(ТабДок, Ссылка) Экспорт
	//{{_КОНСТРУКТОР_ПЕЧАТИ(АктВыполненныхРабот)
	Макет = Документы.ЗаявкаНаРемонт.ПолучитьМакет("АктВыполненныхРабот");
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗаявкаНаРемонт.IMEI КАК IMEI,
	|	ЗаявкаНаРемонт.ВидОборудования КАК ВидОборудования,
	|	ЗаявкаНаРемонт.Дата КАК Дата,
	|	ЗаявкаНаРемонт.Клиент.Контрагент.НаименованиеПолное КАК Клиент,
	|	ЗаявкаНаРемонт.Модель КАК Модель,
	|	ЗаявкаНаРемонт.Номер КАК Номер,
	|	ЗаявкаНаРемонт.Производитель КАК Производитель,
	|	ЗаявкаНаРемонт.СерийныйНомер КАК СерийныйНомер,
	|	ЗаявкаНаРемонт.Склад КАК Склад,
	|	ЗаявкаНаРемонт.СтатусЗаявки КАК СтатусЗаявки,
	|	ЗаявкаНаРемонт.СуммаОплат КАК СуммаОплат,
	|	ЗаявкаНаРемонт.ТехническийПредставитель КАК ТехническийПредставитель,
	|	ЗаявкаНаРемонт.Характеристика КАК Свойство,
	|	ЗаявкаНаРемонт.Оплата.(
	|		Оплата КАК Оплата,
	|		ДатаПлатежа КАК ДатаПлатежа
	|	) КАК Оплата,
	|	ЗаявкаНаРемонт.ЗИПиУслуги.(
	|		НомерСтроки КАК НомерСтроки,
	|		Номенклатура КАК Номенклатура,
	|		Количество КАК Количество,
	|		Цена КАК Цена,
	|		Сумма КАК Сумма
	|	) КАК ЗИПиУслуги
	|ИЗ
	|	Документ.ЗаявкаНаРемонт КАК ЗаявкаНаРемонт
	|ГДЕ
	|	ЗаявкаНаРемонт.Ссылка В(&Ссылка)";
	Запрос.Параметры.Вставить("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();

	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	Шапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьЗИПиУслугиШапка = Макет.ПолучитьОбласть("ЗИПиУслугиШапка");
	ОбластьЗИПиУслуги = Макет.ПолучитьОбласть("ЗИПиУслуги");
	ОбластьОплатаШапка = Макет.ПолучитьОбласть("ОплатаШапка");
	ОбластьОплата = Макет.ПолучитьОбласть("Оплата");
	Подвал = Макет.ПолучитьОбласть("Подвал");
	ТабДок.Очистить();

	ВставлятьРазделительСтраниц = Ложь;
	Пока Выборка.Следующий() Цикл
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;

		ТабДок.Вывести(ОбластьЗаголовок);

		Шапка.Параметры.Заполнить(Выборка);
		ТабДок.Вывести(Шапка, Выборка.Уровень());

		ТабДок.Вывести(ОбластьОплатаШапка);
		ВыборкаОплата = Выборка.Оплата.Выбрать();
		Пока ВыборкаОплата.Следующий() Цикл
			ОбластьОплата.Параметры.Заполнить(ВыборкаОплата);
			ТабДок.Вывести(ОбластьОплата, ВыборкаОплата.Уровень());
		КонецЦикла;		
		
		ТабДок.Вывести(ОбластьЗИПиУслугиШапка);
		ВыборкаЗИПиУслуги = Выборка.ЗИПиУслуги.Выбрать();
		Пока ВыборкаЗИПиУслуги.Следующий() Цикл
			ОбластьЗИПиУслуги.Параметры.Заполнить(ВыборкаЗИПиУслуги);
			ТабДок.Вывести(ОбластьЗИПиУслуги, ВыборкаЗИПиУслуги.Уровень());
		КонецЦикла;
		


		Подвал.Параметры.Заполнить(Выборка);
		ТабДок.Вывести(Подвал);

		ВставлятьРазделительСтраниц = Истина;
	КонецЦикла;
	//}}
КонецПроцедуры
