
Процедура ОбработкаПроведения(Отказ, Режим)
	//{{__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	// регистр ДатыКлючевыеНосители
	Движения.ДатыКлючевыеНосители.Записывать = Истина;
	Движение = Движения.ДатыКлючевыеНосители.Добавить();
	Движение.Период = Дата;
	Движение.КлючевойНоситель = КлючевойНоситель;
	Движение.RSAС = RSAС;
	Движение.RSAДо = RSAДо;
	Движение.ГОСТС = ГОСТС;
	Движение.ГОСТДо = ГОСТДо;

	//}}__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
КонецПроцедуры


Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Автор = Пользователи.АвторизованныйПользователь();
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	//Фиксация в истории изменений
	АутсорсФункцииДокументовСервер.УстановитьИзменениеДокумента(ЭтотОбъект.Ссылка);
КонецПроцедуры
