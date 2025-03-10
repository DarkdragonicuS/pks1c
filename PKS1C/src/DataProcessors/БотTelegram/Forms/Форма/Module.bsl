
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Токен = Константы.ТокенTelegram.Получить();
КонецПроцедуры

&НаКлиенте
Процедура ЗапускБота(Команда)
	ПодключитьОбработчикОжидания("БотРаботай", 5, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура БотРаботай()
	ЗапуститьБотаНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗапуститьБотаНаСервере()
	// нам нужен временный чтобы хранить ответ от телеграма
	//ИмяФайла = ПолучитьИмяВременногоФайла("txt");
	// создаем новое подключение к api.telegram.org, не забываем про SSL
	Подключение = Новый HTTPСоединение("api.telegram.org", 443,,,,, Новый ЗащищенноеСоединениеOpenSSL());
	// про offset я писал вышел - будем получать только новые сообщения
	// то есть к ИДСообщения добавляем 1 и получаем данные
	Ограничение = 0;
	Если ЗначениеЗаполнено(ИДСообщения) Тогда
		//Ограничение = "?offset=" + Формат(ИДСообщения + 1, "ЧГ=");
		Ограничение =  ИДСообщения + 1;
	КонецЕсли; 
	ПараметрыЗапроса = Новый Структура("offset",Ограничение);
	// сам запрос GET с getUpdates
//	Запрос = Новый HTTPЗапрос("/bot" + Токен + "/getUpdates" + Ограничение);
//	Подключение.Получить(Запрос, ИмяФайла);
//	// после того как ответ получен мы читаем с помощью JSON ответ
//	чтение = новый ЧтениеJSON;
//	чтение.ОткрытьФайл(ИмяФайла);
//	данные = ПрочитатьJSON(чтение,ложь);
	Результат = ВзаимодействиеСTelegramСервер.ВыполнитьМетодTelegram(Токен,"getUpdates",ПараметрыЗапроса,Подключение);
	Данные = ПолучитьСтруктурированныеДанныеJSON(Результат.Ответ.ПолучитьТелоКакСтроку());
	// если не ok - уходим из процедуры
	Если НЕ данные.ok Тогда
		Возврат;
	КонецЕсли;
	// дальше обрабатываем массив сообщений
	Для каждого Сообщение из данные.result Цикл
		
		// обновляем нам ИДСообщения
		ИДСообщения = Сообщение.update_id;
		ТекстОтвета = "";
		
		Клавиатура = Неопределено;
		ИсходноеСообщение = Неопределено;
		
		Если Сообщение.Свойство("message") Тогда
			Отправитель = Сообщение.message.from;
			
			//Если Свойство(Сообщение.message.entities) И Сообщение.message.entities[0].type = "bot_command" Тогда
			Если Сообщение.message.Свойство("text") Тогда
				ТекстПриятногоСообщения = Сообщение.message.text;
				Если Сообщение.message.text = "/start" Тогда
					//Стартовые кнопки
					//Клавиатура = СгенерироватьСтартовуюКлавиатуру();
					Клавиатура = ВзаимодействиеСTelegramСервер.СгенерироватьИнлайнКлавиатуру();
					ТекстОтвета = "Добавлены команды";
				ИначеЕсли Сообщение.message.text = "/ping" Тогда
					ТекстОтвета = "Да, я здесь!"; 
				ИначеЕсли
					Сообщение.message.text = "/current_tasks" Тогда
					ТекстОтвета = "<Данный функционал в разработке>"; 
				Иначе
					ТекстОтвета = "Я тебя не понимаю(";
				КонецЕсли;
			Иначе
				ТекстОтвета = "Я тебя не понимаю(";
			КонецЕсли;
			
			ИсходноеСообщение = Формат(Сообщение.message.message_id,"ЧГ=")
		ИначеЕсли Сообщение.Свойство("callback_query") Тогда
			Отправитель = Сообщение.callback_query.from;
			
			Если Сообщение.callback_query.Свойство("data") Тогда
				Данные = Сообщение.callback_query.data;
				
				Если Данные = "ping" Тогда
					ТекстОтвета = "Да, я здесь!"; 
				ИначеЕсли Данные = "currentTasks" Тогда
					ТекстОтвета = "<Данный функционал в разработке>";
					Рез = ВзаимодействиеСTelegramСервер.СформироватьДанныеПоЗаявкам();
				Иначе
					ТекстОтвета = "Я тебя не понимаю(";
				КонецЕсли;
			Иначе
				ТекстОтвета = "Что-то пошло не так";
			КонецЕсли;
			Клавиатура = ВзаимодействиеСTelegramСервер.СгенерироватьИнлайнКлавиатуру();
		КонецЕсли;
		
		// получаем текст сообщения и данные отправителя
		Если Отправитель = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		ОтКогоИД = Формат(Отправитель.id, "ЧГ=");
		ОтКого = Отправитель.first_name + ?(Отправитель.Свойство("last_name")," " + Отправитель.last_name,"");
		// обновим лог событий
		Лог = ЛогСобытий.Добавить();
		Лог.Период= ТекущаяДата();
		Лог.Событие = "Пришло сообщение от " + ОтКого + " (" + ОтКогоИД + ")";
		
		// Для отправки сообщения нужно знать две вещи - идентификатор чата
		// и само сообщение. Снова создаем новый запрос к sendMessage и параметрами
		// chat_id и text
		
		ТекстЗапроса = "/bot"+Токен + "/sendmessage?chat_id=" + ОтКогоИД + "&text=" + ТекстОтвета;
		Если Не ИсходноеСообщение = Неопределено Тогда
			ТекстЗапроса = ТекстЗапроса + "&reply_to_message_id=" + ИсходноеСообщение;
		КонецЕсли;
		
		Если Не Клавиатура = Неопределено Тогда
			ТекстЗапроса = ТекстЗапроса + "&reply_markup=" + Клавиатура;
		КонецЕсли;
		Запрос = Новый HTTPЗапрос(ТекстЗапроса);
		// собственно посылаем запрос и ждем сообщения от бота
		ИмяФайлаСообщение = ПолучитьИмяВременногоФайла("txt");
		Подключение.Получить(Запрос, ИмяФайлаСообщение);
		// конец цикла
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура getUpdates(Команда)
	ЗапуститьБотаНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура botGetFile(Команда)
	getFileНаСервере();
КонецПроцедуры

&НаСервере
Процедура getFileНаСервере()
	// нам нужен временный чтобы хранить ответ от телеграма
	ИмяФайла = ПолучитьИмяВременногоФайла("txt");
	// создаем новое подключение к api.telegram.org, не забываем про SSL
	Подключение = Новый HTTPСоединение("api.telegram.org", 443,,,,, Новый ЗащищенноеСоединениеOpenSSL());
	// про offset я писал вышел - будем получать только новые сообщения
	// то есть к ИДСообщения добавляем 1 и получаем данные
	Ограничение = "";
	// сам запрос GET с getUpdates
	FileID = "?file_id=" + Формат(ИДФайла, "ЧГ=");
	Запрос = Новый HTTPЗапрос("/bot" + Токен + "/getFile" + FileID);
	Подключение.Получить(Запрос, ИмяФайла);
	// после того как ответ получен мы читаем с помощью JSON ответ
	чтение = новый ЧтениеJSON;
	чтение.ОткрытьФайл(ИмяФайла);
	данные = ПрочитатьJSON(чтение,ложь);
	// если не ok - уходим из процедуры
	Если НЕ данные.ok Тогда
		Возврат;
	КонецЕсли;
	// дальше обрабатываем массив сообщений
	//Получаем путь к файлу
	ПутьФайла = данные.result.file_path;
	ПутьКПолученномуФайлу = "https://api.telegram.org/file/bot" + Токен + "/" + ПутьФайла;
	//	// обновляем нам ИДСообщения
	//	ИДСообщения = Сообщение.update_id;
	//	// получаем текст сообщения и данные отправителя
	//	ОтКогоИД = Формат(Сообщение.message.from.id, "ЧГ=");
	//	ОтКого = Сообщение.message.from.first_name + " " + Сообщение.message.from.last_name;
	//	// обновим лог событий
	//	Лог = ЛогСобытий.Добавить();
	//	Лог.Период= ТекущаяДата();
	//	Лог.Событие = "Пришло сообщение от " + ОтКого + " (" + ОтКогоИД + ")";
	//	// и приготовим ответ
	//	ТекстОтвета = "";
	//	//Если Свойство(Сообщение.message.entities) И Сообщение.message.entities[0].type = "bot_command" Тогда
	//	Если Сообщение.message.Свойство("text") Тогда
	//		ТестПриятногоСообщения = Сообщение.message.text;
	//		Если Сообщение.message.text = "/ping" Тогда
	//			ТекстОтвета = "Да, я здесь!"; 
	//		ИначеЕсли
	//			Сообщение.message.text = "/current_tasks" Тогда
	//			ТекстОтвета = "<Данный функционал в разработке>"; 
	//		Иначе
	//			ТекстОтвета = "Я тебя не понимаю(";
	//		КонецЕсли;
	//	Иначе
	//		ТекстОтвета = "Я тебя не понимаю(";
	//	КонецЕсли;
	//	
	//	// Для отправки сообщения нужно знать две вещи - идентификатор чата
	//	// и само сообщение. Снова создаем новый запрос к sendMessage и параметрами
	//	// chat_id и text
	//	Запрос = Новый HTTPЗапрос("/bot"+Токен + "/sendmessage?chat_id=" + ОтКогоИД + "&text=" + ТекстОтвета);
	//	// собственно посылаем запрос и ждем сообщения от бота
	//	ИмяФайлаСообщение = ПолучитьИмяВременногоФайла("txt");
	//	Подключение.Получить(Запрос, ИмяФайлаСообщение);
	//	// конец цикла
КонецПроцедуры

&НаКлиенте
Процедура ЗапускРегламентногоЗадания(Команда)
	ПодключитьОбработчикОжидания("ЗапускБотаФоном",5,Ложь);
КонецПроцедуры

//&НаСервереБезКонтекста
//Функция СгенерироватьСтартовуюКлавиатуру()
//	Клавиатура = Новый Структура("keyboard,resize_keyboard");
//	Клавиатура.Вставить("resize_keyboard",Истина);
//	
//	КнопкаPing = Новый Структура();
//	КнопкаPing.Вставить("text","/ping");
//	
//	КнопкаCurrentTasks = Новый Структура();
//	КнопкаCurrentTasks.Вставить("text","/current_tasks");
//	
//	МассивКнопокСтрока1 = Новый Массив;
//	МассивКнопокСтрока1.Добавить(КнопкаPing);
//	МассивКнопокСтрока1.Добавить(КнопкаCurrentTasks);
//	
//	МассивСтрокКнопок = Новый Массив;
//	МассивСтрокКнопок.Добавить(МассивКнопокСтрока1);
//	
//	Клавиатура.keyboard = МассивСтрокКнопок;
//	
//	КлавиатураJSON = Новый ЗаписьJSON;
//	КлавиатураJSON.УстановитьСтроку();
//	ЗаписатьJSON(КлавиатураJSON,Клавиатура);
//	
//	Возврат КлавиатураJSON.Закрыть();
//КонецФункции

//&НаСервереБезКонтекста
//Функция СгенерироватьИнлайнКлавиатуру()
//	Клавиатура = Новый Структура("inline_keyboard");
//	
//	КнопкаPing = Новый Структура();
//	КнопкаPing.Вставить("text","Проверить связь с базой");
//	КнопкаPing.Вставить("callback_data","ping");
//	
//	КнопкаCurrentTasks = Новый Структура();
//	КнопкаCurrentTasks.Вставить("text","Текущие заявки");
//	КнопкаCurrentTasks.Вставить("callback_data","currentTasks");
//	
//	МассивКнопокСтрока1 = Новый Массив;
//	МассивКнопокСтрока1.Добавить(КнопкаPing);
//	
//	МассивКнопокСтрока2 = Новый Массив;	
//	МассивКнопокСтрока2.Добавить(КнопкаCurrentTasks);
//	
//	МассивСтрокКнопок = Новый Массив;
//	МассивСтрокКнопок.Добавить(МассивКнопокСтрока1);
//	МассивСтрокКнопок.Добавить(МассивКнопокСтрока2);
//	
//	Клавиатура.inline_keyboard = МассивСтрокКнопок;
//	
//	КлавиатураJSON = Новый ЗаписьJSON;
//	КлавиатураJSON.УстановитьСтроку();
//	ЗаписатьJSON(КлавиатураJSON,Клавиатура);
//	
//	Возврат КлавиатураJSON.Закрыть();
//КонецФункции

//&НаСервереБезКонтекста
//Функция СформироватьДанныеПоЗаявкам()
//	Запрос = Новый Запрос;
//	Запрос.Текст = 
//		"ВЫБРАТЬ
//		|	ЗаявкиКлиентов.ДатаОткрытия КАК ДатаОткрытия,
//		|	ЗаявкиКлиентов.Клиент КАК Клиент,
//		|	ЗаявкиКлиентов.Приоритет КАК Приоритет,
//		|	ЗаявкиКлиентов.ОтветственноеЛицо КАК ОтветственноеЛицо,
//		|	ЗаявкиКлиентов.ТекстЗаявки КАК ТекстЗаявки
//		|ИЗ
//		|	Документ.ЗаявкиКлиентов КАК ЗаявкиКлиентов
//		|ГДЕ
//		|	ЗаявкиКлиентов.Статус = &Статус";
//	
//	Запрос.УстановитьПараметр("Статус", Перечисления.СтатусыЗаявок.Открыта);
//	
//	РезультатЗапроса = Запрос.Выполнить();
//	
//	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
//	
//	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
//		// Вставить обработку выборки ВыборкаДетальныеЗаписи
//	КонецЦикла;
//	
////КонецФункции

&НаКлиенте
Процедура ЗапускБотаФоном() Экспорт
	ЗапускБотаНаСервере();
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗапускБотаНаСервере()
	ВзаимодействиеСTelegramСервер.ЗапускВзаимодействияСTelegram();
КонецПроцедуры

&НаКлиенте
Процедура pinChatMessage(Команда)
	ChatID = ИДПользователя;
	Сообщение = СообщениеТекст;
	pinChatMessageНаСервере(Токен,ChatID,Сообщение);
КонецПроцедуры

&НаСервереБезКонтекста
Процедура pinChatMessageНаСервере(Токен,ChatID,Сообщение)
	Если Не ЗначениеЗаполнено(ChatID) Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ПользователиБотаTelegram.UserID КАК UserID
			|ИЗ
			|	РегистрСведений.ПользователиБотаTelegram КАК ПользователиБотаTelegram";
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			ВзаимодействиеСTelegramСервер.ПрикрепитьСообщение(Токен,ВыборкаДетальныеЗаписи.UserID,Сообщение);
		КонецЦикла;
	Иначе
		ВзаимодействиеСTelegramСервер.ПрикрепитьСообщение(Токен,ChatID,Сообщение);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура unpinAllChatMessages(Команда)
	ChatID = ИДПользователя;
	unpinAllChatMessagesНаСервере(Токен,ChatID);
КонецПроцедуры

&НаСервереБезКонтекста
Процедура unpinAllChatMessagesНаСервере(Токен,ChatID)
	Если Не ЗначениеЗаполнено(ChatID) Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ПользователиБотаTelegram.UserID КАК UserID
			|ИЗ
			|	РегистрСведений.ПользователиБотаTelegram КАК ПользователиБотаTelegram";
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			ВзаимодействиеСTelegramСервер.УдалитьПрикрепленныеСообщения(Токен,ВыборкаДетальныеЗаписи.UserID);
		КонецЦикла;
	Иначе
		ВзаимодействиеСTelegramСервер.УдалитьПрикрепленныеСообщения(Токен,ChatID);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура sendmessage(Команда)
	ChatID = ИДПользователя;
	Сообщение = СообщениеТекст;
	sendmessageНаСервере(Токен,ChatID,Сообщение);
КонецПроцедуры

&НаСервереБезКонтекста
Процедура sendmessageНаСервере(Токен,ChatID,Сообщение)
	Если Не ЗначениеЗаполнено(ChatID) Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ПользователиБотаTelegram.UserID КАК UserID
			|ИЗ
			|	РегистрСведений.ПользователиБотаTelegram КАК ПользователиБотаTelegram";
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			ВзаимодействиеСTelegramСервер.ОтправитьСообщение(Токен,ВыборкаДетальныеЗаписи.UserID,Сообщение);
		КонецЦикла;
	Иначе
		ВзаимодействиеСTelegramСервер.ОтправитьСообщение(Токен,ChatID,Сообщение);
	КонецЕсли;
КонецПроцедуры