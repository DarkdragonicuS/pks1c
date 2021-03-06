
#Область ПрограммныйИнтерфейс

#Область ОбработчикиСобытийФормыИЭлементовШапки

// Вызывается из обработчика события ПриОткрытии формы отчета.
//
// Параметры:
//	Форма - УправляемаяФорма - Форма отчета.
//	Отказ - Булево - Признак отказа.
//
Процедура ПриОткрытии(Форма, Отказ) Экспорт
	
	РежимРасшифровки = Ложь;
	
	// Установка модифицированности пользовательских настроек
	// для их автоматического сохранения при закрытии формы.
	Если Форма.Отчет.Свойство("РежимРасшифровки") Тогда
		Форма.ПользовательскиеНастройкиМодифицированы = Не Форма.Отчет.РежимРасшифровки;
		РежимРасшифровки = Форма.Отчет.РежимРасшифровки;
	Иначе
		Форма.ПользовательскиеНастройкиМодифицированы = Истина;
	КонецЕсли;
	
	Попытка
		ОбщегоНазначенияБПКлиентСервер.УстановитьЗначениеПолеОрганизация(
			Форма.ПолеОрганизация, Форма.Отчет.Организация, Форма.Отчет.ВключатьОбособленныеПодразделения);
	Исключение
		// Запись в журнал регистрации не требуется.
	КонецПопытки;
	
	Если Не РежимРасшифровки
		И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "ИдентификаторЗаданияАктуализации")
		И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "АдресХранилищаАктуализации") Тогда
		БухгалтерскийУчетКлиентПереопределяемый.ПодключитьПроверкуАктуальности(Форма);
	КонецЕсли;
	
КонецПроцедуры

// Вызывается из обработчика события ПередЗакрытием формы отчета.
//
// Параметры:
//	Форма - УправляемаяФорма - Форма отчета.
//	Отказ - Булево - Признак отказа.
//	ЗавершениеРаботы - Булево - Признак завершение работы с программой.
//	ТекстПредупреждения - Строка - Текст предупреждения при закрытии.
//	СтандартнаяОбработка - Булево - Признак стандартной обработки.
//
Процедура ПередЗакрытием(Форма, Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка) Экспорт
	
	// Структура отчета задается динамически, поэтому в сохранении Варианта нет необходимости.
	Форма.ВариантМодифицирован = Ложь;
	
КонецПроцедуры

// Вызывается из обработчика события ПриЗакрытии формы отчета.
//
// Параметры:
//	Форма - УправляемаяФорма - Форма отчета.
//	ЗавершениеРаботы - Булево - Признак завершения работы с программой.
//
Процедура ПриЗакрытии(Форма, ЗавершениеРаботы = Истина) Экспорт
	
	ОтменяемыеЗадания = БухгалтерскийУчетКлиентПереопределяемый.ЗаданияОтменяемыеПриЗакрытииОтчета();
	
	ИдентификаторыОтменяемыхЗаданий = Новый Массив;
	Для каждого РеквизитФормы Из ОтменяемыеЗадания Цикл
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, РеквизитФормы)
		   И ЗначениеЗаполнено(Форма[РеквизитФормы]) Тогда
			ИдентификаторыОтменяемыхЗаданий.Добавить(Форма[РеквизитФормы]);
		КонецЕсли;
	КонецЦикла; 
	
	Если ИдентификаторыОтменяемыхЗаданий.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗавершениеРаботы Тогда
		БухгалтерскиеОтчетыВызовСервера.ОтменитьВыполнениеЗаданий(ИдентификаторыОтменяемыхЗаданий);
	КонецЕсли;

	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "ИдентификаторЗаданияАктуализации")
	   И ЗначениеЗаполнено(Форма.ИдентификаторЗаданияАктуализации)
	   И Форма.Отчет.Свойство("Организация") Тогда
	   
		ПараметрыОповещения = Новый Структура("Организация", Форма.Отчет.Организация);
		Оповестить("АктуализацияОтменена", ПараметрыОповещения);
		
	КонецЕсли;
	
КонецПроцедуры

// Вызывается из обработчика события ПриИзменении поля организации.
//
// Параметры:
//	Форма - УправляемаяФорма - Форма отчета.
//	Элемент - ПолеФормы - Поле организации.
//
Процедура ОрганизацияПриИзменении(Форма, Элемент) Экспорт 
	
	БухгалтерскиеОтчетыКлиентСервер.ОрганизацияПриИзменении(Форма);
	
КонецПроцедуры

// Вызывается из обработчика события ПриИзменении поля подразделения.
//
// Параметры:
//	Форма - УправляемаяФорма - Форма отчета.
//	Элемент - ПолеФормы - Поле подразделения.
//
Процедура ПодразделениеПриИзменении(Форма, Элемент) Экспорт
	
	БухгалтерскиеОтчетыКлиентСервер.ПодразделениеПриИзменении(Форма);
	
КонецПроцедуры

#КонецОбласти


#Область ВспомогательныеПроцедурыИФункции

// Возвращает интервал начала формирования отчета после открытия формы.
//
// Возвращаемое значение:
//	Число - Интервал в секундах.
//
Функция ИнтервалЗапускаФормированияОтчетаПриОткрытии() Экспорт
	
	Возврат 0.1;
	
КонецФункции

// Вычисляет суммы выделенных ячеек табличного документа.
//
// Параметры:
//	ПолеСумма - Число - Сумма ячеек.
//	Результат - ТабличныйДокумент - Табличный документ с ячейками.
//	КэшВыделеннойОбласти - Структура - Содержит ранее рассчитанные значения ячеек.
//	НеобходимоВычислятьНаСервере - Булево - Признак того, что необходим вызов сервера.
//
Процедура ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(ПолеСумма, Результат, КэшВыделеннойОбласти, НеобходимоВычислятьНаСервере) Экспорт
	
	Если НеобходимоОбновитьСумму(Результат, КэшВыделеннойОбласти) Тогда
		ПолеСумма = 0;
		КоличествоВыделенныхОбластей = КэшВыделеннойОбласти.Количество();
		Если КоличествоВыделенныхОбластей = 0      // Ничего не выделено.
			ИЛИ КэшВыделеннойОбласти.Свойство("T") Тогда // Выделен весь табличный документ (Ctrl+A).
			КэшВыделеннойОбласти.Вставить("Сумма", 0);
		ИначеЕсли КоличествоВыделенныхОбластей = 1 Тогда
			// Если выделено небольшое количество ячеек, то получим сумму на клиенте.
			Для каждого КлючИЗначение Из КэшВыделеннойОбласти Цикл
				СтруктураАдресВыделеннойОбласти = КлючИЗначение.Значение;
			КонецЦикла;
			
			РазмерОбластиПоВертикали   = СтруктураАдресВыделеннойОбласти.Низ   - СтруктураАдресВыделеннойОбласти.Верх;
			РазмерОбластиПоГоризонтали = СтруктураАдресВыделеннойОбласти.Право - СтруктураАдресВыделеннойОбласти.Лево;
			
			// В некоторых отчетах показатели (да и аналитика на которую может встать пользователь)
			// выводятся в "объединенных" ячейках - не желательно в этом случае делать серверный вызов. 
			// Выделенная область из 10 ячеек закрывает все такие случае и скорее всего всегда будет доступна на клиенте.
			// Максимум, может быть сделан один неявный серверный вызов.
			ВычислитьНаКлиенте = (РазмерОбластиПоВертикали + РазмерОбластиПоГоризонтали) < 12;
			Если ВычислитьНаКлиенте Тогда
				СуммаВЯчейках = 0;
				Для ИндексСтрока = СтруктураАдресВыделеннойОбласти.Верх По СтруктураАдресВыделеннойОбласти.Низ Цикл
					Для ИндексКолонка = СтруктураАдресВыделеннойОбласти.Лево По СтруктураАдресВыделеннойОбласти.Право Цикл
						Попытка
							Ячейка = Результат.Область(ИндексСтрока, ИндексКолонка, ИндексСтрока, ИндексКолонка);
							Если Ячейка.Видимость = Истина Тогда
								Если Ячейка.СодержитЗначение И ТипЗнч(Ячейка.Значение) = Тип("Число") Тогда
									СуммаВЯчейках = СуммаВЯчейках + Ячейка.Значение;
								ИначеЕсли ЗначениеЗаполнено(Ячейка.Текст) Тогда
									ЧислоВЯчейке  = Число(СтроковыеФункцииКлиентСервер.ЗаменитьОдниСимволыДругими(Символ(32)+Символ(43), Ячейка.Текст, Символ(0)));
									СуммаВЯчейках = СуммаВЯчейках + ЧислоВЯчейке;
								КонецЕсли;
							КонецЕсли;
						Исключение
							// Запись в журнал регистрации не требуется.
						КонецПопытки;
					КонецЦикла;
				КонецЦикла;
				
				ПолеСумма = СуммаВЯчейках;
				КэшВыделеннойОбласти.Вставить("Сумма", ПолеСумма);
			Иначе
				// Если ячеек много, то лучше вычислим сумму ячеек на сервере за один вызов,
				// т.к. неявных серверных вызовов может быть гораздо больше.
				НеобходимоВычислятьНаСервере = Истина;
			КонецЕсли;
		Иначе
			// Вычислим сумму ячеек на сервере.
			НеобходимоВычислятьНаСервере = Истина;
		КонецЕсли;
	Иначе	
		ПолеСумма = КэшВыделеннойОбласти.Сумма;
	КонецЕсли;
	
КонецПроцедуры

// Обрабатывает полученный результат проверки актуальности закрытия месяца для вывода информации в отчет.
//
//	Параметры:
//		Результат - Структура - см. возвращаемое значение ДлительныеОперации.ВыполнитьВФоне();
//		Форма - УправляемаяФорма - форма отчета, имеет основной реквизит "Отчет".
//
Процедура ОбработатьРезультатПроверкиАктуальности(Результат, Форма) Экспорт

	Если Результат = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	РезультатПроверки = ПолучитьИзВременногоХранилища(Результат);
	УдалитьИзВременногоХранилища(Результат);
	Форма.АдресХранилищаАктуализации = "";

	Если РезультатПроверки.Свойство("Статус") И РезультатПроверки.Статус = "Ошибка" Тогда
		ВызватьИсключение РезультатПроверки.ПодробноеПредставлениеОшибки;
	КонецЕсли;
	
	Элементы = Форма.Элементы;
	
	Если ТипЗнч(РезультатПроверки) <> Тип("Структура") Тогда
		РезультатПроверки = Новый Структура;
	КонецЕсли;
	Если Не РезультатПроверки.Свойство("Состояние") Тогда
		РезультатПроверки.Вставить("Состояние", "НеТребуется");
	КонецЕсли;
		
	Если РезультатПроверки.Состояние = "НеТребуется" Тогда
		
		Элементы.Актуализация.Видимость = Ложь;
		Возврат;
		
	КонецЕсли;
	
	Если РезультатПроверки.Состояние = "Выполняется" Тогда
		ОтобразитьСостояниеАктуализации(Форма);
		Возврат;
	КонецЕсли;
	
	Форма.ДатаАктуальности = РезультатПроверки.ДатаАктуальности;
	МассивПодстрок = Новый Массив;
	ТекстДанныеУчетаНеАктуальны = НСтр("ru='Данные учета неактуальны по'") + " ";
	МассивПодстрок.Добавить(Новый ФорматированнаяСтрока(ТекстДанныеУчетаНеАктуальны));
	МассивПодстрок.Добавить(Новый ФорматированнаяСтрока(Формат(Форма.ДатаАктуальности, "ДЛФ=D"), Новый Шрифт(,, Истина)));
	МассивПодстрок.Добавить(Новый ФорматированнаяСтрока("."));
	
	МассивПодстрок.Добавить(Новый ФорматированнаяСтрока(" " + НСтр("ru='Рекомендуется выполнить'") + " "));
	МассивПодстрок.Добавить(Новый ФорматированнаяСтрока(НСтр("ru='закрытие месяца'"),,,, "e1cib/app/Обработка.ОперацииЗакрытияМесяца"));
	МассивПодстрок.Добавить(Новый ФорматированнаяСтрока(" " + НСтр("ru = 'и сформировать отчет повторно.'")));
	Элементы.ТекстПриНеобходимостиАктуализации.ОтображениеПодсказки = ОтображениеПодсказки.Нет;
	Элементы.ТекстПриНеобходимостиАктуализации.ВертикальноеПоложение = ВертикальноеПоложениеЭлемента.Низ;
	Элементы.СкрытьПриНеобходимостиАктуализации.ВертикальноеПоложение = ВертикальноеПоложениеЭлемента.Низ;

	Элементы.Актуализировать.Видимость = Ложь;
	Элементы.ТекстПриНеобходимостиАктуализации.Заголовок = Новый ФорматированнаяСтрока(МассивПодстрок);

	СброситьСостояниеАктуализации(Элементы);
	Элементы.ТребуетсяАктуализация.Видимость = Истина;
	Элементы.Актуализация.Видимость = Истина;
	
КонецПроцедуры

// Выводит на форму отчета информацию о том, что выполняется фоновое задание получения актуальности данных закрытия месяца.
//
//	Параметры:
//		Форма - УправляемаяФорма - форма отчета, имеет основной реквизит "Отчет".
//
Процедура ОтобразитьСостояниеАктуализации(Форма) Экспорт
	
	ИдетАктуализация = Истина;
	ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(Форма.ПараметрыОбработчикаОжиданияАктуализации);
	Форма.ПодключитьОбработчикОжидания("Подключаемый_ПроверитьЗавершениеАктуализации", Форма.ПараметрыОбработчикаОжиданияАктуализации.ТекущийИнтервал, Истина);
	
	Элементы = Форма.Элементы;
	Элементы.РисПриАктуализации.Видимость = ИдетАктуализация;
	
	Элементы.ТекстПриАктуализации.ВертикальноеПоложение = ВертикальноеПоложениеЭлемента.Центр;
	Элементы.СкрытьПриАктуализации.ВертикальноеПоложение = ВертикальноеПоложениеЭлемента.Центр;
	Элементы.ИдетАктуализация.ЦветФона = Новый Цвет;
	
	ТекстПриАктуализации = НСтр("ru='Данные этого отчета могут измениться.'");
	Элементы.ТекстПриАктуализации.Заголовок = ТекстПриАктуализации;
	
	СброситьСостояниеАктуализации(Элементы);
	Элементы.Актуализация.Видимость = Истина;
	Элементы.ИдетАктуализация.Видимость = Истина;
	
КонецПроцедуры

// Сбрасывает все данные по состоянию актуализации (используется когда данные закрытия месяца актуальны на дату отчета).
//
//	Параметры:
//		Элементы - КоллекцияЭлементовФормы - элементы формы, которые должны содержать:
//			* ИдетПроверкаАктуальности - ГруппаФормы - отображает факт выполнения проверки актуальности;
//			* ТребуетсяАктуализация - ГруппаФормы - отображает, что данные закрытия месяца не актуальны;
//			* ИдетАктуализация - ГруппаФормы - отображает, что сейчас выполняется операция закрытия месяца;
//			* ДанныеАктуализированы - ГруппаФормы - отображает факт актуальности данных.
//
Процедура СброситьСостояниеАктуализации(Элементы) Экспорт
	
	Элементы.ИдетПроверкаАктуальности.Видимость	= Ложь;
	Элементы.ТребуетсяАктуализация.Видимость	= Ложь;
	Элементы.ИдетАктуализация.Видимость			= Ложь;
	Элементы.ДанныеАктуализированы.Видимость	= Ложь;

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НеобходимоОбновитьСумму(Результат, КэшВыделеннойОбласти)
	Перем СтруктураАдресВыделеннойОбласти;
	
	ВыделенныеОбласти    = Результат.ВыделенныеОбласти;
	КоличествоВыделенных = ВыделенныеОбласти.Количество();
	
	Если КоличествоВыделенных = 0 Тогда
		КэшВыделеннойОбласти = Новый Структура();
		Возврат Истина;
	КонецЕсли;
	
	ВозвращаемоеЗначение = Ложь;
	Если ТипЗнч(КэшВыделеннойОбласти) <> Тип("Структура") Тогда
		КэшВыделеннойОбласти = Новый Структура();
		ВозвращаемоеЗначение = Истина;
	ИначеЕсли ВыделенныеОбласти.Количество() <> КэшВыделеннойОбласти.Количество() Тогда
		КэшВыделеннойОбласти = Новый Структура();
		ВозвращаемоеЗначение = Истина;
	Иначе
		Для ИндексОбласти = 0 По КоличествоВыделенных - 1 Цикл
			ВыделеннаяОбласть = ВыделенныеОбласти[ИндексОбласти];
			ИмяОбласти = СтрЗаменить(ВыделеннаяОбласть.Имя, ":", "_");
			КэшВыделеннойОбласти.Свойство(ИмяОбласти, СтруктураАдресВыделеннойОбласти);
			
			// Не нашли нужную область в кэше, поэтому переинициализируем кэш.
			Если ТипЗнч(СтруктураАдресВыделеннойОбласти) <> Тип("Структура") Тогда
				КэшВыделеннойОбласти = Новый Структура();
				ВозвращаемоеЗначение = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Для ИндексОбласти = 0 По КоличествоВыделенных - 1 Цикл
		ВыделеннаяОбласть = ВыделенныеОбласти[ИндексОбласти];
		ИмяОбласти = СтрЗаменить(ВыделеннаяОбласть.Имя, ":", "_");
		
		Если ТипЗнч(ВыделеннаяОбласть) <> Тип("ОбластьЯчеекТабличногоДокумента") Тогда
			СтруктураАдресВыделеннойОбласти = Новый Структура;
			СтруктураАдресВыделеннойОбласти.Вставить("Верх", 0);
			СтруктураАдресВыделеннойОбласти.Вставить("Низ",  0);
			СтруктураАдресВыделеннойОбласти.Вставить("Лево", 0);
			СтруктураАдресВыделеннойОбласти.Вставить("Право",0);
			КэшВыделеннойОбласти.Вставить(ИмяОбласти, СтруктураАдресВыделеннойОбласти);
			ВозвращаемоеЗначение = Истина;
			Продолжить;
		КонецЕсли;
		
		КэшВыделеннойОбласти.Свойство(ИмяОбласти, СтруктураАдресВыделеннойОбласти);
		Если ТипЗнч(СтруктураАдресВыделеннойОбласти) <> Тип("Структура") Тогда
			СтруктураАдресВыделеннойОбласти = Новый Структура;
			СтруктураАдресВыделеннойОбласти.Вставить("Верх", 0);
			СтруктураАдресВыделеннойОбласти.Вставить("Низ",  0);
			СтруктураАдресВыделеннойОбласти.Вставить("Лево", 0);
			СтруктураАдресВыделеннойОбласти.Вставить("Право",0);
			КэшВыделеннойОбласти.Вставить(ИмяОбласти, СтруктураАдресВыделеннойОбласти);
			ВозвращаемоеЗначение = Истина;
		КонецЕсли;
		
		Если СтруктураАдресВыделеннойОбласти.Верх <> ВыделеннаяОбласть.Верх
			ИЛИ СтруктураАдресВыделеннойОбласти.Низ <> ВыделеннаяОбласть.Низ
			ИЛИ СтруктураАдресВыделеннойОбласти.Лево <> ВыделеннаяОбласть.Лево
			ИЛИ СтруктураАдресВыделеннойОбласти.Право <> ВыделеннаяОбласть.Право Тогда
				СтруктураАдресВыделеннойОбласти = Новый Структура;
				СтруктураАдресВыделеннойОбласти.Вставить("Верх",  ВыделеннаяОбласть.Верх);
				СтруктураАдресВыделеннойОбласти.Вставить("Низ",   ВыделеннаяОбласть.Низ);
				СтруктураАдресВыделеннойОбласти.Вставить("Лево",  ВыделеннаяОбласть.Лево);
				СтруктураАдресВыделеннойОбласти.Вставить("Право", ВыделеннаяОбласть.Право);
				КэшВыделеннойОбласти.Вставить(ИмяОбласти, СтруктураАдресВыделеннойОбласти);
				ВозвращаемоеЗначение = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции


#КонецОбласти
