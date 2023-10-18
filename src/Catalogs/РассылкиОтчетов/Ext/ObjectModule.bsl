﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	Если ОбменДанными.Загрузка Тогда 
		Возврат;
	ИначеЕсли ЭтоГруппа Тогда 
		Личная = РассылкаОтчетов.ПринадлежитГруппеЛичныхРассылок(Родитель);
		Возврат;
	КонецЕсли;
	
	// Создание регламентного задания - пустышки (для хранения его идентификатора в данных).
	УстановитьПривилегированныйРежим(Истина);
	
	РегламентныеЗаданияСервер.ЗаблокироватьРегламентноеЗадание(РегламентноеЗадание);

	Задание = РегламентныеЗаданияСервер.Задание(РегламентноеЗадание);
	Если Задание = Неопределено Тогда
		
		ПараметрыЗадания = Новый Структура();
		ПараметрыЗадания.Вставить("Метаданные", Метаданные.РегламентныеЗадания.РассылкаОтчетов);
		ПараметрыЗадания.Вставить("ИмяМетода", Метаданные.РегламентныеЗадания.РассылкаОтчетов.ИмяМетода);
		ПараметрыЗадания.Вставить("ИмяПользователя", РассылкаОтчетов.ИмяПользователяИБ(Автор));
		ПараметрыЗадания.Вставить("Использование", Ложь);
		ПараметрыЗадания.Вставить("Наименование", ПредставлениеЗаданияПоРассылке(Наименование));
 		Задание = РегламентныеЗаданияСервер.ДобавитьЗадание(ПараметрыЗадания);
		
		РегламентноеЗадание = РегламентныеЗаданияСервер.УникальныйИдентификатор(Задание);
		РегламентныеЗаданияСервер.ЗаблокироватьРегламентноеЗадание(РегламентноеЗадание);
	КонецЕсли;

	УстановитьПривилегированныйРежим(Ложь);
	
	// Соответствие флага подготовленности рассылки и задания пометке удаления рассылки.
	Если ПометкаУдаления И Подготовлена Тогда
		Подготовлена = Ложь;
	КонецЕсли;
	
	// Соответствие группы признаку личной рассылки по электронной почте.
	// Пользовательские проверки расположены в форме элемента.
	// Эти проверки обеспечивают жесткие привязки.
	ГруппаВходитВИерархиюЛичныхРассылок = РассылкаОтчетов.ПринадлежитГруппеЛичныхРассылок(Родитель);
	Если Личная <> ГруппаВходитВИерархиюЛичныхРассылок Тогда
		Родитель = ?(Личная, Справочники.РассылкиОтчетов.ЛичныеРассылки, Справочники.РассылкиОтчетов.ПустаяСсылка());
	КонецЕсли;
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(РегламентноеЗадание) Тогда
		УстановитьПривилегированныйРежим(Истина);
		РегламентныеЗаданияСервер.УдалитьЗадание(РегламентноеЗадание);
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьДанныеИзБезопасногоХранилища(Ссылка);
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	РегламентноеЗадание = Неопределено;
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	// Вызывается непосредственно после записи объекта в базу данных.
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	Задание = РегламентныеЗаданияСервер.Задание(РегламентноеЗадание);	
	Если Задание <> Неопределено Тогда
		Изменения = Новый Структура;
		
		ВключитьЗадание = ВыполнятьПоРасписанию И Подготовлена;
		Если Задание.Использование <> ВключитьЗадание Тогда
			Изменения.Вставить("Использование", ВключитьЗадание);
		КонецЕсли;
		
		// Расписание устанавливается в форме элемента.
		Если ДополнительныеСвойства.Свойство("Расписание") 
			И ТипЗнч(ДополнительныеСвойства.Расписание) = Тип("РасписаниеРегламентногоЗадания")
			И Строка(ДополнительныеСвойства.Расписание) <> Строка(Задание.Расписание) Тогда
			Изменения.Вставить("Расписание", ДополнительныеСвойства.Расписание);
		КонецЕсли;
		
		ИмяПользователя = РассылкаОтчетов.ИмяПользователяИБ(Автор);
		Если Задание.ИмяПользователя <> ИмяПользователя Тогда
			Изменения.Вставить("ИмяПользователя", ИмяПользователя);
		КонецЕсли;
		
		Если ТипЗнч(Задание) = Тип("РегламентноеЗадание") Тогда
			НаименованиеЗадания = ПредставлениеЗаданияПоРассылке(Наименование);
			Если Задание.Наименование <> НаименованиеЗадания Тогда
				Изменения.Вставить("Наименование", НаименованиеЗадания);
			КонецЕсли;
		КонецЕсли;
		
		Если Задание.Параметры.Количество() <> 1 ИЛИ Задание.Параметры[0] <> Ссылка Тогда
			ПараметрыЗадания = Новый Массив;
			ПараметрыЗадания.Добавить(Ссылка);
			Изменения.Вставить("Параметры", ПараметрыЗадания);
		КонецЕсли;
			
		Если Изменения.Количество() > 0 Тогда
			РегламентныеЗаданияСервер.ИзменитьЗадание(РегламентноеЗадание, Изменения);
		КонецЕсли;
	КонецЕсли;
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты) 
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Автор) Тогда 
		Отказ = Истина;
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Поле ""Ответственный"" не заполнено.';
				|en = 'The ""Person responsible"" field is required.'"), ЭтотОбъект, "Автор",, Отказ);
	КонецЕсли;
		
	ГруппаВходитВИерархиюЛичныхРассылок = РассылкаОтчетов.ПринадлежитГруппеЛичныхРассылок(Родитель);
		
	Если НЕ Личная И НЕ Персонализирована И ГруппаВходитВИерархиюЛичныхРассылок Тогда
		Отказ = Истина;
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Для рассылок отчетов ""Отчеты указанным получателям"" нельзя указывать группу, входящую в ""Личные рассылки"".';
				|en = 'You cannot specify a group included in ""Personal distributions"" for the ""Reports to specified recipients"" distributions.'"), ЭтотОбъект, "Родитель",, Отказ);
	ИначеЕсли НЕ Личная И Персонализирована И ГруппаВходитВИерархиюЛичныхРассылок Тогда
		Отказ = Истина;
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Для рассылок отчетов ""Свой отчет для каждого получателя"" нельзя указывать группу, входящую в ""Личные рассылки"".';
				|en = 'You cannot specify a group included in ""Personal distributions"" for the ""Individual report for each recipient"" distributions.'"), ЭтотОбъект, "Родитель",, Отказ);
	ИначеЕсли Личная И НЕ ГруппаВходитВИерархиюЛичныхРассылок  Тогда
		Отказ = Истина;
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Для личных рассылок отчетов укажите группу ""Личные рассылки"" или ее подгруппу.';
				|en = 'Specify a ""Personal distributions"" group or its subgroup for personal report distributions.'"), ЭтотОбъект, "Родитель",, Отказ);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПредставлениеЗаданияПоРассылке(НаименованиеРассылки)
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Рассылка отчетов: %1';
																		|en = 'Report distribution: %1'"), СокрЛП(НаименованиеРассылки));
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли