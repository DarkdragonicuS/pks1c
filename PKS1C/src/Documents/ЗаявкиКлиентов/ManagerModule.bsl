
//Процедура Печать(ТабДок, Ссылка) Экспорт
//	//{{_КОНСТРУКТОР_ПЕЧАТИ(Печать)
//	Макет = Документы.ЗаявкиКлиентов.ПолучитьМакет("Печать");
//	Запрос = Новый Запрос;
//	Запрос.Текст =
//	"ВЫБРАТЬ
//	|	ЗаявкиКлиентов.Дата,
//	|	ЗаявкиКлиентов.ДатаЗакрытия,
//	|	ЗаявкиКлиентов.ДатаОткрытия,
//	|	ЗаявкиКлиентов.Клиент,
//	|	ЗаявкиКлиентов.Комментарий,
//	|	ЗаявкиКлиентов.КонтактноеЛицо,
//	|	ЗаявкиКлиентов.КонтактныйТелефон,
//	|	ЗаявкиКлиентов.Номер,
//	|	ЗаявкиКлиентов.ОтветственноеЛицо,
//	|	ЗаявкиКлиентов.ПлановаяДатаРешения,
//	|	ЗаявкиКлиентов.Почта,
//	|	ЗаявкиКлиентов.Приоритет,
//	|	ЗаявкиКлиентов.Решение,
//	|	ЗаявкиКлиентов.Статус,
//	|	ЗаявкиКлиентов.ТекстЗаявки,
//	|	ЗаявкиКлиентов.ТемаЗаявки,
//	|	ЗаявкиКлиентов.ТипЗаявки
//	|ИЗ
//	|	Документ.ЗаявкиКлиентов КАК ЗаявкиКлиентов
//	|ГДЕ
//	|	ЗаявкиКлиентов.Ссылка В (&Ссылка)";
//	Запрос.Параметры.Вставить("Ссылка", Ссылка);
//	Выборка = Запрос.Выполнить().Выбрать();
//
//	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
//	Шапка = Макет.ПолучитьОбласть("Шапка");
//	ТабДок.Очистить();
//
//	ВставлятьРазделительСтраниц = Ложь;
//	Пока Выборка.Следующий() Цикл
//		Если ВставлятьРазделительСтраниц Тогда
//			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
//		КонецЕсли;
//
//		ТабДок.Вывести(ОбластьЗаголовок);
//
//		Шапка.Параметры.Заполнить(Выборка);
//		ТабДок.Вывести(Шапка, Выборка.Уровень());
//
//		ВставлятьРазделительСтраниц = Истина;
//	КонецЦикла;
//	//}}
//КонецПроцедуры

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов - Массив - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати - СписокЗначений - значение - ссылка на объект;
//                                            представление - имя области, в которой был выведен объект (выходной параметр);
//  ПараметрыВывода - Структура - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	НужноПечататьМакет = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "АктВызова");
    Если НужноПечататьМакет Тогда
        УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
        КоллекцияПечатныхФорм,
        "АктВызова",
        НСтр("ru = 'Акт вызова'"),
        ПечатьАктаВызова(МассивОбъектов, ОбъектыПечати),
        ,
        "Документ.ЗаявкиКлиентов.АктВызова");
    КонецЕсли;
КонецПроцедуры

Функция ПечатьАктаВызова(МассивОбъектов, ОбъектыПечати)
	// Создаем табличный документ и устанавливаем имя параметров печати.
    ТабличныйДокумент = Новый ТабличныйДокумент;
    ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_АктВызова";
    // Получаем запросом необходимые данные.
    Запрос = Новый Запрос();
    Запрос.Текст =
    "ВЫБРАТЬ
    |	ЗаявкиКлиентов.Ссылка Как Ссылка,
    |	ЗаявкиКлиентов.ТекстЗаявки КАК ТекстЗаявки,
    |	ЗаявкиКлиентов.Номер КАК НомерЗаявки,
    |	ЗаявкиКлиентов.ОтветственноеЛицо КАК ОтветственноеЛицо,
    |	ЗаявкиКлиентов.Клиент.Контрагент.НаименованиеПолное + "" / "" + ЗаявкиКлиентов.Клиент.Контрагент.ИНН Как Заказчик,
    |	ЗаявкиКлиентов.Приоритет = ЗНАЧЕНИЕ(Перечисление.ПриоритетыЗаявок.Срочно) Как ЭкстренныйВыезд,
    |	ЗаявкиКлиентов.Клиент Как Клиент,
    |	ЗаявкиКлиентов.ТемаЗаявки
    |ИЗ
    |	Документ.ЗаявкиКлиентов КАК ЗаявкиКлиентов
    |ГДЕ
    |	ЗаявкиКлиентов.Ссылка В (&МассивОбъектов)";
    Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
    Шапка = Запрос.Выполнить().Выбрать();
    
    ПервыйДокумент = Истина;
    Пока Шапка.Следующий() Цикл
        Если Не ПервыйДокумент Тогда
            // Все документы нужно выводить на разных страницах.
            ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
        КонецЕсли;
        ПервыйДокумент = Ложь;
        // Запомним номер строки, с которой начали выводить текущий документ.
        НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
        // В табличном документе необходимо задать имя области, в которую был 
        // выведен объект. Нужно для возможности печати комплектов документов.
        ЗапросАдреса = Новый Запрос();
	    ЗапросАдреса.Текст =
	    "ВЫБРАТЬ
	    |	КлиентыКонтактнаяИнформация.Представление
	    |ИЗ
	    |	Справочник.Клиенты.КонтактнаяИнформация КАК КлиентыКонтактнаяИнформация
	    |ГДЕ
	    |	КлиентыКонтактнаяИнформация.Ссылка = &Клиент
	    |	И КлиентыКонтактнаяИнформация.Тип = &Тип
	    |	И КлиентыКонтактнаяИнформация.Вид = &Вид";
	    ЗапросАдреса.УстановитьПараметр("Клиент", Шапка.Клиент);
	    ЗапросАдреса.УстановитьПараметр("Тип", Перечисления.ТипыКонтактнойИнформации.Адрес);
	    ЗапросАдреса.УстановитьПараметр("Вид", Справочники.ВидыКонтактнойИнформации.АдресКлиента);
	    ВыборкаАдрес = ЗапросАдреса.Выполнить().Выбрать();
	    Адрес = "";
        Если ВыборкаАдрес.Следующий() Тогда
      		Адрес = ВыборкаАдрес.Представление;
        КонецЕсли;        
        Исполнитель = ФизическиеЛицаУТ.ФамилияИнициалыФизЛица(Шапка.ОтветственноеЛицо);
        ЗаявленнаяНеисправность = Шапка.ТекстЗаявки.Получить().ПолучитьТекст();
        Если Не ЗначениеЗаполнено(ЗаявленнаяНеисправность) Тогда
        	ЗаявленнаяНеисправность = Шапка.ТемаЗаявки;
        КонецЕсли;
        
        ПараметрыМакета = Новый Структура();
        ПараметрыМакета.Вставить("ДатаЗаявки",Формат(ТекущаяДата(),"ДФ='dd MMMM yyyy ""г.""';"));
        ПараметрыМакета.Вставить("ЗаявленнаяНеисправность",ЗаявленнаяНеисправность);
        ПараметрыМакета.Вставить("Заказчик",Шапка.Заказчик);      
        ПараметрыМакета.Вставить("ЭкстренныйВыезд",?(Шапка.ЭкстренныйВыезд,"Экстренный выезд",""));
        ПараметрыМакета.Вставить("Адрес",Адрес); 
        ПараметрыМакета.Вставить("ВыполненныеРаботы","");
        ПараметрыМакета.Вставить("Исполнитель", Исполнитель);
        
        Макет = ПолучитьМакет("АктВызова");
        
        ОбластьШапка = Макет.ПолучитьОбласть("Шапка");    	
    	ОбластьСтрокаЗаказчик = Макет.ПолучитьОбласть("СтрокаЗаказчик");
    	ОбластьСтрокаНадписьАдрес = Макет.ПолучитьОбласть("СтрокаНадписьАдрес");
    	ОбластьСтрокаАдрес = Макет.ПолучитьОбласть("СтрокаАдрес");
    	ОбластьСтрокаПериодРабот = Макет.ПолучитьОбласть("СтрокаПериодРабот");
    	ОбластьСтрокаНадписьЗаявленнаяНеисправность = Макет.ПолучитьОбласть("СтрокаНадписьЗаявленнаяНеисправность");
    	ОбластьСтрокаЗаявленнаяНеисправность = Макет.ПолучитьОбласть("СтрокаЗаявленнаяНеисправность");
    	ОбластьСтрокаНадписьВыполненныеРаботы = Макет.ПолучитьОбласть("СтрокаНадписьВыполненныеРаботы");
    	ОбластьСтрокаВыполненныеРаботы = Макет.ПолучитьОбласть("СтрокаВыполлненныеРаботы");
    	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
    	ОбластьЛинияОтреза = Макет.ПолучитьОбласть("ЛинияОтреза");
    	ОбластьРукописныйВвод = Макет.ПолучитьОбласть("РукописныйВвод");
    	
    	ЗаполнитьЗначенияСвойств(ОбластьШапка.Параметры,ПараметрыМакета);
    	ЗаполнитьЗначенияСвойств(ОбластьСтрокаЗаказчик.Параметры,ПараметрыМакета);
    	ЗаполнитьЗначенияСвойств(ОбластьСтрокаАдрес.Параметры,ПараметрыМакета);
    	ЗаполнитьЗначенияСвойств(ОбластьСтрокаПериодРабот.Параметры,ПараметрыМакета);
    	ЗаполнитьЗначенияСвойств(ОбластьСтрокаЗаявленнаяНеисправность.Параметры,ПараметрыМакета);
    	ЗаполнитьЗначенияСвойств(ОбластьСтрокаВыполненныеРаботы.Параметры,ПараметрыМакета);
    	ЗаполнитьЗначенияСвойств(ОбластьПодвал.Параметры,ПараметрыМакета);
    	ЗаполнитьЗначенияСвойств(ОбластьПодвал.Параметры,ПараметрыМакета);
    	
    	Если Не ЗначениеЗаполнено(ПараметрыМакета.Адрес) Тогда
    		ОбластьСтрокаАдрес.Очистить();
    		ОбластьСтрокаАдрес.Вывести(ОбластьРукописныйВвод);
    		ОбластьСтрокаАдрес.Вывести(ОбластьРукописныйВвод);
    	КонецЕсли;
    	Если Не ЗначениеЗаполнено(ПараметрыМакета.ЗаявленнаяНеисправность) Тогда
    		ОбластьСтрокаЗаявленнаяНеисправность.Очистить();
    		ОбластьСтрокаЗаявленнаяНеисправность.Вывести(ОбластьРукописныйВвод);
    		ОбластьСтрокаЗаявленнаяНеисправность.Вывести(ОбластьРукописныйВвод);
    		ОбластьСтрокаЗаявленнаяНеисправность.Вывести(ОбластьРукописныйВвод);
    	КонецЕсли;
    	Если Не ЗначениеЗаполнено(ПараметрыМакета.ВыполненныеРаботы) Тогда
    		ОбластьСтрокаВыполненныеРаботы.Очистить();
    		ОбластьСтрокаВыполненныеРаботы.Вывести(ОбластьРукописныйВвод);
    		ОбластьСтрокаВыполненныеРаботы.Вывести(ОбластьРукописныйВвод);
    		ОбластьСтрокаВыполненныеРаботы.Вывести(ОбластьРукописныйВвод);
    	КонецЕсли;
    	
    	ТабличныйДокумент.Вывести(ОбластьШапка);
    	ТабличныйДокумент.Вывести(ОбластьСтрокаЗаказчик);
    	ТабличныйДокумент.Вывести(ОбластьСтрокаНадписьАдрес);
    	ТабличныйДокумент.Вывести(ОбластьСтрокаАдрес);
    	ТабличныйДокумент.Вывести(ОбластьСтрокаПериодРабот);
    	ТабличныйДокумент.Вывести(ОбластьСтрокаНадписьЗаявленнаяНеисправность);
    	ТабличныйДокумент.Вывести(ОбластьСтрокаЗаявленнаяНеисправность);
    	ТабличныйДокумент.Вывести(ОбластьСтрокаНадписьВыполненныеРаботы);
    	ТабличныйДокумент.Вывести(ОбластьСтрокаВыполненныеРаботы);
    	ТабличныйДокумент.Вывести(ОбластьПодвал);
    	
    	ТабличныйДокумент.Вывести(ОбластьЛинияОтреза);
    	
		ТабличныйДокумент.Вывести(ОбластьШапка);
    	ТабличныйДокумент.Вывести(ОбластьСтрокаЗаказчик);
    	ТабличныйДокумент.Вывести(ОбластьСтрокаНадписьАдрес);
    	ТабличныйДокумент.Вывести(ОбластьСтрокаАдрес);
    	ТабличныйДокумент.Вывести(ОбластьСтрокаПериодРабот);
    	ТабличныйДокумент.Вывести(ОбластьСтрокаНадписьЗаявленнаяНеисправность);
    	ТабличныйДокумент.Вывести(ОбластьСтрокаЗаявленнаяНеисправность);
    	ТабличныйДокумент.Вывести(ОбластьСтрокаНадписьВыполненныеРаботы);
    	ТабличныйДокумент.Вывести(ОбластьСтрокаВыполненныеРаботы);
    	ТабличныйДокумент.Вывести(ОбластьПодвал);
    	
        УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, 
            НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
    КонецЦикла;
    Возврат ТабличныйДокумент;
КонецФункции

#Область ПрограммныйИнтерфейс
// Заполняет список команд печати.
// Параметры:
// КомандыПечати - ТаблицаЗначений - состав полей см. в функции управлениеПечатью.СоздатьКоллекциюКомандПечати.

Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт   
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Документ.ЗаявкиКлиентов";  
	КомандаПечати.Идентификатор = "АктВызова";
	КомандаПечати.Представление = НСтр("ru = 'Акт вызова'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь; 
КонецПроцедуры
#КонецОбласти