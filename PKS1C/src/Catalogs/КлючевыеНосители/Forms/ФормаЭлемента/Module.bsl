
&НаСервере
Процедура ПриОткрытииНаСервере(ТабДок, КлючевойНоситель)
	ТабДок.Очистить();
	
	Истекающие = 0;
	Неистекающие = 0;
	
	Макет = Справочники.КлючевыеНосители.ПолучитьМакет("Макет");
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
	
	ТабДок.Вывести(ОбластьШапка);
	
	ЗапросДат = Новый Запрос;
	ЗапросДат.Текст = 
		"ВЫБРАТЬ
		|	ДатыКлючевыеНосителиСрезПоследних.RSAС КАК RSAС,
		|	ДатыКлючевыеНосителиСрезПоследних.RSAДо КАК RSAДо,
		|	ДатыКлючевыеНосителиСрезПоследних.ГОСТС КАК ГОСТС,
		|	ДатыКлючевыеНосителиСрезПоследних.ГОСТДо КАК ГОСТДо,
		|	ДатыКлючевыеНосителиСрезПоследних.Регистратор.Дата КАК Дата,
		|	ДатыКлючевыеНосителиСрезПоследних.КлючевойНоситель КАК КлючевойНоситель
		|ИЗ
		|	РегистрСведений.ДатыКлючевыеНосители.СрезПоследних(, ) КАК ДатыКлючевыеНосителиСрезПоследних
		|ГДЕ
		|	ДатыКлючевыеНосителиСрезПоследних.КлючевойНоситель = &КлючевойНоситель
		|
		|УПОРЯДОЧИТЬ ПО
		|	Дата УБЫВ";	
	
	ЗапросДат.УстановитьПараметр("КлючевойНоситель", КлючевойНоситель);
	РезультатЗапросаДат = ЗапросДат.Выполнить();	
	ВыборкаДат = РезультатЗапросаДат.Выбрать();
	
	Пока ВыборкаДат.Следующий() Цикл
		ОбластьСтрока.Параметры.Дата = Формат(ВыборкаДат.Дата, "ДФ=дд.ММ.гггг");
		ОбластьСтрока.Параметры.ГОСТС = Формат(ВыборкаДат.ГОСТС, "ДФ=дд.ММ.гггг");
		ОбластьСтрока.Параметры.ГОСТДо = Формат(ВыборкаДат.ГОСТДо, "ДФ=дд.ММ.гггг");
		ОбластьСтрока.Параметры.RSAС = Формат(ВыборкаДат.RSAС, "ДФ=дд.ММ.гггг");
		ОбластьСтрока.Параметры.RSAДо = Формат(ВыборкаДат.RSAДо, "ДФ=дд.ММ.гггг");
		ТабДок.Вывести(ОбластьСтрока);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПриОткрытииНаСервере(ТабДок, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНаОсновании(Команда)
	ФормаДокумента = ПолучитьФорму("Документ.СменаДатКлючевыхНосителей.Форма.ФормаДокумента");
	ФормаДокумента.Объект.КлючевойНоситель = Объект.Ссылка;
	ФормаДокумента.НаОсновании = Истина;
	ФормаДокумента.Открыть();
КонецПроцедуры
