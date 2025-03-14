
&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	Для Каждого Строка Из Строки Цикл
		Строка.Значение.Данные.Телефон = АутсорсКлиентыСервер.ТелефоныКонтактногоЛицаСтрокой(Строка.Значение.Данные.Ссылка); 
		Строка.Значение.Данные.Email = АутсорсКлиентыСервер.EmailКонтактногоЛицаСтрокой(Строка.Значение.Данные.Ссылка);
		Строка.Значение.Данные.Клиент = АутсорсКлиентыСервер.КлиентыКонтактногоЛицаСтрокой(Строка.Значение.Данные.Ссылка);
	КонецЦикла;
КонецПроцедуры

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьСписокСправочника" 
		И Параметр.Свойство("Отбор") И Параметр.Отбор.Свойство("Владелец")
		И ТипЗнч(Параметр.Отбор.Владелец) = Тип("СправочникСсылка.Партнеры") Тогда
		
			ЭлементыОтбора = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(
				ОбщегоНазначенияУТКлиентСервер.ПолучитьОтборДинамическогоСписка(Список), "Владелец");
			Если ЭлементыОтбора.Количество() > 0 
				И ЭлементыОтбора[0].ПравоеЗначение = Параметр.Отбор.Владелец Тогда
					Возврат;
			КонецЕсли;
		
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Владелец",
			                         Параметр.Отбор.Владелец, ВидСравненияКомпоновкиДанных.Равно,, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

