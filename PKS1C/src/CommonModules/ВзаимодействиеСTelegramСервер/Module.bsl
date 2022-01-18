Процедура ЗапускВзаимодействияСTelegram() Экспорт
	
	Токен = Константы.ТокенTelegram.Получить();
	Подключение = Новый HTTPСоединение("api.telegram.org", 443,,,,, Новый ЗащищенноеСоединениеOpenSSL());
	Результат = ПолучитьОбновления(Токен,Подключение);
	
	// после того как ответ получен мы читаем с помощью JSON ответ
	чтение = новый ЧтениеJSON;
	//чтение.ОткрытьФайл(ИмяФайла);
	чтение.УстановитьСтроку(Результат.Ответ.ПолучитьТелоКакСтроку());
	данные = ПрочитатьJSON(чтение,ложь);
	чтение.Закрыть();
	// если не ok - уходим из процедуры
	Если НЕ данные.ok Тогда
		Возврат;
	КонецЕсли;
	// дальше обрабатываем массив сообщений
	Для каждого Сообщение из данные.result Цикл
		Результат = ОбработатьСообщение(Токен,Сообщение,Подключение);
	КонецЦикла;
	
КонецПроцедуры

Функция СгенерироватьСтартовуюКлавиатуру() Экспорт
	Клавиатура = Новый Структура("keyboard,resize_keyboard");
	Клавиатура.Вставить("resize_keyboard",Истина);
	
	КнопкаPing = Новый Структура();
	КнопкаPing.Вставить("text","/ping");
	
	КнопкаCurrentTasks = Новый Структура();
	КнопкаCurrentTasks.Вставить("text","/current_tasks");
	
	МассивКнопокСтрока1 = Новый Массив;
	МассивКнопокСтрока1.Добавить(КнопкаPing);
	МассивКнопокСтрока1.Добавить(КнопкаCurrentTasks);
	
	МассивСтрокКнопок = Новый Массив;
	МассивСтрокКнопок.Добавить(МассивКнопокСтрока1);
	
	Клавиатура.keyboard = МассивСтрокКнопок;
	
	КлавиатураJSON = Новый ЗаписьJSON;
	КлавиатураJSON.УстановитьСтроку();
	ЗаписатьJSON(КлавиатураJSON,Клавиатура);
	
	Возврат КлавиатураJSON.Закрыть();
КонецФункции
//Параметры:
//Массив строк (массивов) кнопок (структур с ключами text, callback_query)
Функция СгенерироватьИнлайнКлавиатуру(Параметры=Неопределено) Экспорт
	Клавиатура = "";
	
	Если Параметры = Неопределено Тогда
		Клавиатура = СгенерироватьНачальноеМеню();
	Иначе
		Клавиатура = СгенерироватьИнлайнКлавиаутурПоПараметрам(Параметры);
	КонецЕсли;
	
	Возврат Клавиатура;
КонецФункции

Функция СгенерироватьНачальноеМеню() Экспорт
	Клавиатура = Новый Структура("inline_keyboard");
	
	КнопкаPing = Новый Структура();
	КнопкаPing.Вставить("text","Проверить связь с базой");
	КнопкаPing.Вставить("callback_data","ping");
	
	КнопкаCurrentTasks = Новый Структура();
	КнопкаCurrentTasks.Вставить("text","Текущие заявки");
	КнопкаCurrentTasks.Вставить("callback_data",ПолучитьДанныеКомандыCurrentTasks());
	
	КнопкаGetLicense = Новый Структура();
	КнопкаGetLicense.Вставить("text","Получить лицензию");
	КнопкаGetLicense.Вставить("callback_data",ПолучитьДанныеКомандыGetLicense());
	
	МассивКнопокСтрока1 = Новый Массив;
	МассивКнопокСтрока1.Добавить(КнопкаPing);
	
	МассивКнопокСтрока2 = Новый Массив;	
	МассивКнопокСтрока2.Добавить(КнопкаCurrentTasks);
	
	МассивКнопокСтрока3 = Новый Массив;	
	МассивКнопокСтрока3.Добавить(КнопкаGetLicense);
	
	МассивСтрокКнопок = Новый Массив;
	МассивСтрокКнопок.Добавить(МассивКнопокСтрока1);
	МассивСтрокКнопок.Добавить(МассивКнопокСтрока2);
	МассивСтрокКнопок.Добавить(МассивКнопокСтрока3);
	
	Клавиатура.inline_keyboard = МассивСтрокКнопок;
	
	КлавиатураJSON = Новый ЗаписьJSON;
	КлавиатураJSON.УстановитьСтроку(Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Unix,,,ЭкранированиеСимволовJSON.СимволыВнеBMP));
	ЗаписатьJSON(КлавиатураJSON,Клавиатура);
	
	Возврат КлавиатураJSON.Закрыть();
КонецФункции

Функция СформироватьДанныеПоЗаявкам(Исполнитель=Неопределено,Страница=Неопределено) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗаявкиКлиентов.ДатаОткрытия КАК ДатаОткрытия,
		|	ЗаявкиКлиентов.Клиент КАК Клиент,
		|	ЗаявкиКлиентов.Приоритет КАК Приоритет,
		|	ЗаявкиКлиентов.ОтветственноеЛицо КАК ОтветственноеЛицо,
		|	ЗаявкиКлиентов.ТекстЗаявки КАК ТекстЗаявки,
		|	ЗаявкиКлиентов.ТемаЗаявки КАК ТемаЗаявки,
		|   ЗаявкиКлиентов.Номер КАК НомерЗаявки
		|ИЗ
		|	Документ.ЗаявкиКлиентов КАК ЗаявкиКлиентов
		|ГДЕ
		|	ЗаявкиКлиентов.Статус = &Статус
		|&СтрокаИсполнитель
		|
		|УПОРЯДОЧИТЬ ПО
		|	ОтветственноеЛицо,
		|	ДатаОткрытия";
	
	Запрос.УстановитьПараметр("Статус", Перечисления.СтатусыЗаявок.Открыта);
	Если Не Исполнитель = Неопределено Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"&СтрокаИсполнитель","И ЗаявкиКлиентов.ОтветственноеЛицо = &Исполнитель");
		Запрос.УстановитьПараметр("Исполнитель",Исполнитель);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"&СтрокаИсполнитель","");
	КонецЕсли;
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	МассивСообщений = Новый Массив;
	
	Номер = 1;
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Сообщение = Строка(Номер) + ") " + "№" + Формат(Число(ВыборкаДетальныеЗаписи.НомерЗаявки),"ЧГ=") 
					+ Символы.ПС + "Исполнитель: " + ?(ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.ОтветственноеЛицо),ВыборкаДетальныеЗаписи.ОтветственноеЛицо,"<не указан>")
					+ Символы.ПС + "Клиент: " + ВыборкаДетальныеЗаписи.Клиент
					+ Символы.ПС + "Тема: " + ВыборкаДетальныеЗаписи.ТемаЗаявки
					+ Символы.ПС + "---" + Символы.ПС + ПолучитьТекстЗаявки(ВыборкаДетальныеЗаписи.ТекстЗаявки);
		МассивСообщений.Добавить(Сообщение);
		Номер = Номер + 1;
	КонецЦикла;
	
	Возврат МассивСообщений;
КонецФункции

Функция ОтправитьНачальноеМеню(Токен,Подключение=Неопределено,ChatID)
	Ответ = "";
	Ошибка = Ложь;
	
	//УстановитьСтандартноеПодключение(Подключение);
	
	ТекстОтвета = "Выберите функцию:";
	//ТекстЗапроса = "/bot"+Токен + "/sendmessage?chat_id=" + Формат(ChatID,"ЧГ=") + "&text=" + ТекстОтвета;
	
	Клавиатура = СгенерироватьИнлайнКлавиатуру();
	//ТекстЗапроса = ТекстЗапроса + "&reply_markup=" + Клавиатура;
	
	//Запрос = Новый HTTPЗапрос(ТекстЗапроса);
	
	//Попытка
	//	Ответ = Подключение.Получить(Запрос);
	//Исключение
	//	Ошибка = Истина;
	//КонецПопытки;
	
	Ответ = ОтправитьКлавиатуру(Токен,Подключение,ChatID,Клавиатура,ТекстОтвета).Ответ;
	
	Возврат Новый Структура("Ответ,Ошибка",,Ошибка);
КонецФункции

Функция ПолучитьТекстЗаявки(ФорматированныйДокумент)
	Возврат ФорматированныйДокумент.Получить().ПолучитьТекст();
КонецФункции

Функция ПолучитьПользователяРегламентногоЗадания() Экспорт
	Возврат Константы.ПользовательБотTelegram.Получить();
КонецФункции

//запускает бота
Процедура ЗапускЗадания() Экспорт
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания();
    
    //УстановитьПривилегированныйРежим(Истина);
    
    // <инициализация локальных переменных>
    
    //Shell = Новый COMОбъект("WScript.Shell"); 
    
    // <авторизация>    
	
    Пока ИСТИНА Цикл
        
        ЗапускВзаимодействияСTelegram();
        
        Подождать(5); 
        
    КонецЦикла;
КонецПроцедуры

Функция ВыполнитьМетодTelegram(Токен,ИмяМетода,Параметры=Неопределено,Подключение=Неопределено)
	//Параметры: Структура ИмяПараметра -> Значение
	Ошибка = Ложь;
	Если ИмяМетода = "sendDocument" Тогда
		РезультатSendDocument = ВыполнитьМетодTelegramSendDocument(Токен,Параметры,Подключение);
		Ошибка = РезультатSendDocument.Ошибка;
		Ответ = РезультатSendDocument.Ответ	
	Иначе
		ТекстЗапроса = "/bot" + Токен + "/" + ИмяМетода;
		
		МассивПараметров = Новый Массив;                                               
		
		Если Не Параметры = Неопределено Тогда
			Для Каждого КлючИЗначение Из Параметры Цикл
				МассивПараметров.Добавить("" + КлючИЗначение.Ключ + "=" + ?(ТипЗнч(КлючИЗначение.Значение)=Тип("Число"),Формат(КлючИЗначение.Значение,"ЧГ="),КлючИЗначение.Значение));                                      
			КонецЦикла;
		КонецЕсли;
		
		СтрокаПараметров = "";
		Для Каждого СтрокаПараметра Из МассивПараметров Цикл
			Если СтрокаПараметров <> "" Тогда
				СтрокаПараметров = СтрокаПараметров + "&";
			КонецЕсли;
			СтрокаПараметров = СтрокаПараметров + СтрокаПараметра;
		КонецЦикла;
		
		Если СтрокаПараметров <> "" Тогда
			ТекстЗапроса = ТекстЗапроса + "?" + СтрокаПараметров;
		КонецЕсли;
		
		Запрос = Новый HTTPЗапрос(ТекстЗапроса);
		Ответ = Неопределено;
		УстановитьСтандартноеПодключение(Подключение);
		Попытка
			Ответ = Подключение.Получить(Запрос);
		Исключение
			Ответ = "Ошибка выполнения";
			Ошибка = Истина;
		КонецПопытки;
	КонецЕсли;

	Возврат Новый Структура("Подключение,Ответ,Ошибка",Подключение,Ответ,Ошибка);
КонецФункции

Функция ВыполнитьМетодTelegramSendDocument(Токен,Параметры=Неопределено,Подключение=Неопределено)
	Ошибка = Ложь;
	
	ТекстЗапроса = "/bot" + Токен + "/sendDocument";
	
	
	
	ПутьКФайлу = Параметры.document;
	Boundary = "----"+Строка(Новый УникальныйИдентификатор());
	
	Файл = Новый Файл(ПутьКФайлу);
	
	//Определяем массив для процедуры ОбъединитьФайлы
	МассивФайловДляОбъединения = Новый Массив;
	
	МассивФайловДляОбъединения.Добавить(ПолучитьИмяВременногоФайла("txt"));
	ФайлОтправкиНачало = Новый ЗаписьТекста(МассивФайловДляОбъединения[0], КодировкаТекста.UTF8);
	НачальныеДанные = "--%Boundary%
	|Content-Disposition: form-data; name=""chat_id""
	|
	|%ChatID%
	|
	|--%Boundary%
	|Content-Disposition: form-data; name=""caption""
	|
	|%Caption%
	|
	|--%Boundary%
	|Content-Disposition: form-data; name=""document""; filename=""%Filename%""
	|";
	НачальныеДанные = СтрЗаменить(НачальныеДанные,"%Boundary%",Boundary);
	НачальныеДанные = СтрЗаменить(НачальныеДанные,"%ChatID%",Параметры.chat_id);
	НачальныеДанные = СтрЗаменить(НачальныеДанные,"%Caption%",Параметры.caption);
	НачальныеДанные = СтрЗаменить(НачальныеДанные,"%Filename%",Файл.Имя);
	
	ФайлОтправкиНачало.ЗаписатьСтроку(НачальныеДанные);
	ФайлОтправкиНачало.Закрыть();
	
	МассивФайловДляОбъединения.Добавить(ПутьКФайлу);
	
	МассивФайловДляОбъединения.Добавить(ПолучитьИмяВременногоФайла("txt"));
	ФайлаОтправкиКонец = Новый ЗаписьТекста(МассивФайловДляОбъединения[2], КодировкаТекста.UTF8);
	КонечныеДанные = "
	|--%Boundary%--";
	КонечныеДанные = СтрЗаменить(КонечныеДанные,"%Boundary%",Boundary);
	
	ФайлаОтправкиКонец.ЗаписатьСтроку(КонечныеДанные);
	ФайлаОтправкиКонец.Закрыть();
	
	ИмяИтоговогоФайла = ПолучитьИмяВременногоФайла();
	ОбъединитьФайлы(МассивФайловДляОбъединения, ИмяИтоговогоФайла);
	
	УстановитьСтандартноеПодключение(Подключение);
					
	Запрос = Новый HTTPЗапрос(ТекстЗапроса);
	Запрос.Заголовки.Вставить("Connection", "keep-alive");
	Запрос.Заголовки.Вставить("Content-Type", "multipart/form-data; boundary="+Boundary);
	
	Запрос.УстановитьИмяФайлаТела(ИмяИтоговогоФайла);
	
	Попытка
		Ответ = Подключение.ОтправитьДляОбработки(Запрос);
	Исключение
		Ответ = "Ошибка выполнения";
		Ошибка = Истина;
	КонецПопытки;
	
	Возврат Новый Структура("Ответ,Ошибка",Ответ,Ошибка);
КонецФункции

Функция СоздатьПользователяTelegram(Пользователь)
	НовыйПользователь = Ложь;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПользователиБотаTelegram.UserID КАК UserID,
		|	ПользователиБотаTelegram.is_bot КАК is_bot,
		|	ПользователиБотаTelegram.first_name КАК first_name,
		|	ПользователиБотаTelegram.last_name КАК last_name,
		|	ПользователиБотаTelegram.username КАК username
		|ИЗ
		|	РегистрСведений.ПользователиБотаTelegram КАК ПользователиБотаTelegram
		|ГДЕ
		|	ПользователиБотаTelegram.UserID = &UserID";
	
	Запрос.УстановитьПараметр("UserID", Пользователь.id);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если Не ВыборкаДетальныеЗаписи.Следующий() Тогда
		ЗаписьПользователя = РегистрыСведений.ПользователиБотаTelegram.СоздатьМенеджерЗаписи();
		
		ЗаписьПользователя.ДатаРегистрации = ТекущаяДата();
		ЗаписьПользователя.UserID = Пользователь.ID;
		ЗаполнитьЗначенияСвойств(ЗаписьПользователя,Пользователь);
		ЗаписьПользователя.Записать();
		
		НовыйПользователь = Истина;
	ИначеЕсли 
		ВыборкаДетальныеЗаписи.is_bot <> Пользователь.is_bot
		 	ИЛИ (Пользователь.Свойство("first_name") И ВыборкаДетальныеЗаписи.first_name <> Пользователь.first_name)
		 	ИЛИ (Пользователь.Свойство("last_name") И ВыборкаДетальныеЗаписи.last_name <> Пользователь.last_name)
		 	ИЛИ (Пользователь.Свойство("username") И ВыборкаДетальныеЗаписи.username <> Пользователь.username)
			Тогда
			
			
		ЗаписьПользователя = РегистрыСведений.ПользователиБотаTelegram.СоздатьМенеджерЗаписи();
		
		ЗаписьПользователя.UserID = Пользователь.ID;
		ЗаписьПользователя.Прочитать();
		ЗаполнитьЗначенияСвойств(ЗаписьПользователя,Пользователь);
		ЗаписьПользователя.Записать();
		 
	КонецЕсли;         	
	
	Возврат НовыйПользователь;
КонецФункции

Процедура ПрикрепитьСообщение(Токен,ChatID,Сообщение=Неопределено,MessageID=Неопределено,Подключение=Неопределено) Экспорт 
	УстановитьСтандартноеПодключение(Подключение);
	
	//Удаляем прикрепленные сообщения
	Параметры = Новый Структура;
	Параметры.Вставить("chat_id",ChatID);
	РезультатМетода = ВыполнитьМетодTelegram(Токен,"unpinAllChatMessages",Параметры,Подключение);
	Если РезультатМетода.Ошибка Тогда
		Возврат;
	КонецЕсли;
	

	Если MessageID = Неопределено Тогда
		//Отправляем сообщение
		Параметры = Новый Структура;
		Параметры.Вставить("chat_id",ChatID);
		Параметры.Вставить("text",Сообщение);
		РезультатМетода = ВыполнитьМетодTelegram(Токен,"sendMessage",Параметры);
		
		Если Не РезультатМетода.Ошибка Тогда
			чтение = новый ЧтениеJSON;
			//чтение.ОткрытьФайл(ИмяФайла);
			чтение.УстановитьСтроку(РезультатМетода.Ответ.ПолучитьТелоКакСтроку());
			данные = ПрочитатьJSON(чтение,ложь);   
			чтение.Закрыть();
			Если данные.ok Тогда
				Message = данные.result; //Получаем отправленное сообщение - объект Message
				MessageID = Message.message_id;
			Иначе       //что-то пошло не так
				Возврат;
			КонецЕсли;
		Иначе
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	//и прикрепляем это сообщение
	Параметры = Новый Структура;
	Параметры.Вставить("chat_id",ChatID);
	Параметры.Вставить("message_id",MessageID);
	
	РезультатМетода = ВыполнитьМетодTelegram(Токен,"pinChatMessage",Параметры,Подключение);
КонецПроцедуры

Процедура УдалитьПрикрепленныеСообщения(Токен,ChatID,MessageID=Неопределено,Подключение=Неопределено) Экспорт
	УстановитьСтандартноеПодключение(Подключение);
	
	Если Не MessageID = Неопределено Тогда
		//Удаляем прикрепленные сообщения
		Параметры = Новый Структура;
		Параметры.Вставить("chat_id",ChatID);
		РезультатМетода = ВыполнитьМетодTelegram(Токен,"unpinAllChatMessages",Параметры,Подключение);
		Если РезультатМетода.Ошибка Тогда
			Возврат;
		КонецЕсли;
	Иначе
		//Удаляем указанное закрепленное сообщение
		Параметры = Новый Структура;
		Параметры.Вставить("chat_id",ChatID);
		Параметры.Вставить("message_id",MessageID);
		РезультатМетода = ВыполнитьМетодTelegram(Токен,"unpinChatMessage",Параметры,Подключение);
		Если РезультатМетода.Ошибка Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ОтправитьСообщение(Токен,ChatID,Сообщение,Подключение=Неопределено) Экспорт
	УстановитьСтандартноеПодключение(Подключение);
	
	Параметры = Новый Структура;
	Параметры.Вставить("chat_id",ChatID);
	Параметры.Вставить("text",Сообщение);
	РезультатМетода = ВыполнитьМетодTelegram(Токен,"sendMessage",Параметры,Подключение);
	Если РезультатМетода.Ошибка Тогда
		Возврат;
	КонецЕсли;
КонецПроцедуры


// Отправляет сообщение с файлом (документом)
// 
// Параметры:
//  Токен Токен Telegram Bot
//  ChatID ID чата, куда отправляется документ
//  Сообщение - Строка - Сообщение к файлу
//  Данные - Строка - Путь к отправляемому файлу
//  Подключение - Соединение с API Telegram
Процедура ОтправитьДокумент(Токен,ChatID,Сообщение=Неопределено,Данные,Подключение=Неопределено) Экспорт
	УстановитьСтандартноеПодключение(Подключение);
	
	Параметры = Новый Структура;
	Параметры.Вставить("chat_id",ChatID);
	Параметры.Вставить("caption",Сообщение);
	Параметры.Вставить("document",Данные);
	РезультатМетода = ВыполнитьМетодTelegram(Токен,"sendDocument",Параметры,Подключение);
	Если РезультатМетода.Ошибка Тогда
		Возврат;
	КонецЕсли;
КонецПроцедуры

Функция ПолучитьОбновления(Токен,Подключение=Неопределено)
	Если Подключение = Неопределено Тогда
		Подключение = Новый HTTPСоединение("api.telegram.org", 443,,,,, Новый ЗащищенноеСоединениеOpenSSL());
	КонецЕсли;
	
	ИДСообщения = Константы.ИДСообщенияTelegram.Получить();
	//ИмяФайла = ПолучитьИмяВременногоФайла("txt");
	Ограничение = "";

	// про offset я писал вышел - будем получать только новые сообщения
	// то есть к ИДСообщения добавляем 1 и получаем данные
	Если ЗначениеЗаполнено(ИДСообщения) Тогда
		//Ограничение = "?offset=" + Формат(ИДСообщения + 1, "ЧГ="); 
		Ограничение = ИДСообщения + 1; 
	КонецЕсли; 
	// сам запрос GET с getUpdates
	
	
	
	//Запрос = Новый HTTPЗапрос("/bot" + Токен + "/getUpdates" + Ограничение);
	//Попытка
	//	Подключение.Получить(Запрос, ИмяФайла);
	//Исключение
	//	Возврат;
	//КонецПопытки;
	Параметры = Новый Структура;
	//Параметры.Вставить("offset",Формат(ИДСообщения + 1, "ЧГ="));
	Если ЗначениеЗаполнено(Ограничение) Тогда
		Параметры.Вставить("offset",Ограничение);
	КонецЕсли;
	//Параметры.Вставить("timeout","0");
	РезультатМетода = ВыполнитьМетодTelegram(Токен,"getUpdates",Параметры,Подключение);
	
	Возврат РезультатМетода;
КонецФункции

//Производит действия в зависимости от входных данных
Функция ОбработатьСообщение(Токен,Сообщение,Подключение=Неопределено)
	Если Подключение=Неопределено Тогда
		Подключение = Новый HTTPСоединение("api.telegram.org", 443,,,,, Новый ЗащищенноеСоединениеOpenSSL());	
	КонецЕсли;
	// обновляем нам ИДСообщения
	ИДСообщения = Сообщение.update_id;
	ТекстОтвета = "";
	
	Клавиатура = Неопределено;
	ИсходноеСообщение = Неопределено;
	
	Для Каждого ОбъектОбновления Из Сообщение Цикл
		Если ОбъектОбновления.Ключ = "message" Тогда	//сообщение или текстовая команда
			СообщениеОбъект = ОбъектОбновления.Значение;
			//СообщениеОбъект(Message): https://core.telegram.org/bots/api/#message
			//+-----------------------------------+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
			//| message_id                        | Integer                       | Unique message identifier inside this chat                                                                                                                                                                                                                                                                                                                              |
			//| from                              | User                          | Optional. Sender, empty for messages sent to channels                                                                                                                                                                                                                                                                                                                   |
			//| sender_chat                       | Chat                          | Optional. Sender of the message, sent on behalf of a chat. The channel itself for channel messages. The supergroup itself for messages from anonymous group administrators. The linked channel for messages automatically forwarded to the discussion group                                                                                                             |
			//| date                              | Integer                       | Date the message was sent in Unix time                                                                                                                                                                                                                                                                                                                                  |
			//| chat                              | Chat                          | Conversation the message belongs to                                                                                                                                                                                                                                                                                                                                     |
			//| forward_from                      | User                          | Optional. For forwarded messages, sender of the original message                                                                                                                                                                                                                                                                                                        |
			//| forward_from_chat                 | Chat                          | Optional. For messages forwarded from channels or from anonymous administrators, information about the original sender chat                                                                                                                                                                                                                                             |
			//| forward_from_message_id           | Integer                       | Optional. For messages forwarded from channels, identifier of the original message in the channel                                                                                                                                                                                                                                                                       |
			//| forward_signature                 | String                        | Optional. For messages forwarded from channels, signature of the post author if present                                                                                                                                                                                                                                                                                 |
			//| forward_sender_name               | String                        | Optional. Sender's name for messages forwarded from users who disallow adding a link to their account in forwarded messages                                                                                                                                                                                                                                             |
			//| forward_date                      | Integer                       | Optional. For forwarded messages, date the original message was sent in Unix time                                                                                                                                                                                                                                                                                       |
			//| reply_to_message                  | Message                       | Optional. For replies, the original message. Note that the Message object in this field will not contain further reply_to_message fields even if it itself is a reply.                                                                                                                                                                                                  |
			//| via_bot                           | User                          | Optional. Bot through which the message was sent                                                                                                                                                                                                                                                                                                                        |
			//| edit_date                         | Integer                       | Optional. Date the message was last edited in Unix time                                                                                                                                                                                                                                                                                                                 |
			//| media_group_id                    | String                        | Optional. The unique identifier of a media message group this message belongs to                                                                                                                                                                                                                                                                                        |
			//| author_signature                  | String                        | Optional. Signature of the post author for messages in channels, or the custom title of an anonymous group administrator                                                                                                                                                                                                                                                |
			//| text                              | String                        | Optional. For text messages, the actual UTF-8 text of the message, 0-4096 characters                                                                                                                                                                                                                                                                                    |
			//| entities                          | Array of MessageEntity        | Optional. For text messages, special entities like usernames, URLs, bot commands, etc. that appear in the text                                                                                                                                                                                                                                                          |
			//| animation                         | Animation                     | Optional. Message is an animation, information about the animation. For backward compatibility, when this field is set, the document field will also be set                                                                                                                                                                                                             |
			//| audio                             | Audio                         | Optional. Message is an audio file, information about the file                                                                                                                                                                                                                                                                                                          |
			//| document                          | Document                      | Optional. Message is a general file, information about the file                                                                                                                                                                                                                                                                                                         |
			//| photo                             | Array of PhotoSize            | Optional. Message is a photo, available sizes of the photo                                                                                                                                                                                                                                                                                                              |
			//| sticker                           | Sticker                       | Optional. Message is a sticker, information about the sticker                                                                                                                                                                                                                                                                                                           |
			//| video                             | Video                         | Optional. Message is a video, information about the video                                                                                                                                                                                                                                                                                                               |
			//| video_note                        | VideoNote                     | Optional. Message is a video note, information about the video message                                                                                                                                                                                                                                                                                                  |
			//| voice                             | Voice                         | Optional. Message is a voice message, information about the file                                                                                                                                                                                                                                                                                                        |
			//| caption                           | String                        | Optional. Caption for the animation, audio, document, photo, video or voice, 0-1024 characters                                                                                                                                                                                                                                                                          |
			//| caption_entities                  | Array of MessageEntity        | Optional. For messages with a caption, special entities like usernames, URLs, bot commands, etc. that appear in the caption                                                                                                                                                                                                                                             |
			//| contact                           | Contact                       | Optional. Message is a shared contact, information about the contact                                                                                                                                                                                                                                                                                                    |
			//| dice                              | Dice                          | Optional. Message is a dice with random value                                                                                                                                                                                                                                                                                                                           |
			//| game                              | Game                          | Optional. Message is a game, information about the game. More about games »                                                                                                                                                                                                                                                                                             |
			//| poll                              | Poll                          | Optional. Message is a native poll, information about the poll                                                                                                                                                                                                                                                                                                          |
			//| venue                             | Venue                         | Optional. Message is a venue, information about the venue. For backward compatibility, when this field is set, the location field will also be set                                                                                                                                                                                                                      |
			//| location                          | Location                      | Optional. Message is a shared location, information about the location                                                                                                                                                                                                                                                                                                  |
			//| new_chat_members                  | Array of User                 | Optional. New members that were added to the group or supergroup and information about them (the bot itself may be one of these members)                                                                                                                                                                                                                                |
			//| left_chat_member                  | User                          | Optional. A member was removed from the group, information about them (this member may be the bot itself)                                                                                                                                                                                                                                                               |
			//| new_chat_title                    | String                        | Optional. A chat title was changed to this value                                                                                                                                                                                                                                                                                                                        |
			//| new_chat_photo                    | Array of PhotoSize            | Optional. A chat photo was change to this value                                                                                                                                                                                                                                                                                                                         |
			//| delete_chat_photo                 | True                          | Optional. Service message: the chat photo was deleted                                                                                                                                                                                                                                                                                                                   |
			//| group_chat_created                | True                          | Optional. Service message: the group has been created                                                                                                                                                                                                                                                                                                                   |
			//| supergroup_chat_created           | True                          | Optional. Service message: the supergroup has been created. This field can't be received in a message coming through updates, because bot can't be a member of a supergroup when it is created. It can only be found in reply_to_message if someone replies to a very first message in a directly created supergroup.                                                   |
			//| channel_chat_created              | True                          | Optional. Service message: the channel has been created. This field can't be received in a message coming through updates, because bot can't be a member of a channel when it is created. It can only be found in reply_to_message if someone replies to a very first message in a channel.                                                                             |
			//| message_auto_delete_timer_changed | MessageAutoDeleteTimerChanged | Optional. Service message: auto-delete timer settings changed in the chat                                                                                                                                                                                                                                                                                               |
			//| migrate_to_chat_id                | Integer                       | Optional. The group has been migrated to a supergroup with the specified identifier. This number may have more than 32 significant bits and some programming languages may have difficulty/silent defects in interpreting it. But it has at most 52 significant bits, so a signed 64-bit integer or double-precision float type are safe for storing this identifier.   |
			//| migrate_from_chat_id              | Integer                       | Optional. The supergroup has been migrated from a group with the specified identifier. This number may have more than 32 significant bits and some programming languages may have difficulty/silent defects in interpreting it. But it has at most 52 significant bits, so a signed 64-bit integer or double-precision float type are safe for storing this identifier. |
			//| pinned_message                    | Message                       | Optional. Specified message was pinned. Note that the Message object in this field will not contain further reply_to_message fields even if it is itself a reply.                                                                                                                                                                                                       |
			//| invoice                           | Invoice                       | Optional. Message is an invoice for a payment, information about the invoice. More about payments »                                                                                                                                                                                                                                                                     |
			//| successful_payment                | SuccessfulPayment             | Optional. Message is a service message about a successful payment, information about the payment. More about payments »                                                                                                                                                                                                                                                 |
			//| connected_website                 | String                        | Optional. The domain name of the website on which the user has logged in. More about Telegram Login »                                                                                                                                                                                                                                                                   |
			//| passport_data                     | PassportData                  | Optional. Telegram Passport data                                                                                                                                                                                                                                                                                                                                        |
			//| proximity_alert_triggered         | ProximityAlertTriggered       | Optional. Service message. A user in the chat triggered another user's proximity alert while sharing Live Location.                                                                                                                                                                                                                                                     |
			//| voice_chat_scheduled              | VoiceChatScheduled            | Optional. Service message: voice chat scheduled                                                                                                                                                                                                                                                                                                                         |
			//| voice_chat_started                | VoiceChatStarted              | Optional. Service message: voice chat started                                                                                                                                                                                                                                                                                                                           |
			//| voice_chat_ended                  | VoiceChatEnded                | Optional. Service message: voice chat ended                                                                                                                                                                                                                                                                                                                             |
			//| voice_chat_participants_invited   | VoiceChatParticipantsInvited  | Optional. Service message: new participants invited to a voice chat                                                                                                                                                                                                                                                                                                     |
			//| reply_markup                      | InlineKeyboardMarkup          | Optional. Inline keyboard attached to the message. login_url buttons are represented as ordinary url buttons.                                                                                                                                                                                                                                                           |
			//+-----------------------------------+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
			
			Отправитель = СообщениеОбъект.from;
			Если Отправитель.is_bot Тогда	//с ботами не работаем 
				Возврат Ложь;
			КонецЕсли;
			
			// получаем текст сообщения и данные отправителя
			Если Отправитель = Неопределено Тогда
				Возврат Ложь;
			КонецЕсли;
			ОтКогоИД = Формат(Отправитель.id, "ЧГ=");
			ОтКого = Отправитель.first_name + ?(Отправитель.Свойство("last_name")," " + Отправитель.last_name,"");
			ЗаписьЛога = РегистрыСведений.ЛогTelegram.СоздатьМенеджерЗаписи();
						
			//ЗаписьЛога.Период= ТекущаяДата();
			ЗаписьЛога.ДатаВремя = ТекущаяДата();
			ЗаписьЛога.Событие = "Пришло сообщение от " + ОтКого + " (" + ОтКогоИД + ")";
			ЗаписьЛога.GUID = Новый УникальныйИдентификатор();
			ЗаписьЛога.Записать();
			
			//Если Свойство(Сообщение.message.entities) И Сообщение.message.entities[0].type = "bot_command" Тогда
			Если СообщениеОбъект.Свойство("text") Тогда
				//Текстовая команда
				ТекстПриятногоСообщения = СообщениеОбъект.text;
				Если Не ОбработатьТекстовуюКоманду(Токен, Отправитель, ТекстПриятногоСообщения,СообщениеОбъект.message_id).Ошибка Тогда
					Константы.ИДСообщенияTelegram.Установить(ИДСообщения);
				КонецЕсли;
				
				
				//Если ТекстПриятногоСообщения = "/start" Тогда
				//	//Стартовые кнопки
				//	//Клавиатура = СгенерироватьСтартовуюКлавиатуру();
				//	СоздатьПользователяTelegram(Отправитель);
				//	Клавиатура = ВзаимодействиеСTelegramСервер.СгенерироватьИнлайнКлавиатуру();
				//	ТекстОтвета = "Добавлены команды";
				//ИначеЕсли ТекстПриятногоСообщения = "/ping" Тогда
				//	ТекстОтвета = "Да, я здесь!"; 
				//ИначеЕсли
				//	ТекстПриятногоСообщения = "/current_tasks" Тогда
				//	СписокЗаявок = ВзаимодействиеСTelegramСервер.СформироватьДанныеПоЗаявкам(); 
				//Иначе
				//	ТекстОтвета = "Я тебя не понимаю(";
				//КонецЕсли;
			Иначе
				Если Не ОтправитьОтказВОбработке(Токен, Отправитель, СообщениеОбъект.message_id).Ошибка Тогда
					Константы.ИДСообщенияTelegram.Установить(ИДСообщения);
				КонецЕсли;
			КонецЕсли;
			
			//ИсходноеСообщение = Формат(Сообщение.message.message_id,"ЧГ=")

		ИначеЕсли ОбъектОбновления.Ключ = "callback_query" Тогда	//кнопка
			КомандаОбъект = ОбъектОбновления.Значение;
			//КомандаОбъект(CallbackQuery): https://core.telegram.org/bots/api/#callbackquery
			//+-------------------+---------+------------------------------------------------------------------------------------------------------------------------------------------------------------------+
			//| id                | String  | Unique identifier for this query                                                                                                                                 |
			//| from              | User    | Sender                                                                                                                                                           |
			//| message           | Message | Optional. Message with the callback button that originated the query. Note that message content and message date will not be available if the message is too old |
			//| inline_message_id | String  | Optional. Identifier of the message sent via the bot in inline mode, that originated the query.                                                                  |
			//| chat_instance     | String  | Global identifier, uniquely corresponding to the chat to which the message with the callback button was sent. Useful for high scores in games.                   |
			//| data              | String  | Optional. Data associated with the callback button. Be aware that a bad client can send arbitrary data in this field.                                            |
			//| game_short_name   | String  | Optional. Short name of a Game to be returned, serves as the unique identifier for the game                                                                      |
			//+-------------------+---------+------------------------------------------------------------------------------------------------------------------------------------------------------------------+
			
			Отправитель = КомандаОбъект.from;
			
		    Если Отправитель.is_bot Тогда	//с ботами не работаем 
				Возврат Ложь;
			КонецЕсли;
			Если Отправитель = Неопределено Тогда
				Возврат Ложь;
			КонецЕсли;
			
			ОтКогоИД = Формат(Отправитель.id, "ЧГ=");
			ОтКого = Отправитель.first_name + " " + Отправитель.last_name;
			ЗаписьЛога = РегистрыСведений.ЛогTelegram.СоздатьМенеджерЗаписи();
						
			//ЗаписьЛога.Период= ТекущаяДата();
			ЗаписьЛога.ДатаВремя = ТекущаяДата();
			ЗаписьЛога.Событие = "Пришло сообщение от " + ОтКого + " (" + ОтКогоИД + ")";
			ЗаписьЛога.GUID = Новый УникальныйИдентификатор();
			ЗаписьЛога.Записать();
			
			Если КомандаОбъект.Свойство("data") Тогда
				Данные = КомандаОбъект.data;
				
				Если Не ОбработатьКоманду(Токен, Отправитель, Данные).Ошибка Тогда
					Константы.ИДСообщенияTelegram.Установить(ИДСообщения);
				Иначе
					Если Не ОтправитьОшибкуВОбработке(Токен, Отправитель).Ошибка Тогда
						Константы.ИДСообщенияTelegram.Установить(ИДСообщения);
					КонецЕсли;
				КонецЕсли;
				
				//Если Данные = "ping" Тогда
				//	ТекстОтвета = "Да, я здесь!"; 
				//ИначеЕсли Данные = "currentTasks" Тогда
				//	//ТекстОтвета = "<Данный функционал в разработке>";
				//	СписокЗаявок = ВзаимодействиеСTelegramСервер.СформироватьДанныеПоЗаявкам();
				//Иначе
				//	ТекстОтвета = "Я тебя не понимаю(";
				//КонецЕсли;
			Иначе
				Если Не ОтправитьОшибкуВОбработке(Токен, Отправитель).Ошибка Тогда
					Константы.ИДСообщенияTelegram.Установить(ИДСообщения);
				КонецЕсли;				
				//ТекстОтвета = "Что-то пошло не так";
			КонецЕсли;
			Клавиатура = ВзаимодействиеСTelegramСервер.СгенерироватьИнлайнКлавиатуру();
		КонецЕсли;
	КонецЦикла;
	
	//Если Сообщение.Свойство("message") Тогда
	//	Отправитель = Сообщение.message.from;
	//	Если Отправитель.is_bot Тогда 
	//		Возврат Ложь;
	//	КонецЕсли;
	//	
	//	//Если Свойство(Сообщение.message.entities) И Сообщение.message.entities[0].type = "bot_command" Тогда
	//	Если Сообщение.message.Свойство("text") Тогда
	//		ТестПриятногоСообщения = Сообщение.message.text;
	//		Если Сообщение.message.text = "/start" Тогда
	//			//Стартовые кнопки
	//			//Клавиатура = СгенерироватьСтартовуюКлавиатуру();
	//			СоздатьПользователяTelegram(Отправитель);
	//			Клавиатура = ВзаимодействиеСTelegramСервер.СгенерироватьИнлайнКлавиатуру();
	//			ТекстОтвета = "Добавлены команды";
	//		ИначеЕсли Сообщение.message.text = "/ping" Тогда
	//			ТекстОтвета = "Да, я здесь!"; 
	//		ИначеЕсли
	//			Сообщение.message.text = "/current_tasks" Тогда
	//			СписокЗаявок = ВзаимодействиеСTelegramСервер.СформироватьДанныеПоЗаявкам(); 
	//		Иначе
	//			ТекстОтвета = "Я тебя не понимаю(";
	//		КонецЕсли;
	//	Иначе
	//		ТекстОтвета = "Я тебя не понимаю(";
	//	КонецЕсли;
	//	
	//	ИсходноеСообщение = Формат(Сообщение.message.message_id,"ЧГ=")
	//ИначеЕсли Сообщение.Свойство("callback_query") Тогда
	//	Отправитель = Сообщение.callback_query.from;
	//	
	//	Если Сообщение.callback_query.Свойство("data") Тогда
	//		Данные = Сообщение.callback_query.data;
	//		
	//		Если Данные = "ping" Тогда
	//			ТекстОтвета = "Да, я здесь!"; 
	//		ИначеЕсли Данные = "currentTasks" Тогда
	//			//ТекстОтвета = "<Данный функционал в разработке>";
	//			СписокЗаявок = ВзаимодействиеСTelegramСервер.СформироватьДанныеПоЗаявкам();
	//		Иначе
	//			ТекстОтвета = "Я тебя не понимаю(";
	//		КонецЕсли;
	//	Иначе
	//		ТекстОтвета = "Что-то пошло не так";
	//	КонецЕсли;
	//	Клавиатура = ВзаимодействиеСTelegramСервер.СгенерироватьИнлайнКлавиатуру();
	//КонецЕсли;
	
	

	//Если Не СписокЗаявок = Неопределено Тогда
	//	Для Каждого СтрокаСообщения Из СписокЗаявок Цикл
	//		
	//		// обновим лог событий
	//	
	//		// Для отправки сообщения нужно знать две вещи - идентификатор чата
	//		// и само сообщение. Снова создаем новый запрос к sendMessage и параметрами
	//		// chat_id и text
	//		ТекстОтвета = СтрокаСообщения;
	//		
	//		ТекстЗапроса = "/bot"+Токен + "/sendmessage?chat_id=" + ОтКогоИД + "&text=" + ТекстОтвета;
	//		Если Не ИсходноеСообщение = Неопределено Тогда
	//			ТекстЗапроса = ТекстЗапроса + "&reply_to_message_id=" + ИсходноеСообщение;
	//		КонецЕсли;
	//		
	//		//Если Не Клавиатура = Неопределено Тогда
	//		//	ТекстЗапроса = ТекстЗапроса + "&reply_markup=" + Клавиатура;
	//		//КонецЕсли;
	//		Запрос = Новый HTTPЗапрос(ТекстЗапроса);
	//		// собственно посылаем запрос и ждем сообщения от бота
	//		ИмяФайлаСообщение = ПолучитьИмяВременногоФайла("txt");
	//		Подключение.Получить(Запрос, ИмяФайлаСообщение);
	//	КонецЦикла;
	//	
	//	Константы.ИДСообщенияTelegram.Установить(ИДСообщения);
	//	
	//	ОтправитьНачальноеМеню(Токен,Подключение,ОтКогоИД);
	//	
	//	Возврат Истина;
	//КонецЕсли;
	
	//// обновим лог событий
	//
	//ЗаписьЛога = РегистрыСведений.ЛогTelegram.СоздатьМенеджерЗаписи();
	//	
	//ЗаписьЛога.Период= ТекущаяДата();
	//ЗаписьЛога.Событие = "Пришло сообщение от " + ОтКого + " (" + ОтКогоИД + ")";
	//ЗаписьЛога.GUID = Новый УникальныйИдентификатор();
	//ЗаписьЛога.Записать();
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
	
	Константы.ИДСообщенияTelegram.Установить(ИДСообщения);
КонецФункции

Функция ОбработатьТекстовуюКоманду(Токен,Отправитель,ТекстоваяКоманда,ИсходноеСообщение)
	Ошибка = Ложь;
	Ответ = "";
	
	//СписокЗаявок = Неопределено;
	
	Если ТекстоваяКоманда = "/start" Тогда	
		РезультатВыполнения = ВыполнитьКомандуStart(Токен,Отправитель,ИсходноеСообщение);
	ИначеЕсли ТекстоваяКоманда = "/ping" Тогда
		РезультатВыполнения = ВыполнитьКомандуPing(Токен,Отправитель,ИсходноеСообщение);
	ИначеЕсли ТекстоваяКоманда = "/current_tasks" Тогда
		РезультатВыполнения = ВыполнитьКомандуCurrentTasks(Токен,Отправитель);
	Иначе
		РезультатВыполнения = ВыполнитьНеизвестнуюКоманду(Токен,Отправитель,ИсходноеСообщение);
	КонецЕсли;
	
	//РезультатВыполнения = ОтправитьНачальноеМеню(Токен,,Отправитель.id);
	
	Возврат РезультатВыполнения;
	
	//Вывод списка заявок
	//Если Не СписокЗаявок = Неопределено Тогда
	//	Для Каждого СтрокаСообщения Из СписокЗаявок Цикл
	//		
	//		// обновим лог событий
	//	
	//		// Для отправки сообщения нужно знать две вещи - идентификатор чата
	//		// и само сообщение. Снова создаем новый запрос к sendMessage и параметрами
	//		// chat_id и text
	//		ТекстОтвета = СтрокаСообщения;
	//		
	//		ТекстЗапроса = "/bot"+Токен + "/sendmessage?chat_id=" + ОтКогоИД + "&text=" + ТекстОтвета;
	//		Если Не ИсходноеСообщение = Неопределено Тогда
	//			ТекстЗапроса = ТекстЗапроса + "&reply_to_message_id=" + ИсходноеСообщение;
	//		КонецЕсли;
	//		
	//		//Если Не Клавиатура = Неопределено Тогда
	//		//	ТекстЗапроса = ТекстЗапроса + "&reply_markup=" + Клавиатура;
	//		//КонецЕсли;
	//		Запрос = Новый HTTPЗапрос(ТекстЗапроса);
	//		// собственно посылаем запрос и ждем сообщения от бота
	//		ИмяФайлаСообщение = ПолучитьИмяВременногоФайла("txt");
	//		Подключение.Получить(Запрос, ИмяФайлаСообщение);
	//	КонецЦикла;
	//	
	//	Константы.ИДСообщенияTelegram.Установить(ИДСообщения);
	//	
	//	ОтправитьНачальноеМеню(Токен,Подключение,ОтКогоИД);
	//	
	//	Возврат Истина;
	//КонецЕсли;
	
	
	
	
	
	//ТекстЗапроса = "/bot"+Токен + "/sendmessage?chat_id=" + ChatID + "&text=" + ТекстОтвета;
	//Если Не ИсходноеСообщение = Неопределено Тогда
	//	ТекстЗапроса = ТекстЗапроса + "&reply_to_message_id=" + Формат(ИсходноеСообщение,"ЧГ=");
	//КонецЕсли;
	//
	//Если Не Клавиатура = Неопределено Тогда
	//	ТекстЗапроса = ТекстЗапроса + "&reply_markup=" + Клавиатура;
	//КонецЕсли;
	//Запрос = Новый HTTPЗапрос(ТекстЗапроса);
	//// собственно посылаем запрос и ждем сообщения от бота
	//ИмяФайлаСообщение = ПолучитьИмяВременногоФайла("txt");
	//Подключение.Получить(Запрос, ИмяФайлаСообщение);
	
КонецФункции

Функция ВыполнитьКомандуStart(Токен,Отправитель,ИсходноеСообщение=Неопределено,Подключение=Неопределено)
	Ошибка = Ложь;
	Ответ = "";
	
	Если Подключение = Неопределено Тогда
		Подключение = Новый HTTPСоединение("api.telegram.org", 443,,,,, Новый ЗащищенноеСоединениеOpenSSL());	
	КонецЕсли;
	//Стартовые кнопки
	ChatID = Формат(Отправитель.id, "ЧГ=");
	СоздатьПользователяTelegram(Отправитель);
	Клавиатура = ВзаимодействиеСTelegramСервер.СгенерироватьНачальноеМеню();
	ТекстОтвета = "Добавлены команды";
	ТекстЗапроса = "/bot"+Токен + "/sendmessage?chat_id=" + ChatID + "&text=" + ТекстОтвета;	
	
	Если Не ИсходноеСообщение = Неопределено Тогда
		ТекстЗапроса = ТекстЗапроса + "&reply_to_message_id=" + Формат(ИсходноеСообщение,"ЧГ=");
	КонецЕсли;
	
	Если Не Клавиатура = Неопределено Тогда
		ТекстЗапроса = ТекстЗапроса + "&reply_markup=" + Клавиатура;
	КонецЕсли;
	Запрос = Новый HTTPЗапрос(ТекстЗапроса);

	//ИмяФайлаСообщение = ПолучитьИмяВременногоФайла("txt");
	Попытка
		Ответ = Подключение.Получить(Запрос);
	Исключение
		Ошибка = Истина;
	КонецПопытки;
	
	Возврат Новый Структура("Ответ,Ошибка",Ответ,Ошибка);
КонецФункции

Функция ВыполнитьКомандуPing(Токен,Отправитель,ИсходноеСообщение=Неопределено,Подключение=Неопределено)
	Ошибка = Ложь;  
	Ответ = "";
	
	Если Подключение = Неопределено Тогда
		Подключение = Новый HTTPСоединение("api.telegram.org", 443,,,,, Новый ЗащищенноеСоединениеOpenSSL());	
	КонецЕсли;
	
	//Стартовые кнопки
	ChatID = Формат(Отправитель.id, "ЧГ=");
	Клавиатура = ВзаимодействиеСTelegramСервер.СгенерироватьНачальноеМеню();
	ТекстОтвета = "Да, я здесь!"; 
	ТекстЗапроса = "/bot"+Токен + "/sendmessage?chat_id=" + ChatID + "&text=" + ТекстОтвета;	
	
	Если Не ИсходноеСообщение = Неопределено Тогда
		ТекстЗапроса = ТекстЗапроса + "&reply_to_message_id=" + Формат(ИсходноеСообщение,"ЧГ=");
	КонецЕсли;
	
	Если Не Клавиатура = Неопределено Тогда
		ТекстЗапроса = ТекстЗапроса + "&reply_markup=" + Клавиатура;
	КонецЕсли;
	Запрос = Новый HTTPЗапрос(ТекстЗапроса);

	//ИмяФайлаСообщение = ПолучитьИмяВременногоФайла("txt");
	Попытка
		Ответ = Подключение.Получить(Запрос);
	Исключение
		Ошибка = Истина;
	КонецПопытки;
	
	Возврат Новый Структура("Ответ,Ошибка",Ответ,Ошибка);
КонецФункции

//Заглушка
Функция ВыполнитьНеизвестнуюКоманду(Токен,Отправитель,ИсходноеСообщение=Неопределено,Подключение=Неопределено)
	Ошибка = Ложь;  
	Ответ = "";
	
	Если Подключение = Неопределено Тогда
		Подключение = Новый HTTPСоединение("api.telegram.org", 443,,,,, Новый ЗащищенноеСоединениеOpenSSL());	
	КонецЕсли;
	
	//Стартовые кнопки
	ChatID = Формат(Отправитель.id, "ЧГ=");
	Клавиатура = ВзаимодействиеСTelegramСервер.СгенерироватьНачальноеМеню();
	ТекстОтвета = "Я тебя не понимаю("; 
	ТекстЗапроса = "/bot"+Токен + "/sendmessage?chat_id=" + ChatID + "&text=" + ТекстОтвета;	
	
	Если Не ИсходноеСообщение = Неопределено Тогда
		ТекстЗапроса = ТекстЗапроса + "&reply_to_message_id=" + Формат(ИсходноеСообщение,"ЧГ=");
	КонецЕсли;
	
	Если Не Клавиатура = Неопределено Тогда
		ТекстЗапроса = ТекстЗапроса + "&reply_markup=" + Клавиатура;
	КонецЕсли;
	Запрос = Новый HTTPЗапрос(ТекстЗапроса);

	Попытка
		Ответ = Подключение.Получить(Запрос);
	Исключение
		Ошибка = Истина;
	КонецПопытки;
	
	Возврат Новый Структура("Ответ,Ошибка",Ответ,Ошибка);
КонецФункции

Функция ВыполнитьКомандуCurrentTasks(Токен,Отправитель,Подключение=Неопределено,НовыйФормат=Ложь,ПараметрыКоманды=Неопределено)
	Ошибка = Ложь;
	Ответ = "";
	
	УстановитьСтандартноеПодключение(Подключение);               	
	Если НовыйФормат Тогда
		Если ПараметрыКоманды = Неопределено Или ПараметрыКоманды.Количество() = 0 Тогда
			//Запрашиваем параметры (заявки какого исполнителя отображать)
			Ответ = CurrentTasksОтправитьЗапросИсполнителя(Токен,Отправитель,Подключение);			
		Иначе
			Страница = ?(ПараметрыКоманды.Свойство("pg"),ПараметрыКоманды.pg,Неопределено);
			Если ПараметрыКоманды.Свойство("u") Тогда
				Если ПараметрыКоманды.u = "_all_" Тогда
					Исполнитель = Неопределено;
				ИначеЕсли ПараметрыКоманды.u = "_undefined_" Тогда
					Исполнитель = Справочники.ФизическиеЛица.ПустаяСсылка();
				Иначе
					Исполнитель = Справочники.ФизическиеЛица.ПолучитьСсылку(Новый УникальныйИдентификатор(ПараметрыКоманды.u));
				КонецЕсли;
			Иначе
				Исполнитель = Неопределено;
			КонецЕсли;
			СписокЗаявок = ВзаимодействиеСTelegramСервер.СформироватьДанныеПоЗаявкам(Исполнитель,Страница); 
			
			Для Каждого СтрокаСообщения Из СписокЗаявок Цикл
				
				// обновим лог событий

				// Для отправки сообщения нужно знать две вещи - идентификатор чата
				// и само сообщение. Снова создаем новый запрос к sendMessage и параметрами
				// chat_id и text
				ТекстОтвета = СтрокаСообщения;
				
				ТекстЗапроса = "/bot"+Токен + "/sendmessage?chat_id=" + Формат(Отправитель.id,"ЧГ=") + "&text=" + ТекстОтвета;
				//Если Не ИсходноеСообщение = Неопределено Тогда
				//	ТекстЗапроса = ТекстЗапроса + "&reply_to_message_id=" + Формат(ИсходноеСообщение,"ЧГ=");
				//КонецЕсли;
				
				Запрос = Новый HTTPЗапрос(ТекстЗапроса);
				Попытка
					Подключение.Получить(Запрос);
				Исключение
					Ошибка = Истина;
					Возврат Новый Структура("Ответ,Ошибка",Ответ,Ошибка);
				КонецПопытки;
			КонецЦикла;
			Ответ = ОтправитьНачальноеМеню(Токен,Подключение,Отправитель.id).Ответ;			
		КонецЕсли;
	Иначе
		СписокЗаявок = ВзаимодействиеСTelegramСервер.СформироватьДанныеПоЗаявкам(); 
			
		Для Каждого СтрокаСообщения Из СписокЗаявок Цикл
			
			// обновим лог событий

			// Для отправки сообщения нужно знать две вещи - идентификатор чата
			// и само сообщение. Снова создаем новый запрос к sendMessage и параметрами
			// chat_id и text
			ТекстОтвета = СтрокаСообщения;
			
			ТекстЗапроса = "/bot"+Токен + "/sendmessage?chat_id=" + Формат(Отправитель.id,"ЧГ=") + "&text=" + ТекстОтвета;
			//Если Не ИсходноеСообщение = Неопределено Тогда
			//	ТекстЗапроса = ТекстЗапроса + "&reply_to_message_id=" + Формат(ИсходноеСообщение,"ЧГ=");
			//КонецЕсли;
			
			Запрос = Новый HTTPЗапрос(ТекстЗапроса);
			Попытка
				Подключение.Получить(Запрос);
			Исключение
				Ошибка = Истина;
				Возврат Новый Структура("Ответ,Ошибка",Ответ,Ошибка);
			КонецПопытки;
		КонецЦикла;
		Ответ = ОтправитьНачальноеМеню(Токен,Подключение,Отправитель.id).Ответ;		
	КонецЕсли;
	
	//Возврат ОтправитьНачальноеМеню(Токен,Подключение,Отправитель.id);
	Возврат Новый Структура("Ответ,Ошибка",Ответ,Ошибка);
КонецФункции


// Выполняет команду getLicense: в зависимости от полученных параметром выводит запрос уточняющей информации или данные
// лицензии
// 
// Параметры:
//  Токен - Строка - Токен бота Telegram
//  Отправитель - Число - ID чата-отправителя запроса
//  Подключение - HTTPСоединение - Существующее HTTPСоединение взаимодействия с API Telegram 
//  ПараметрыКоманды - Структура - Параметры команды getLicense:
// * c - Строка - имя команды, всегда "getLicense"
// * ac - Число - подкоманда: 1 - номенклатура, 2 - вывод реализаций, 3 - вывод лицензий реализации, 4 - вывод лицензии  
// * ou - Строка - ссылка на клиента в базе
// * w - Строка - ссылка на номенклатуру в базе
// * li - Строка - ссылка на реализацию лицензий в базе
// * pg - Число - номер страницы списка документов реализации с лицензиями клиента
// * l - Строка - УникальныйИдентификатор представления лицензии  
// Возвращаемое значение:
//  Структура - Выполнить команду get license:
// * Ответ - Строка -
// * Ошибка - Булево -
Функция ВыполнитьКомандуGetLicense(Токен,Отправитель,Подключение=Неопределено,ПараметрыКоманды=Неопределено)
	Ошибка = Ложь;
	Ответ = "";
	
	УстановитьСтандартноеПодключение(Подключение);               	
	Если ПараметрыКоманды = Неопределено Или ПараметрыКоманды.Количество() = 0 Или Не ПараметрыКоманды.Свойство("ac") Тогда
		//Запрашиваем параметры (реализации лицензий какого клиента отобразить)
		Если ПараметрыКоманды.Свойство("pg") Тогда
			Страница = ПараметрыКоманды.pg;
		Иначе
			Страница = 1;
		КонецЕсли;
		Ответ = GetLicenseОтправитьЗапросКлиента(Токен,Отправитель,Подключение,Страница);			
	ИначеЕсли ПараметрыКоманды.Свойство("ac") Тогда

		Если ПараметрыКоманды.ac = 1 Тогда
		// 1 - вывод номенклатуры
			Клиент = Справочники.Клиенты.ПолучитьСсылку(Новый УникальныйИдентификатор(ПараметрыКоманды.ou));
			Если ПараметрыКоманды.Свойство("pg") Тогда
				Страница = ПараметрыКоманды.pg;
			Иначе
				Страница = 1;
			КонецЕсли;
			Ответ = GetLicenseОтправитьЗапросНоменклатуры(Токен,Отправитель,Подключение,Клиент,Страница);
		ИначеЕсли ПараметрыКоманды.ac = 2 Тогда
		// 2 - вывод реализаций
			Клиент = Справочники.Клиенты.ПолучитьСсылку(Новый УникальныйИдентификатор(ПараметрыКоманды.ou));
			Номенклатура = Справочники.Номенклатура.ПолучитьСсылку(Новый УникальныйИдентификатор(ПараметрыКоманды.w));
			Если ПараметрыКоманды.Свойство("pg") Тогда
				Страница = ПараметрыКоманды.pg;
			Иначе
				Страница = 1;
			КонецЕсли;
			Ответ = GetLicenseОтправитьЗапросРеализации(Токен,Отправитель,Подключение,Клиент,Номенклатура,Страница);
		// 3 - вывод лицензий реализации
		ИначеЕсли ПараметрыКоманды.ac = 3 Тогда
			Реализация = Документы.РеализацияЛицензий.ПолучитьСсылку(Новый УникальныйИдентификатор(ПараметрыКоманды.li));
			Клиент = Справочники.Клиенты.ПолучитьСсылку(Новый УникальныйИдентификатор(ПараметрыКоманды.ou));
			Номенклатура = Справочники.Номенклатура.ПолучитьСсылку(Новый УникальныйИдентификатор(ПараметрыКоманды.w));
			Если ПараметрыКоманды.Свойство("pg") Тогда
				Страница = ПараметрыКоманды.pg;
			Иначе
				Страница = 1;
			КонецЕсли;
			Ответ = GetLicenseОтправитьЗапросЛицензийРеализации(Токен,Отправитель,Подключение,Реализация,Клиент,Номенклатура,Страница);
		// 4 - вывод лицензии 
		ИначеЕсли ПараметрыКоманды.ac = 4 Тогда
			ЛицензияID = ПараметрыКоманды.l;
			Лицензия = ПолучитьДанныеЛицензииПоИдентификатору(ЛицензияID);
			Ответ = GetLicenseОтправитьВыводЛицензии(Токен,Отправитель,Подключение,Лицензия);
		КонецЕсли;			
	КонецЕсли;
	
	//Возврат ОтправитьНачальноеМеню(Токен,Подключение,Отправитель.id);
	Возврат Новый Структура("Ответ,Ошибка",Ответ,Ошибка);
КонецФункции


// Запрашивает клиента, реализации лицензий которого отобразить
// 
// Параметры:
//  Токен - Строка - Токен бота Telegram
//  Отправитель - Число - ID чата-отправителя
//  Подключение - Неопределено, HTTPСоединение - Соединение с API Telegram
// 
// Возвращаемое значение:
//  
Функция GetLicenseОтправитьЗапросКлиента(Токен,Отправитель,Подключение=Неопределено,Страница=1)
	УстановитьСтандартноеПодключение(Подключение);
	МассивСтрокКнопок = Новый Массив;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Клиенты.Ссылка,
		|	Клиенты.Наименование КАК Наименование
		|ИЗ
		|	Справочник.Клиенты КАК Клиенты
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.Лицензии КАК Лицензии
		|		ПО Лицензии.Регистратор.Контрагент = Клиенты.Контрагент
		|ГДЕ
		|	НЕ Клиенты.ПометкаУдаления
		|	ИЛИ НЕ Клиенты.Контрагент.ПометкаУдаления
		|
		|УПОРЯДОЧИТЬ ПО
		|	Наименование";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	КоличествоЗаписей = ВыборкаДетальныеЗаписи.Количество();
	
	Если КоличествоЗаписей > 0 Тогда
		НомерЗаписи = 0;
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			НомерЗаписи = НомерЗаписи + 1;
			Если НомерЗаписи <= (Страница - 1) * 10 Тогда
				Продолжить;
			ИначеЕсли НомерЗаписи > Страница * 10 Тогда
				Прервать;
			Иначе
				МассивКнопок = Новый Массив;
				ПараметрыКнопки = Новый Структура();
				ПараметрыКнопки.Вставить("text",ВыборкаДетальныеЗаписи.Наименование);
				ПараметрыКнопки.Вставить("callback_data",ПолучитьДанныеКомандыGetLicense(1,ВыборкаДетальныеЗаписи.Ссылка,,,,,Отправитель.id));
				МассивКнопок.Добавить(ПараметрыКнопки);
				МассивСтрокКнопок.Добавить(МассивКнопок);
			КонецЕсли;
		КонецЦикла;        	
		
		//первая страница
		МассивКнопок = Новый Массив;
		ПараметрыКнопки = Новый Структура();
		ПараметрыКнопки.Вставить("text","<<");
		ПараметрыКнопки.Вставить("callback_data",ПолучитьДанныеКомандыGetLicense(,,1,,,,Отправитель.id));
		МассивКнопок.Добавить(ПараметрыКнопки);				

		//предыдущая страница
		Если Страница > 1 Тогда
			ПараметрыКнопки = Новый Структура();
			ПараметрыКнопки.Вставить("text","<");
			ПараметрыКнопки.Вставить("callback_data",ПолучитьДанныеКомандыGetLicense(,,Страница-1,,,,Отправитель.id));
			МассивКнопок.Добавить(ПараметрыКнопки);
		КонецЕсли;
		
		//следующая страница
		Если Страница < КоличествоЗаписей / 10 Тогда
			ПараметрыКнопки = Новый Структура();
			ПараметрыКнопки.Вставить("text",">");
			ПараметрыКнопки.Вставить("callback_data",ПолучитьДанныеКомандыGetLicense(,,Страница+1,,,,Отправитель.id));
			МассивКнопок.Добавить(ПараметрыКнопки);
		КонецЕсли;
		
		//последняя страница
		ПараметрыКнопки = Новый Структура();
		ПараметрыКнопки.Вставить("text",">>");
		ПараметрыКнопки.Вставить("callback_data",ПолучитьДанныеКомандыGetLicense(,,ОкруглитьВерх(КоличествоЗаписей / 10),,,,Отправитель.id));
		МассивКнопок.Добавить(ПараметрыКнопки);				
		
		МассивСтрокКнопок.Добавить(МассивКнопок);
		
		Клавиатура = СгенерироватьИнлайнКлавиатуру(МассивСтрокКнопок);
		Ответ = ОтправитьКлавиатуру(Токен,Подключение,Отправитель.id,Клавиатура,"На кого реализована?");
	Иначе
		// нет клиентов для страницы
		СгенерироватьСтартовуюКлавиатуру();
	КонецЕсли;
	
	Возврат Ответ;
КонецФункции

Функция GetLicenseОтправитьЗапросНоменклатуры(Токен,Отправитель,Подключение=Неопределено,Клиент=Неопределено,Страница=1)
	УстановитьСтандартноеПодключение(Подключение);
	МассивСтрокКнопок = Новый Массив;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	РеализацияЛицензийТовары.Номенклатура КАК Номенклатура,
		|	РеализацияЛицензийТовары.Номенклатура.Наименование КАК Наименование
		|ИЗ
		|	Документ.РеализацияЛицензий.Товары КАК РеализацияЛицензийТовары
		|ГДЕ
		|	РеализацияЛицензийТовары.Ссылка ССЫЛКА Документ.РеализацияЛицензий
		|	И (РеализацияЛицензийТовары.Клиент = &Клиент
		|	ИЛИ РеализацияЛицензийТовары.Клиент = ЗНАЧЕНИЕ(Справочник.Клиенты.ПустаяСсылка)
		|	И РеализацияЛицензийТовары.Ссылка.Контрагент = &Контрагент)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Наименование";
	
	Запрос.УстановитьПараметр("Клиент", Клиент);
	Запрос.УстановитьПараметр("Контрагент",Клиент.Контрагент);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	КоличествоЗаписей = ВыборкаДетальныеЗаписи.Количество();
	
	Если КоличествоЗаписей > 0 Тогда
		НомерЗаписи = 0;
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			НомерЗаписи = НомерЗаписи + 1;
			Если НомерЗаписи <= (Страница - 1) * 10 Тогда
				Продолжить;
			ИначеЕсли НомерЗаписи > Страница * 10 Тогда
				Прервать;
			Иначе
				МассивКнопок = Новый Массив;
				ПараметрыКнопки = Новый Структура();
				ПараметрыКнопки.Вставить("text",ВыборкаДетальныеЗаписи.Наименование);
				ПараметрыКнопки.Вставить("callback_data",ПолучитьДанныеКомандыGetLicense(2,Клиент,,ВыборкаДетальныеЗаписи.Номенклатура,,,Отправитель.id));
				МассивКнопок.Добавить(ПараметрыКнопки);
				МассивСтрокКнопок.Добавить(МассивКнопок);
			КонецЕсли;
		КонецЦикла;        	
		
		//первая страница
		МассивКнопок = Новый Массив;
		ПараметрыКнопки = Новый Структура();
		ПараметрыКнопки.Вставить("text","<<");
		ПараметрыКнопки.Вставить("callback_data",ПолучитьДанныеКомандыGetLicense(1,Клиент,1,,,,Отправитель.id));
		МассивКнопок.Добавить(ПараметрыКнопки);				

		//предыдущая страница
		Если Страница > 1 Тогда
			ПараметрыКнопки = Новый Структура();
			ПараметрыКнопки.Вставить("text","<");
			ПараметрыКнопки.Вставить("callback_data",ПолучитьДанныеКомандыGetLicense(1,Клиент,Страница-1,,,,Отправитель.id));
			МассивКнопок.Добавить(ПараметрыКнопки);
		КонецЕсли;
		
		//следующая страница
		Если Страница < КоличествоЗаписей / 10 Тогда
			ПараметрыКнопки = Новый Структура();
			ПараметрыКнопки.Вставить("text",">");
			ПараметрыКнопки.Вставить("callback_data",ПолучитьДанныеКомандыGetLicense(1,Клиент,Страница+1,,,,Отправитель.id));
			МассивКнопок.Добавить(ПараметрыКнопки);
		КонецЕсли;
		
		//последняя страница
		ПараметрыКнопки = Новый Структура();
		ПараметрыКнопки.Вставить("text",">>");
		ПараметрыКнопки.Вставить("callback_data",ПолучитьДанныеКомандыGetLicense(1,Клиент,ОкруглитьВерх(КоличествоЗаписей / 10),,,,Отправитель.id));
		МассивКнопок.Добавить(ПараметрыКнопки);				
		
		МассивСтрокКнопок.Добавить(МассивКнопок);
		
		Клавиатура = СгенерироватьИнлайнКлавиатуру(МассивСтрокКнопок);
		Ответ = ОтправитьКлавиатуру(Токен,Подключение,Отправитель.id,Клавиатура,"Какой продукт?");
	Иначе
		// нет номенклатуры для страницы
		СгенерироватьСтартовуюКлавиатуру();
	КонецЕсли;
	
	Возврат Ответ;
КонецФункции

Функция GetLicenseОтправитьЗапросРеализации(Токен,Отправитель,Подключение=Неопределено,Клиент=Неопределено,Номенклатура=Неопределено,Страница=1)
	УстановитьСтандартноеПодключение(Подключение);
	МассивСтрокКнопок = Новый Массив;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	РеализацияЛицензийТовары.Ссылка,
		|	РеализацияЛицензийТовары.Ссылка.Дата КАК Дата
		|ИЗ
		|	Документ.РеализацияЛицензий.Товары КАК РеализацияЛицензийТовары
		|ГДЕ
		|	РеализацияЛицензийТовары.Ссылка ССЫЛКА Документ.РеализацияЛицензий
		|	И ((РеализацияЛицензийТовары.Клиент = &Клиент
		|	ИЛИ РеализацияЛицензийТовары.Клиент = ЗНАЧЕНИЕ(Справочник.Клиенты.ПустаяСсылка)
		|	И РеализацияЛицензийТовары.Ссылка.Контрагент = &Контрагент)
		|	И РеализацияЛицензийТовары.Номенклатура = &Номенклатура)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Дата УБЫВ";
	
	Запрос.УстановитьПараметр("Клиент", Клиент);
	Запрос.УстановитьПараметр("Контрагент",Клиент.Контрагент);
	Запрос.УстановитьПараметр("Номенклатура",Номенклатура);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	КоличествоЗаписей = ВыборкаДетальныеЗаписи.Количество();
	
	Если КоличествоЗаписей > 0 Тогда
		НомерЗаписи = 0;
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			НомерЗаписи = НомерЗаписи + 1;
			Если НомерЗаписи <= (Страница - 1) * 10 Тогда
				Продолжить;
			ИначеЕсли НомерЗаписи > Страница * 10 Тогда
				Прервать;
			Иначе
				МассивКнопок = Новый Массив;
				ПараметрыКнопки = Новый Структура();
				ПараметрыКнопки.Вставить("text","от " + ВыборкаДетальныеЗаписи.Дата);
				ПараметрыКнопки.Вставить("callback_data",ПолучитьДанныеКомандыGetLicense(3,Клиент,,Номенклатура,ВыборкаДетальныеЗаписи.Ссылка,,Отправитель.id));
				МассивКнопок.Добавить(ПараметрыКнопки);
				МассивСтрокКнопок.Добавить(МассивКнопок);
			КонецЕсли;
		КонецЦикла;        	
		
		//первая страница
		МассивКнопок = Новый Массив;
		ПараметрыКнопки = Новый Структура();
		ПараметрыКнопки.Вставить("text","<<");
		ПараметрыКнопки.Вставить("callback_data",ПолучитьДанныеКомандыGetLicense(2,Клиент,1,Номенклатура,,,Отправитель.id));
		МассивКнопок.Добавить(ПараметрыКнопки);				

		//предыдущая страница
		Если Страница > 1 Тогда
			ПараметрыКнопки = Новый Структура();
			ПараметрыКнопки.Вставить("text","<");
			ПараметрыКнопки.Вставить("callback_data",ПолучитьДанныеКомандыGetLicense(2,Клиент,Страница-1,Номенклатура,,,Отправитель.id));
			МассивКнопок.Добавить(ПараметрыКнопки);
		КонецЕсли;
		
		//следующая страница
		Если Страница < КоличествоЗаписей / 10 Тогда
			ПараметрыКнопки = Новый Структура();
			ПараметрыКнопки.Вставить("text",">");
			ПараметрыКнопки.Вставить("callback_data",ПолучитьДанныеКомандыGetLicense(2,Клиент,Страница+1,Номенклатура,,,Отправитель.id));
			МассивКнопок.Добавить(ПараметрыКнопки);
		КонецЕсли;
		
		//последняя страница
		ПараметрыКнопки = Новый Структура();
		ПараметрыКнопки.Вставить("text",">>");
		ПараметрыКнопки.Вставить("callback_data",ПолучитьДанныеКомандыGetLicense(2,Клиент,ОкруглитьВерх(КоличествоЗаписей / 10),Номенклатура,,,Отправитель.id));
		МассивКнопок.Добавить(ПараметрыКнопки);				
		
		МассивСтрокКнопок.Добавить(МассивКнопок);
		
		Клавиатура = СгенерироватьИнлайнКлавиатуру(МассивСтрокКнопок);
		Ответ = ОтправитьКлавиатуру(Токен,Подключение,Отправитель.id,Клавиатура,"По какой реализации?");
	Иначе
		// нет реализаций для страницы
		СгенерироватьСтартовуюКлавиатуру();
	КонецЕсли;
	
	Возврат Ответ;
КонецФункции

Функция GetLicenseОтправитьЗапросЛицензийРеализации(Токен,Отправитель,Подключение=Неопределено,Реализация=Неопределено,Клиент=Неопределено,Номенклатура=Неопределено,Страница=1)
	УстановитьСтандартноеПодключение(Подключение);
	МассивСтрокКнопок = Новый Массив;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	РеализацияЛицензийТовары.Номенклатура,
		|	РеализацияЛицензийТовары.КодАктивации,
		|	РеализацияЛицензийТовары.Серия,
		|	РеализацияЛицензийТовары.РегистрационныйНомер,
		|	РеализацияЛицензийТовары.Номенклатура.Наименование КАК Наименование
		|ИЗ
		|	Документ.РеализацияЛицензий.Товары КАК РеализацияЛицензийТовары
		|ГДЕ
		|	РеализацияЛицензийТовары.Ссылка = &Ссылка И
		|	(РеализацияЛицензийТовары.Клиент = &Клиент
		|	ИЛИ РеализацияЛицензийТовары.Клиент = ЗНАЧЕНИЕ(Справочник.Клиенты.ПустаяСсылка))
		|	И РеализацияЛицензийТовары.Номенклатура = &Номенклатура
		|
		|УПОРЯДОЧИТЬ ПО
		|	Наименование";
	
	Запрос.УстановитьПараметр("Ссылка",Реализация);
	Запрос.УстановитьПараметр("Клиент",Клиент);
	Запрос.УстановитьПараметр("Номенклатура",Номенклатура);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	КоличествоЗаписей = ВыборкаДетальныеЗаписи.Количество();
	
	Если КоличествоЗаписей > 0 Тогда
		НомерЗаписи = 0;
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			НомерЗаписи = НомерЗаписи + 1;
			Если НомерЗаписи <= (Страница - 1) * 10 Тогда
				Продолжить;
			ИначеЕсли НомерЗаписи > Страница * 10 Тогда
				Прервать;
			Иначе
				МассивКнопок = Новый Массив;
				ПараметрыКнопки = Новый Структура();
				ПараметрыКнопки.Вставить("text","S(" + ВыборкаДетальныеЗаписи.Серия + ")R(" + ВыборкаДетальныеЗаписи.РегистрационныйНомер + ")K(" + ВыборкаДетальныеЗаписи.КодАктивации + ")");
				ПараметрыКнопки.Вставить("callback_data",ПолучитьДанныеКомандыGetLicense(4,,,,,ПолучитьИдентификаторЛицензии(ВыборкаДетальныеЗаписи.Номенклатура,ВыборкаДетальныеЗаписи.Серия,ВыборкаДетальныеЗаписи.РегистрационныйНомер,ВыборкаДетальныеЗаписи.КодАктивации),Отправитель.id));
				МассивКнопок.Добавить(ПараметрыКнопки);
				МассивСтрокКнопок.Добавить(МассивКнопок);
			КонецЕсли;
		КонецЦикла;        	
		
		//первая страница
		МассивКнопок = Новый Массив;
		ПараметрыКнопки = Новый Структура();
		ПараметрыКнопки.Вставить("text","<<");
		ПараметрыКнопки.Вставить("callback_data",ПолучитьДанныеКомандыGetLicense(3,Клиент,1,Номенклатура,Реализация,,Отправитель.id));
		МассивКнопок.Добавить(ПараметрыКнопки);				

		//предыдущая страница
		Если Страница > 1 Тогда
			ПараметрыКнопки = Новый Структура();
			ПараметрыКнопки.Вставить("text","<");
			ПараметрыКнопки.Вставить("callback_data",ПолучитьДанныеКомандыGetLicense(3,Клиент,Страница-1,Номенклатура,Реализация,,Отправитель.id));
			МассивКнопок.Добавить(ПараметрыКнопки);
		КонецЕсли;
		
		//следующая страница
		Если Страница < КоличествоЗаписей / 10 Тогда
			ПараметрыКнопки = Новый Структура();
			ПараметрыКнопки.Вставить("text",">");
			ПараметрыКнопки.Вставить("callback_data",ПолучитьДанныеКомандыGetLicense(3,Клиент,Страница+1,Номенклатура,Реализация,,Отправитель.id));
			МассивКнопок.Добавить(ПараметрыКнопки);
		КонецЕсли;
		
		//последняя страница
		ПараметрыКнопки = Новый Структура();
		ПараметрыКнопки.Вставить("text",">>");
		ПараметрыКнопки.Вставить("callback_data",ПолучитьДанныеКомандыGetLicense(3,Клиент,ОкруглитьВерх(КоличествоЗаписей / 10),Номенклатура,Реализация,,Отправитель.id));
		МассивКнопок.Добавить(ПараметрыКнопки);				
		
		МассивСтрокКнопок.Добавить(МассивКнопок);
		
		Клавиатура = СгенерироватьИнлайнКлавиатуру(МассивСтрокКнопок);
		Ответ = ОтправитьКлавиатуру(Токен,Подключение,Отправитель.id,Клавиатура,"Какая лицензия?");
	Иначе
		// нет реализаций для страницы
		СгенерироватьСтартовуюКлавиатуру();
	КонецЕсли;
	
	Возврат Ответ;
КонецФункции


// Get license отправить вывод лицензии.
// 
// Параметры:
//  Токен - Строка - Токен Telegram Bot
//  Отправитель - Число - ID чата-отправителя
//  Подключение - Неопределено, HTTPСоединение - соединение с API Telegram
//  Лицензия - Структура - Выводимая лицензия:
//   * Номенклатура - СправочникСсылка.Номенклатура - Номенклатура, которой принадлежит лицензия
//   * Серия - Строка - Серия
//   * Номер - Строка - Регистрационный номер
//   * КодАктивации - Строка - Код активации
// Возвращаемое значение:
//  Число - Get license отправить вывод лицензии
Функция GetLicenseОтправитьВыводЛицензии(Токен,Отправитель,Подключение=Неопределено,Лицензия)
//	Номенклатура = Лицензия.Номенклатура;
//	Серия = Лицензия.Серия;
//	Номер = Лицензия.Номер;
//	КодАктивации = Лицензия.КодАктивации;
	
//	QRСерия = ПолучитьQR(Серия);
//	QRНомер = ПолучитьQR(Номер);
//	QRКодАктивации = ПолучитьQR(КодАктивации);

	КарточкаЛицензии = ПолучитьКарточкуЛицензии(Лицензия);
	КарточкаЛицензииПуть = ПолучитьИмяВременногоФайла("pdf");
	КарточкаЛицензии.Записать(КарточкаЛицензииПуть,ТипФайлаТабличногоДокумента.PDF);

	ОтправитьДокумент(Токен, Формат(Отправитель.id,"ЧГ="), "Карточка лицензии", КарточкаЛицензииПуть, Подключение);
	ОтправитьНачальноеМеню(Токен, Подключение, Формат(Отправитель.id,"ЧГ="));

	Возврат 0;
КонецФункции

//Отправляет ответ-заглушку на неизвестную команду
Функция ОтправитьОтказВОбработке(Токен,Отправитель,ИсходноеСообщение=Неопределено,Подключение=Неопределено)
	Ошибка = Ложь;  
	Ответ = "";
	
	Если Подключение = Неопределено Тогда
		Подключение = Новый HTTPСоединение("api.telegram.org", 443,,,,, Новый ЗащищенноеСоединениеOpenSSL());	
	КонецЕсли;
	
	//Стартовые кнопки
	ChatID = Формат(Отправитель.id, "ЧГ=");
	Клавиатура = ВзаимодействиеСTelegramСервер.СгенерироватьНачальноеМеню();
	ТекстОтвета = "Я тебя не понимаю("; 
	ТекстЗапроса = "/bot"+Токен + "/sendmessage?chat_id=" + ChatID + "&text=" + ТекстОтвета;	
	
	Если Не ИсходноеСообщение = Неопределено Тогда
		ТекстЗапроса = ТекстЗапроса + "&reply_to_message_id=" + Формат(ИсходноеСообщение,"ЧГ=");
	КонецЕсли;
	
	Если Не Клавиатура = Неопределено Тогда
		ТекстЗапроса = ТекстЗапроса + "&reply_markup=" + Клавиатура;
	КонецЕсли;
	Запрос = Новый HTTPЗапрос(ТекстЗапроса);

	//ИмяФайлаСообщение = ПолучитьИмяВременногоФайла("txt");
	Попытка
		Ответ = Подключение.Получить(Запрос);
	Исключение
		Ошибка = Истина;
	КонецПопытки;
	
	Возврат Новый Структура("Ответ,Ошибка",Ответ,Ошибка);
КонецФункции

//Отправляет ответ-заглушку на ошибку при обработке команды
Функция ОтправитьОшибкуВОбработке(Токен,Отправитель,Подключение=Неопределено)
	Ошибка = Ложь;  
	Ответ = "";
	
	Если Подключение = Неопределено Тогда
		Подключение = Новый HTTPСоединение("api.telegram.org", 443,,,,, Новый ЗащищенноеСоединениеOpenSSL());	
	КонецЕсли;
	
	//Стартовые кнопки
	ChatID = Формат(Отправитель.id, "ЧГ=");
	Клавиатура = ВзаимодействиеСTelegramСервер.СгенерироватьНачальноеМеню();
	ТекстОтвета = "Что-то пошло не так";
	ТекстЗапроса = "/bot"+Токен + "/sendmessage?chat_id=" + ChatID + "&text=" + ТекстОтвета;	
	
	//Если Не ИсходноеСообщение = Неопределено Тогда
	//	ТекстЗапроса = ТекстЗапроса + "&reply_to_message_id=" + Формат(ИсходноеСообщение,"ЧГ=");
	//КонецЕсли;
	
	Если Не Клавиатура = Неопределено Тогда
		ТекстЗапроса = ТекстЗапроса + "&reply_markup=" + Клавиатура;
	КонецЕсли;
	Запрос = Новый HTTPЗапрос(ТекстЗапроса);

	//ИмяФайлаСообщение = ПолучитьИмяВременногоФайла("txt");
	Попытка
		Ответ = Подключение.Получить(Запрос);
	Исключение
		Ошибка = Истина;
	КонецПопытки;
	
	Возврат Новый Структура("Ответ,Ошибка",Ответ,Ошибка);
КонецФункции

//Обработка команд из Inline-клавиатуры
Функция ОбработатьКоманду(Токен,Отправитель,ДанныеКоманды)
	Ошибка = Ложь;
	Ответ = "";
	
	Команда = ПолучитьСтруктурированныеДанныеJSON(ДанныеКоманды);
	
	Если Команда = Неопределено Тогда	//старый формат команд
	
		Если ДанныеКоманды = "start" Тогда	
			РезультатВыполнения = ВыполнитьКомандуStart(Токен,Отправитель);
		ИначеЕсли ДанныеКоманды = "ping" Тогда
			РезультатВыполнения = ВыполнитьКомандуPing(Токен,Отправитель);
		ИначеЕсли ДанныеКоманды = "currentTasks" Тогда
			РезультатВыполнения = ВыполнитьКомандуCurrentTasks(Токен,Отправитель);
		Иначе
			ТекстОтвета = "Я тебя не понимаю(";
		КонецЕсли;
		
		//РезультатВыполнения = ОтправитьНачальноеМеню(Токен,,Отправитель.id);
		
	Иначе
		КомандаОбъект = ПолучитьСтруктурированныеДанныеJSON(РасшифроватьКоманду(Команда.c));
		Если Не КомандаОбъект = Неопределено Тогда
			ИмяКоманды = КомандаОбъект.c;
			
			ПараметрыКоманды = ?(КомандаОбъект.Свойство("p"),КомандаОбъект.p,Неопределено);			
			Если ИмяКоманды = "ping" Тогда
				РезультатВыполнения = ВыполнитьКомандуPing(Токен,Отправитель);
			ИначеЕсли ИмяКоманды = "start" Тогда
				РезультатВыполнения = ВыполнитьКомандуStart(Токен,Отправитель);
			ИначеЕсли ИмяКоманды = "currentTasks" Тогда
				РезультатВыполнения = ВыполнитьКомандуCurrentTasks(Токен,Отправитель,,Истина,ПараметрыКоманды);
			ИначеЕсли ИмяКоманды = "getLicense" Тогда
				РезультатВыполнения = ВыполнитьКомандуGetLicense(Токен,Отправитель,,ПараметрыКоманды);
			КонецЕсли;
		Иначе
			РезультатВыполнения = Новый Структура("Ответ,Ошибка","Команда не найдена",Истина);
		КонецЕсли;
		
		//РезультатВыполнения = ОтправитьНачальноеМеню(Токен,,Отправитель.id);
		
	КонецЕсли;
	
	Возврат РезультатВыполнения;
	
КонецФункции

//Читает JSON в структуру
Функция ПолучитьСтруктурированныеДанныеJSON(СтрокаJSON)
	Попытка
		Чтение = Новый ЧтениеJSON;
		Чтение.УстановитьСтроку(СтрокаJSON);
		Данные = ПрочитатьJSON(Чтение,Ложь);
		Чтение.Закрыть();
	Исключение
		Данные = Неопределено;
	КонецПопытки;
	
	Возврат Данные;
КонецФункции

//Формирует объект команды "currentTasks" с введенными параметрами
Функция ПолучитьДанныеКомандыCurrentTasks(Исполнитель=Неопределено,Страница=Неопределено,ChatID=0)
	ДанныеКомандыОбъект = Новый Структура;
	ДанныеКомандыОбъект.Вставить("c","currentTasks");
	ПараметрыКоманды = Новый Структура;
	Если Не Исполнитель = Неопределено Тогда
		//TODO
		//DEBUG
		ПараметрыКоманды.Вставить("u",?(ТипЗнч(Исполнитель)=Тип("СправочникСсылка.ФизическиеЛица"),Формат(Исполнитель.УникальныйИдентификатор()),Исполнитель));
		//ПараметрыКоманды.Вставить("u",?(ТипЗнч(Исполнитель)=Тип("СправочникСсылка.ФизическиеЛица"),"",Исполнитель));
	КонецЕсли;
	Если Не Страница = Неопределено Тогда
		ПараметрыКоманды.Вставить("pg",Страница);
	КонецЕсли;
	ДанныеКомандыОбъект.Вставить("p",ПараметрыКоманды);
	
	//Возврат ДанныеКомандыОбъект;
	КомандаВФорматеJSON = ПолучитьОбъектJSONСтрокой(ДанныеКомандыОбъект);
	
	ДанныеCallbackQuery = Новый Структура;
	ДанныеCallbackQuery.Вставить("c",ПолучитьХэшКоманды(КомандаВФорматеJSON,ChatID));
	
	Возврат ПолучитьОбъектJSONСтрокой(ДанныеCallbackQuery);
КонецФункции

//Формирует объект команды "getLicense" с введенными параметрами
// 
// Параметры:
//  Подкоманда - Число - определяет следующее действие команды: Неопределено - вывод клиентов для выбора, 1 - вывод номенклатуры для выбора, 2 - вывод реализация для выбора, 3 - вывод лицензии
//  Клиент - СправочникСсылка.Клиенты,СправочникСсылка.Контрагенты - Клиент или контрагент, на которого реализована лицензия
//  Страница - Число - Номер страницы отображения списка
//  Номенклатура - СправочникСсылка.Номенклатура - Номенклатура, для которой ищется лицензия
//  Документ - ДокументСсылка.РеализацияЛицензий - Документ реализации со списком лицензий
//  Лицензия - Строка - УникальныйИдентификатор представления выбранной лицензии
//  ChatID - Число - ID чата для вывода. 0 - вывод для всех пользователей.
// 
// Возвращаемое значение:
//  Строка - JSON команды для передачи в callback_data кнопки Telegram
Функция ПолучитьДанныеКомандыGetLicense(Подкоманда=Неопределено,Клиент=Неопределено,Страница=Неопределено,Номенклатура=Неопределено,Документ=Неопределено,Лицензия=Неопределено,ChatID=0)
	ДанныеКомандыОбъект = Новый Структура;
	ДанныеКомандыОбъект.Вставить("c","getLicense");
	ПараметрыКоманды = Новый Структура;
	Если Не Подкоманда = Неопределено Тогда
		ПараметрыКоманды.Вставить("ac",Подкоманда);
	КонецЕсли;
	Если Не Клиент = Неопределено Тогда
		//TODO
		//DEBUG
		ПараметрыКоманды.Вставить("ou",?(ТипЗнч(Клиент)=Тип("СправочникСсылка.Клиенты"),Формат(Клиент.УникальныйИдентификатор()),Клиент));
	КонецЕсли;
	Если Не Страница = Неопределено Тогда
		ПараметрыКоманды.Вставить("pg",Страница);
	КонецЕсли;
	Если Не Лицензия = Неопределено Тогда
		ПараметрыКоманды.Вставить("l",Лицензия);
	КонецЕсли;
	Если Не Номенклатура = Неопределено Тогда
		ПараметрыКоманды.Вставить("w",?(ТипЗнч(Номенклатура)=Тип("СправочникСсылка.Номенклатура"),Формат(Номенклатура.УникальныйИдентификатор()),Номенклатура));
	КонецЕсли;
	Если Не Документ = Неопределено Тогда
		ПараметрыКоманды.Вставить("li",?(ТипЗнч(Документ)=Тип("ДокументСсылка.РеализацияЛицензий"),Формат(Документ.УникальныйИдентификатор()),Документ))
	КонецЕсли;
	ДанныеКомандыОбъект.Вставить("p",ПараметрыКоманды);
	
	//Возврат ДанныеКомандыОбъект;
	КомандаВФорматеJSON = ПолучитьОбъектJSONСтрокой(ДанныеКомандыОбъект);
	
	ДанныеCallbackQuery = Новый Структура;
	ДанныеCallbackQuery.Вставить("c",ПолучитьХэшКоманды(КомандаВФорматеJSON,ChatID));
	
	Возврат ПолучитьОбъектJSONСтрокой(ДанныеCallbackQuery);
КонецФункции

//Возвращает JSON в строковом виде из структуры
Функция ПолучитьОбъектJSONСтрокой(Структура)
	ДанныеКомандыJSON = Новый ЗаписьJSON;	
	ДанныеКомандыJSON.УстановитьСтроку(Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Нет,,Ложь,ЭкранированиеСимволовJSON.Нет));
	ЗаписатьJSON(ДанныеКомандыJSON,Структура);
	Возврат ДанныеКомандыJSON.Закрыть();	
КонецФункции

//Устанавлиевает подключение с API Telegram, если оно не установлено
Процедура УстановитьСтандартноеПодключение(Подключение)
	Если Подключение = Неопределено Тогда
		Подключение = Новый HTTPСоединение("api.telegram.org", 443,,,,, Новый ЗащищенноеСоединениеOpenSSL());	
	КонецЕсли;
КонецПроцедуры

//Запрашивает исполнителя заявок для вывода списка
Функция CurrentTasksОтправитьЗапросИсполнителя(Токен,Отправитель,Подключение=Неопределено)
	УстановитьСтандартноеПодключение(Подключение);
	МассивСтрокКнопок = Новый Массив;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ФИОФизическихЛицСрезПоследних.ФизическоеЛицо КАК Исполнитель,
		|	ФИОФизическихЛицСрезПоследних.Фамилия + "" "" + ПОДСТРОКА(ФИОФизическихЛицСрезПоследних.Имя, 1, 1) + "". "" + ПОДСТРОКА(ФИОФизическихЛицСрезПоследних.Отчество, 1, 1) + ""."" КАК ФИО
		|ИЗ
		|	РегистрСведений.ФИОФизическихЛиц.СрезПоследних КАК ФИОФизическихЛицСрезПоследних
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Пользователи КАК Пользователи
		|		ПО ФИОФизическихЛицСрезПоследних.ФизическоеЛицо = Пользователи.ФизическоеЛицо";
	
	РезультатЗапроса = Запрос.Выполнить();
	//КоличествоИсполнителей = РезультатЗапроса.Выгрузить().Количество();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		МассивКнопок = Новый Массив;
		ПараметрыКнопки = Новый Структура();
		ПараметрыКнопки.Вставить("text",ВыборкаДетальныеЗаписи.ФИО);
		ПараметрыКнопки.Вставить("callback_data",ПолучитьДанныеКомандыCurrentTasks(ВыборкаДетальныеЗаписи.Исполнитель,1,Отправитель.id));
		МассивКнопок.Добавить(ПараметрыКнопки);
		МассивСтрокКнопок.Добавить(МассивКнопок);
	КонецЦикла;        	
	
	МассивКнопок = Новый Массив;
	
	ПараметрыКнопки = Новый Структура();
	ПараметрыКнопки.Вставить("text","<не установлен>");
	ПараметрыКнопки.Вставить("callback_data",ПолучитьДанныеКомандыCurrentTasks("_undefined_",1));
	МассивКнопок.Добавить(ПараметрыКнопки);
	
	ПараметрыКнопки = Новый Структура();
	ПараметрыКнопки.Вставить("text","<Все>");
	ПараметрыКнопки.Вставить("callback_data",ПолучитьДанныеКомандыCurrentTasks("_all_",1));
	МассивКнопок.Добавить(ПараметрыКнопки);
	
	МассивСтрокКнопок.Добавить(МассивКнопок);
	
	Клавиатура = СгенерироватьИнлайнКлавиатуру(МассивСтрокКнопок);
	Ответ = ОтправитьКлавиатуру(Токен,Подключение,Отправитель.id,Клавиатура,"Кто исполнитель?");
КонецФункции

Функция СгенерироватьИнлайнКлавиаутурПоПараметрам(Параметры)
	Клавиатура = Новый Структура("inline_keyboard");
	
	Клавиатура.inline_keyboard = Параметры;
	
	КлавиатураJSON = Новый ЗаписьJSON;
	КлавиатураJSON.УстановитьСтроку(Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Unix,,,ЭкранированиеСимволовJSON.СимволыВнеBMP));
	ЗаписатьJSON(КлавиатураJSON,Клавиатура);

	Возврат СтрЗаменить(КлавиатураJSON.Закрыть(),"\""","");
КонецФункции

Функция ОтправитьКлавиатуру(Токен,Подключение=Неопределено,ChatID,Клавиатура,Сообщение="")
	Ответ = "";
	Ошибка = Ложь;
	
	ТекстЗапроса = "/bot"+Токен + "/sendmessage?chat_id=" + Формат(ChatID,"ЧГ=") + "&text=" + Сообщение;
	
	ТекстЗапроса = ТекстЗапроса + "&reply_markup=" + Клавиатура;
	
	Запрос = Новый HTTPЗапрос(ТекстЗапроса);
	
	Попытка
		Ответ = Подключение.Получить(Запрос);
	Исключение
		Ошибка = Истина;
	КонецПопытки;
	
	Возврат Новый Структура("Ответ,Ошибка",Ответ,Ошибка);
КонецФункции

Функция ПолучитьХэшКоманды(КомандаВФорматеJSON,ChatID=0)
	Хэш = "";
	Если ЗначениеЗаполнено(ChatID) Тогда
		Хэш = Формат(Новый УникальныйИдентификатор());
		МенеджерЗаписи = РегистрыСведений.РасшифровкаКомандTelegram.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Команда = КомандаВФорматеJSON;
		МенеджерЗаписи.Получатель = ChatID;
		МенеджерЗаписи.Хэш = Хэш;
		МенеджерЗаписи.ДатаФормирования = ТекущаяДата();
		МенеджерЗаписи.Записать();
	Иначе
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	РасшифровкаКомандTelegram.Хэш КАК Хэш
			|ИЗ
			|	РегистрСведений.РасшифровкаКомандTelegram КАК РасшифровкаКомандTelegram
			|ГДЕ
			|	РасшифровкаКомандTelegram.Получатель = &Получатель
			|	И РасшифровкаКомандTelegram.Команда ПОДОБНО &Команда
			|	И РасшифровкаКомандTelegram.ДатаФормирования >= &ДатаФормирования";
		
		Запрос.УстановитьПараметр("Команда", КомандаВФорматеJSON);
		Запрос.УстановитьПараметр("Получатель", ChatID);
		Запрос.УстановитьПараметр("ДатаФормирования", ТекущаяДата() - 3600 * 24);	//Используем только команды, сформированные в течение суток
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Если ВыборкаДетальныеЗаписи.Следующий() Тогда
			Хэш = ВыборкаДетальныеЗаписи.Хэш;
		Иначе
			Хэш = Формат(Новый УникальныйИдентификатор());
			МенеджерЗаписи = РегистрыСведений.РасшифровкаКомандTelegram.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.Команда = КомандаВФорматеJSON;
			МенеджерЗаписи.Получатель = ChatID;
			МенеджерЗаписи.Хэш = Хэш;
			МенеджерЗаписи.ДатаФормирования = ТекущаяДата();
			МенеджерЗаписи.Записать();
		КонецЕсли;
	КонецЕсли;
	Возврат Хэш;
КонецФункции

//Получает команду в виде строкового JSON
Функция РасшифроватьКоманду(Хэш)
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РасшифровкаКомандTelegram.Команда КАК Команда
		|ИЗ
		|	РегистрСведений.РасшифровкаКомандTelegram КАК РасшифровкаКомандTelegram
		|ГДЕ
		|	РасшифровкаКомандTelegram.Хэш = &Хэш
		|	И РасшифровкаКомандTelegram.ДатаФормирования >= &ДатаФормирования";
	
	Запрос.УстановитьПараметр("Хэш", Хэш);
	Запрос.УстановитьПараметр("ДатаФормирования", ТекущаяДата() - 3600 * 24);	//Используем только команды, сформированные в течение суток
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат ВыборкаДетальныеЗаписи.Команда;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

// Производит оповещение о создании или изменении заявки
//
// Параметры:
//  Заявка - ДокументСсылка.ЗаявкиКлиентов - документ, по которому производится оповещение
//  Параметры - Структура:
//	  * Новый - булево - признак того, что создана новая заявка
//    * СменаИсполнителя - булево - признак того, что изменился исполнитель в заявке
//    * Исполнитель - текущий исполнитель заявки		
//    * СтарыйИсполнитель - СправочникСсылка.ФизическиеЛица - если менялся исполнитель, то передается предыдущий исполнитель
//  Токен - строка - токен бота Telegram
//  Подключение - HTTPСоединение - соединение с API Telegram 
//
Функция РазослатьЗаявку(Заявка,Параметры,Токен=Неопределено,Подключение=Неопределено) Экспорт
	Ошибка = Ложь;
	Ответ = "";
	НоваяЗаявка = Параметры.Новый;
	СменаИсполнителя = ?(НоваяЗаявка,Ложь,Параметры.СменаИсполнителя);
	Исполнитель = Параметры.Исполнитель;
	Если СменаИсполнителя Тогда
		СтарыйИсполнитель = Параметры.СтарыйИсполнитель
	КонецЕсли;	
	Если Токен = Неопределено Тогда
		Токен = Константы.ТокенTelegram.Получить();
	КонецЕсли;
	Если Подключение = Неопределено Тогда
		УстановитьСтандартноеПодключение(Подключение); 
	КонецЕсли;

	//Исполнитель = Заявка.ОтветственноеЛицо;
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗаявкиКлиентов.ДатаОткрытия КАК ДатаОткрытия,
		|	ЗаявкиКлиентов.Клиент КАК Клиент,
		|	ЗаявкиКлиентов.Приоритет КАК Приоритет,
		|	ЗаявкиКлиентов.ОтветственноеЛицо КАК ОтветственноеЛицо,
		|	ЗаявкиКлиентов.ТекстЗаявки КАК ТекстЗаявки,
		|	ЗаявкиКлиентов.ТемаЗаявки КАК ТемаЗаявки,
		|   ЗаявкиКлиентов.Номер КАК НомерЗаявки
		|ИЗ
		|	Документ.ЗаявкиКлиентов КАК ЗаявкиКлиентов
		|ГДЕ
		|   ЗаявкиКлиентов.Ссылка = &Заявка
		|	И ЗаявкиКлиентов.Статус = &Статус
		|&СтрокаИсполнитель";
	Запрос.УстановитьПараметр("Статус", Перечисления.СтатусыЗаявок.Открыта);
	Запрос.УстановитьПараметр("Заявка",Заявка);
	
	Если Не Исполнитель = Неопределено Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"&СтрокаИсполнитель","И ЗаявкиКлиентов.ОтветственноеЛицо = &Исполнитель");
		Запрос.УстановитьПараметр("Исполнитель",Исполнитель);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"&СтрокаИсполнитель","");
	КонецЕсли;
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
	
		Если НоваяЗаявка Тогда
			СообщениеИсполнителю = 
				"Получена новая заявка " + "№" + Формат(Число(ВыборкаДетальныеЗаписи.НомерЗаявки),"ЧГ=")
				+ Символы.ПС + "**********************" + Символы.ПС
				+ Символы.ПС + "Исполнитель: " + ?(ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.ОтветственноеЛицо),ВыборкаДетальныеЗаписи.ОтветственноеЛицо,"<не указан>")
				+ Символы.ПС + "Клиент: " + ВыборкаДетальныеЗаписи.Клиент
				+ Символы.ПС + "Тема: " + ВыборкаДетальныеЗаписи.ТемаЗаявки
				+ Символы.ПС + "---" + Символы.ПС + ПолучитьТекстЗаявки(ВыборкаДетальныеЗаписи.ТекстЗаявки);
						
		ИначеЕсли СменаИсполнителя Тогда
			СообщениеИсполнителю = 
				"Передана заявка " + "№" + Формат(Число(ВыборкаДетальныеЗаписи.НомерЗаявки),"ЧГ=")
				+ Символы.ПС + "Предыдущий исполнитель: " + ?(ЗначениеЗаполнено(СтарыйИсполнитель),СтарыйИсполнитель,"<не указан>")  
				+ Символы.ПС + "**********************" + Символы.ПС
				+ Символы.ПС + "Исполнитель: " + ?(ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.ОтветственноеЛицо),ВыборкаДетальныеЗаписи.ОтветственноеЛицо,"<не указан>")
				+ Символы.ПС + "Клиент: " + ВыборкаДетальныеЗаписи.Клиент
				+ Символы.ПС + "Тема: " + ВыборкаДетальныеЗаписи.ТемаЗаявки
				+ Символы.ПС + "---" + Символы.ПС + ПолучитьТекстЗаявки(ВыборкаДетальныеЗаписи.ТекстЗаявки);
			СообщениеСтаромуИсполнителю = 
				"Отдана заявка " + "№" + Формат(Число(ВыборкаДетальныеЗаписи.НомерЗаявки),"ЧГ=")
				+ Символы.ПС + "Новый исполнитель: " + ?(ЗначениеЗаполнено(Исполнитель),Исполнитель,"<не указан>")  
				+ Символы.ПС + "**********************" + Символы.ПС
				+ Символы.ПС + "Исполнитель: " + ?(ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.ОтветственноеЛицо),ВыборкаДетальныеЗаписи.ОтветственноеЛицо,"<не указан>")
				+ Символы.ПС + "Клиент: " + ВыборкаДетальныеЗаписи.Клиент
				+ Символы.ПС + "Тема: " + ВыборкаДетальныеЗаписи.ТемаЗаявки
				+ Символы.ПС + "---" + Символы.ПС + ПолучитьТекстЗаявки(ВыборкаДетальныеЗаписи.ТекстЗаявки);
		Иначе
			СообщениеИсполнителю = 
				"Обновлена заявка " + "№" + Формат(Число(ВыборкаДетальныеЗаписи.НомерЗаявки),"ЧГ=")
				+ Символы.ПС + "**********************" + Символы.ПС
				+ Символы.ПС + "Исполнитель: " + ?(ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.ОтветственноеЛицо),ВыборкаДетальныеЗаписи.ОтветственноеЛицо,"<не указан>")
				+ Символы.ПС + "Клиент: " + ВыборкаДетальныеЗаписи.Клиент
				+ Символы.ПС + "Тема: " + ВыборкаДетальныеЗаписи.ТемаЗаявки
				+ Символы.ПС + "---" + Символы.ПС + ПолучитьТекстЗаявки(ВыборкаДетальныеЗаписи.ТекстЗаявки);
		КонецЕсли;
		
		Если СменаИсполнителя Тогда
			СписокИсключений = Новый Массив;
			СписокИсключений.Добавить(Исполнитель);
			СписокПолучателей = ПолучитьIDСотрудников(СтарыйИсполнитель,СписокИсключений);
			Для Каждого ПолучательID Из СписокПолучателей Цикл
				ТекстЗапроса = "/bot"+Токен + "/sendmessage?chat_id=" + Формат(ПолучательID,"ЧГ=") + "&text=" + СообщениеСтаромуИсполнителю;
	
				Запрос = Новый HTTPЗапрос(ТекстЗапроса);
				Попытка
					Подключение.Получить(Запрос);
				Исключение
					Ошибка = Истина;
					Возврат Новый Структура("Ответ,Ошибка",Ответ,Ошибка);
				КонецПопытки;
			КонецЦикла;
			
			СписокИсключений.Очистить();
			СписокИсключений.Добавить(СтарыйИсполнитель);
			СписокПолучателей = ПолучитьIDСотрудников(Исполнитель,СписокИсключений);
		Иначе
			СписокПолучателей = ПолучитьIDСотрудников(Исполнитель);
		КонецЕсли;
			
	
		Для Каждого ПолучательID Из СписокПолучателей Цикл
			ТекстЗапроса = "/bot"+Токен + "/sendmessage?chat_id=" + Формат(ПолучательID,"ЧГ=") + "&text=" + СообщениеИсполнителю;

			Запрос = Новый HTTPЗапрос(ТекстЗапроса);
			Попытка
				Подключение.Получить(Запрос);
			Исключение
				Ошибка = Истина;
				Возврат Новый Структура("Ответ,Ошибка",Ответ,Ошибка);
			КонецПопытки;
		КонецЦикла;
		
	КонецЕсли;
	
КонецФункции

Функция ПолучитьIDСотрудников(Сотрудник,СписокИсключений=Неопределено)
	Если СписокИсключений = Неопределено Тогда
		СписокИсключений = Новый Массив;
	КонецЕсли;
	Запрос = Новый Запрос;	
	Запрос.УстановитьПараметр("ФизическоеЛицо", Сотрудник);
	Запрос.УстановитьПараметр("СписокИсключений", СписокИсключений);
	 
	Если ЗначениеЗаполнено(Сотрудник) Тогда
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПользователиБотаTelegram.UserID КАК UserID
		|ИЗ
		|	РегистрСведений.ПользователиБотаTelegram КАК ПользователиБотаTelegram
		|ГДЕ
		|	НЕ ПользователиБотаTelegram.is_bot
		|	И ПользователиБотаTelegram.ФизическоеЛицо = &ФизическоеЛицо
		|	И ПользователиБотаTelegram.ФизическоеЛицо НЕ В (&СписокИсключений)";
	Иначе
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПользователиБотаTelegram.UserID КАК UserID
		|ИЗ
		|	РегистрСведений.ПользователиБотаTelegram КАК ПользователиБотаTelegram
		|ГДЕ
		|	НЕ ПользователиБотаTelegram.is_bot
		|   И ПользователиБотаTelegram.ФизическоеЛицо НЕ В (&СписокИсключений)";
	КонецЕсли;
	 
	РезультатЗапроса = Запрос.Выполнить();
	
	Результат = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("UserID");
	Возврат Результат;
КонецФункции
