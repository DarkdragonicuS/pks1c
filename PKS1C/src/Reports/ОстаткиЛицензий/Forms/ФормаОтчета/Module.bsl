
&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры)
	Если ОткрытьКарточкуЛицензии(Расшифровка) Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Функция ОткрытьКарточкуЛицензии(Расшифровка)
	КодАктивации = ПолучитьКодАктивацииИзРасшифровки(Расшифровка);
	Если ЗначениеЗаполнено(КодАктивации) Тогда
		АутсорсЛицензииКлиент.ОткрытьКарточкуЛицензии(КодАктивации);
		Возврат Истина;
	ИначеЕсли КодАктивации = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	Возврат Истина;
КонецФункции

&НаСервере
Функция ПолучитьКодАктивацииИзРасшифровки(Расшифровка)
	ДанныеОтчета = ПолучитьИзВременногоХранилища(ДанныеРасшифровки);
	ПолеРасшифровки = ДанныеОтчета.Элементы.Получить(Расшифровка).ПолучитьПоля()[0];
	Если ПолеРасшифровки.Поле = "КодАктивации" Тогда
		Возврат ПолеРасшифровки.Значение;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
КонецФункции