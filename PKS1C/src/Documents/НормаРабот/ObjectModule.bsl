
Процедура ОбработкаПроведения(Отказ, Режим)
	//{{__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	// регистр НормаРабот
	Движения.НормаРабот.Записывать = Истина;
	Движение = Движения.НормаРабот.Добавить();
	Движение.Период = Дата;
	Движение.Работник = Работник;
	Движение.СуточнаяНорма = СуточнаяНорма;
	Движение.МесячнаяНорма = МесячнаяНорма;

	//}}__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
КонецПроцедуры


Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Автор = Пользователи.АвторизованныйПользователь();
КонецПроцедуры


Процедура ПриЗаписи(Отказ)
	//Фиксация в истории изменений
	АутсорсФункцииДокументовСервер.УстановитьИзменениеДокумента(ЭтотОбъект.Ссылка);
КонецПроцедуры
