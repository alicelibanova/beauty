﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	НовоеОбсуждение = НовоеОбсуждение(ПараметрКоманды);
	
	Если НовоеОбсуждение = "Недоступно" Или НовоеОбсуждение = "НеПодключеноНетПравНаПодключение" Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Использование обсуждений недоступно. Обратитесь к администратору.';
										|en = 'Conversations are not available. Contact the Administrator.'"));
		Возврат;
	ИначеЕсли НовоеОбсуждение = "НеПодключеноВозможноПодключить" Тогда
		ПредлагатьОбсужденияТекст = 
			НСтр("ru = 'Включить обсуждения?
				|
				|С их помощью пользователи смогут отправлять друг другу текстовые сообщения 
				|и совершать видеозвонки, создавать тематические обсуждения и вести переписку по документам.';
				|en = 'Do you want to enable conversations?
				|
				|With them, users will be able to exchange text messages, make video calls,
				|create themed conversations, and correspond on documents.'");
		ОповещениеОЗавершении = Новый ОписаниеОповещения("ПредлагатьОбсужденияЗавершение", ЭтотОбъект);
		
		ПоказатьВопрос(ОповещениеОЗавершении, ПредлагатьОбсужденияТекст, РежимДиалогаВопрос.ДаНет);
		Возврат;
	КонецЕсли;
	
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(НовоеОбсуждение);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПредлагатьОбсужденияЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ОбсужденияСлужебныйКлиент.ПоказатьПодключение();
	
КонецПроцедуры

&НаСервере
Функция НовоеОбсуждение(ПользовательСсылка)
	
	Если Не ОбсужденияСлужебныйВызовСервера.Подключены() Тогда
		Если ПравоДоступа("РегистрацияИнформационнойБазыСистемыВзаимодействия", Метаданные) Тогда 
			Возврат "НеПодключеноВозможноПодключить";
		Иначе 
			Возврат "НеПодключеноНетПравНаПодключение";
		КонецЕсли;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	ИдентификаторПользователяИнформационнойБазы = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
		ПользовательСсылка, "ИдентификаторПользователяИБ");
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Не ЗначениеЗаполнено(ИдентификаторПользователяИнформационнойБазы) Тогда
		Возврат "Недоступно";
	КонецЕсли;
	
	Попытка
		ИдентификаторПользователяСВ = СистемаВзаимодействия.ПолучитьИдентификаторПользователя(
			ИдентификаторПользователяИнформационнойБазы);
	Исключение
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Для начала обсуждения необходимо, чтобы пользователь %1
			           |хотя бы один раз запустил программу.';
			           |en = 'To start a conversation, user ""%1""
			           |must run the application at least once.'"),
			ПользовательСсылка);
	КонецПопытки;
	
	Если ИдентификаторПользователяСВ = СистемаВзаимодействия.ИдентификаторТекущегоПользователя() Тогда 
		ВызватьИсключение НСтр("ru = 'Для начала обсуждения выберите другого пользователя.';
								|en = 'Select another user to start the conversation.'");
	КонецЕсли;
	
	Обсуждение = СистемаВзаимодействия.СоздатьОбсуждение();
	Обсуждение.Групповое = Ложь;
	Обсуждение.Участники.Добавить(СистемаВзаимодействия.ИдентификаторТекущегоПользователя());
	Обсуждение.Участники.Добавить(ИдентификаторПользователяСВ);
	Обсуждение.Записать();
	
	Возврат ПолучитьНавигационнуюСсылку(Обсуждение.Идентификатор);
	
КонецФункции

#КонецОбласти
