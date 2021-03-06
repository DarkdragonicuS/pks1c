///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	Ограничение.Текст =
	"РазрешитьЧтение
	|ГДЕ
	|	ИСТИНА
	|;
	|РазрешитьИзменениеЕслиРазрешеноЧтение
	|ГДЕ
	|	ИзменениеОбъектаРазрешено(Взаимодействие)";
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики обновления

// Процедура обновления ИБ для версии БСП 2.2.
// Переносит Рассмотрено и РассмотретьПосле из реквизитов документов взаимодействий в регистр сведений
// ПредметыПапкиВзаимодействий.
//
Процедура ОбновитьХранениеРассмотреноРассмотретьПосле_2_2_0_0(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ ПЕРВЫЕ 1000
	|	Встреча.Ссылка,
	|	Встреча.Удалить_Рассмотрено КАК Рассмотрено,
	|	Встреча.Удалить_РассмотретьПосле КАК РассмотретьПосле
	|ИЗ
	|	Документ.Встреча КАК Встреча
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПредметыПапкиВзаимодействий КАК ПредметыПапкиВзаимодействий
	|		ПО (ПредметыПапкиВзаимодействий.Взаимодействие = Встреча.Ссылка)
	|ГДЕ
	|	НЕ (НЕ Встреча.Удалить_Рассмотрено <> ПредметыПапкиВзаимодействий.Рассмотрено
	|			И НЕ Встреча.Удалить_РассмотретьПосле <> ПредметыПапкиВзаимодействий.РассмотретьПосле)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗапланированноеВзаимодействие.Ссылка,
	|	ЗапланированноеВзаимодействие.Удалить_Рассмотрено,
	|	ЗапланированноеВзаимодействие.Удалить_РассмотретьПосле
	|ИЗ
	|	Документ.ЗапланированноеВзаимодействие КАК ЗапланированноеВзаимодействие
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПредметыПапкиВзаимодействий КАК ПредметыПапкиВзаимодействий
	|		ПО (ПредметыПапкиВзаимодействий.Взаимодействие = ЗапланированноеВзаимодействие.Ссылка)
	|ГДЕ
	|	НЕ (НЕ ЗапланированноеВзаимодействие.Удалить_Рассмотрено <> ПредметыПапкиВзаимодействий.Рассмотрено
	|			И НЕ ЗапланированноеВзаимодействие.Удалить_РассмотретьПосле <> ПредметыПапкиВзаимодействий.РассмотретьПосле)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТелефонныйЗвонок.Ссылка,
	|	ТелефонныйЗвонок.Удалить_Рассмотрено,
	|	ТелефонныйЗвонок.Удалить_РассмотретьПосле
	|ИЗ
	|	Документ.ТелефонныйЗвонок КАК ТелефонныйЗвонок
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПредметыПапкиВзаимодействий КАК ПредметыПапкиВзаимодействий
	|		ПО (ПредметыПапкиВзаимодействий.Взаимодействие = ТелефонныйЗвонок.Ссылка)
	|ГДЕ
	|	НЕ (НЕ ТелефонныйЗвонок.Удалить_Рассмотрено <> ПредметыПапкиВзаимодействий.Рассмотрено
	|			И НЕ ТелефонныйЗвонок.Удалить_РассмотретьПосле <> ПредметыПапкиВзаимодействий.РассмотретьПосле)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЭлектронноеПисьмоВходящее.Ссылка,
	|	ЭлектронноеПисьмоВходящее.Удалить_Рассмотрено,
	|	ЭлектронноеПисьмоВходящее.Удалить_РассмотретьПосле
	|ИЗ
	|	Документ.ЭлектронноеПисьмоВходящее КАК ЭлектронноеПисьмоВходящее
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПредметыПапкиВзаимодействий КАК ПредметыПапкиВзаимодействий
	|		ПО (ПредметыПапкиВзаимодействий.Взаимодействие = ЭлектронноеПисьмоВходящее.Ссылка)
	|ГДЕ
	|	НЕ (НЕ ЭлектронноеПисьмоВходящее.Удалить_Рассмотрено <> ПредметыПапкиВзаимодействий.Рассмотрено
	|			И НЕ ЭлектронноеПисьмоВходящее.Удалить_РассмотретьПосле <> ПредметыПапкиВзаимодействий.РассмотретьПосле)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЭлектронноеПисьмоИсходящее.Ссылка,
	|	ЭлектронноеПисьмоИсходящее.Удалить_Рассмотрено,
	|	ЭлектронноеПисьмоИсходящее.Удалить_РассмотретьПосле
	|ИЗ
	|	Документ.ЭлектронноеПисьмоИсходящее КАК ЭлектронноеПисьмоИсходящее
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПредметыПапкиВзаимодействий КАК ПредметыПапкиВзаимодействий
	|		ПО (ПредметыПапкиВзаимодействий.Взаимодействие = ЭлектронноеПисьмоИсходящее.Ссылка)
	|ГДЕ
	|	НЕ (НЕ ЭлектронноеПисьмоИсходящее.Удалить_Рассмотрено <> ПредметыПапкиВзаимодействий.Рассмотрено
	|			И НЕ ЭлектронноеПисьмоИсходящее.Удалить_РассмотретьПосле <> ПредметыПапкиВзаимодействий.РассмотретьПосле)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СообщениеSMS.Ссылка,
	|	СообщениеSMS.Удалить_Рассмотрено,
	|	СообщениеSMS.Удалить_РассмотретьПосле
	|ИЗ
	|	Документ.СообщениеSMS КАК СообщениеSMS
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПредметыПапкиВзаимодействий КАК ПредметыПапкиВзаимодействий
	|		ПО (ПредметыПапкиВзаимодействий.Взаимодействие = СообщениеSMS.Ссылка)
	|ГДЕ
	|	НЕ (НЕ СообщениеSMS.Удалить_Рассмотрено <> ПредметыПапкиВзаимодействий.Рассмотрено
	|			И НЕ СообщениеSMS.Удалить_РассмотретьПосле <> ПредметыПапкиВзаимодействий.РассмотретьПосле)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Реквизиты = РеквизитыВзаимодействия();
		Реквизиты.Рассмотрено = Выборка.Рассмотрено;
		Реквизиты.РассмотретьПосле = Выборка.РассмотретьПосле;
		
		НаборЗаписей = СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Взаимодействие.Установить(Выборка.Ссылка);
		ЗаписатьПредметыПапкиВзаимодействий(Выборка.Ссылка, Реквизиты, НаборЗаписей);
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
	
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = (Выборка.Количество() = 0);

КонецПроцедуры

// Формирует пустую структуру для записи в регистр сведений ПредметыПапкиВзаимодействий.
//
Функция РеквизитыВзаимодействия() Экспорт

	Результат = Новый Структура;
	Результат.Вставить("Предмет"                ,Неопределено);
	Результат.Вставить("Папка"                  ,Неопределено);
	Результат.Вставить("Рассмотрено"            ,Неопределено);
	Результат.Вставить("РассмотретьПосле"       ,Неопределено);
	Результат.Вставить("РассчитыватьРассмотрено",Истина);
	
	Возврат Результат;
	
КонецФункции

// Устанавливает папку, предмет и реквизиты рассмотрения для взаимодействий.
//
// Параметры:
//  Ссылка      - ДокументСсылка.ЭлектронноеПисьмоВходящее,
//                ДокументСсылка.ЭлектронноеПисьмоИсходящее,
//                ДокументСсылка.Встреча,
//                ДокументСсылка.ЗапланированноеВзаимодействие,
//                ДокументСсылка.ТелефонныйЗвонок - взаимодействие для которого будут установлены папка и предмет.
//  Реквизиты    - Структура - см. РегистрыСведений.ПредметыПапкиВзаимодействий.РеквизитыВзаимодействия.
//  НаборЗаписей - РегистрСведений.ПредметыПапкиВзаимодействий.НаборЗаписей - набор записей регистра, если он уже создан
//                 на момент вызова процедуры.
//
Процедура ЗаписатьПредметыПапкиВзаимодействий(Взаимодействие, Реквизиты, НаборЗаписей = Неопределено) Экспорт
	
	Папка                   = Реквизиты.Папка;
	Предмет                 = Реквизиты.Предмет;
	Рассмотрено             = Реквизиты.Рассмотрено;
	РассмотретьПосле        = Реквизиты.РассмотретьПосле;
	РассчитыватьРассмотрено = Реквизиты.РассчитыватьРассмотрено;
	
	СоздаватьИЗаписывать = (НаборЗаписей = Неопределено);
	
	Если Папка = Неопределено И Предмет = Неопределено И Рассмотрено = Неопределено 
		И РассмотретьПосле = Неопределено  Тогда
		
		Возврат;
		
	ИначеЕсли Папка = Неопределено ИЛИ Предмет = Неопределено ИЛИ Рассмотрено = Неопределено 
		ИЛИ РассмотретьПосле = Неопределено Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	ПредметыПапкиВзаимодействий.Предмет,
		|	ПредметыПапкиВзаимодействий.ПапкаЭлектронногоПисьма,
		|	ПредметыПапкиВзаимодействий.Рассмотрено,
		|	ПредметыПапкиВзаимодействий.РассмотретьПосле
		|ИЗ
		|	РегистрСведений.ПредметыПапкиВзаимодействий КАК ПредметыПапкиВзаимодействий
		|ГДЕ
		|	ПредметыПапкиВзаимодействий.Взаимодействие = &Взаимодействие";
		
		Запрос.УстановитьПараметр("Взаимодействие",Взаимодействие);
		
		Результат = Запрос.Выполнить();
		Если НЕ Результат.Пустой() Тогда
			
			Выборка = Результат.Выбрать();
			Выборка.Следующий();
			
			Если Папка = Неопределено Тогда
				Папка = Выборка.ПапкаЭлектронногоПисьма;
			КонецЕсли;
			
			Если Предмет = Неопределено Тогда
				Предмет = Выборка.Предмет;
			КонецЕсли;
			
			Если Рассмотрено = Неопределено Тогда
				Рассмотрено = Выборка.Рассмотрено;
			КонецЕсли;
			
			Если РассмотретьПосле = Неопределено Тогда
				РассмотретьПосле = Выборка.РассмотретьПосле;
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
	Если СоздаватьИЗаписывать Тогда
		НаборЗаписей = СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Взаимодействие.Установить(Взаимодействие);
	КонецЕсли;
	Запись = НаборЗаписей.Добавить();
	Запись.Взаимодействие          = Взаимодействие;
	Запись.Предмет                 = Предмет;
	Запись.ПапкаЭлектронногоПисьма = Папка;
	Запись.Рассмотрено             = Рассмотрено;
	Запись.РассмотретьПосле        = РассмотретьПосле;
	НаборЗаписей.ДополнительныеСвойства.Вставить("РассчитыватьРассмотрено", РассчитыватьРассмотрено);
	
	Если СоздаватьИЗаписывать Тогда
		НаборЗаписей.Записать();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
